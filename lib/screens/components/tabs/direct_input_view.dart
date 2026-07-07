import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../services/api_client.dart';
import '../../../services/inventory_service.dart';
import 'image_picker_tile.dart';
import 'image_source_sheet.dart';

class DirectInputView extends StatefulWidget {
  const DirectInputView({super.key});

  @override
  State<DirectInputView> createState() => _DirectInputViewState();
}

class _DirectInputViewState extends State<DirectInputView> {
  final _nameController = TextEditingController();
  final _stockController = TextEditingController(text: '1');
  final _unitController = TextEditingController(text: 'pcs');
  String _category = 'kulkas';
  DateTime _expiredAt = DateTime.now().add(const Duration(days: 7));
  File? _imageFile;
  bool _loading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _stockController.dispose();
    _unitController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _expiredAt,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (picked != null) setState(() => _expiredAt = picked);
  }

  Future<void> _pickImage() async {
    final source = await showImageSourceSheet(context);
    if (source == null) return;
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: source,
      imageQuality: 85,
      maxWidth: 1600,
    );
    if (picked != null) {
      setState(() => _imageFile = File(picked.path));
    }
  }

  Future<void> _submit() async {
    if (_loading) return;
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Nama tidak boleh kosong')));
      return;
    }
    if (_imageFile == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Foto barang wajib diisi')));
      return;
    }
    setState(() => _loading = true);
    try {
      await InventoryService.create(
        name: _nameController.text.trim(),
        imageFile: _imageFile!,
        stock: int.tryParse(_stockController.text) ?? 1,
        unit: _unitController.text.trim(),
        expiredAt: _expiredAt,
        category: _category,
      );
      if (!mounted) return;
      _nameController.clear();
      _stockController.text = '1';
      _unitController.text = 'pcs';
      setState(() => _imageFile = null);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Barang berhasil ditambahkan'),
          backgroundColor: Color(0xFF0F9F68),
        ),
      );
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak dapat terhubung ke server')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateStr =
        '${_expiredAt.day.toString().padLeft(2, '0')}/${_expiredAt.month.toString().padLeft(2, '0')}/${_expiredAt.year}';
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ImagePickerTile(file: _imageFile, onTap: _pickImage),
          const SizedBox(height: 12),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Nama barang',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _stockController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Stok',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _unitController,
                  decoration: const InputDecoration(
                    labelText: 'Satuan',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: _category,
            decoration: const InputDecoration(
              labelText: 'Kategori',
              border: OutlineInputBorder(),
            ),
            items: const [
              DropdownMenuItem(value: 'kulkas', child: Text('Kulkas')),
              DropdownMenuItem(value: 'freezer', child: Text('Freezer')),
              DropdownMenuItem(value: 'rak_dapur', child: Text('Rak Dapur')),
            ],
            onChanged: (v) => setState(() => _category = v ?? 'kulkas'),
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: _pickDate,
            child: InputDecorator(
              decoration: const InputDecoration(
                labelText: 'Tanggal Kedaluwarsa',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_today, size: 18),
              ),
              child: Text(dateStr),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _loading ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F9F68),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: _loading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text('Simpan ke Inventory'),
            ),
          ),
        ],
      ),
    );
  }
}
