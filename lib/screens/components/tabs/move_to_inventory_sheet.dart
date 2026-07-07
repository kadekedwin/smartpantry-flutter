import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../data/models/shopping_item.dart';
import 'image_picker_tile.dart';
import 'image_source_sheet.dart';

class MoveToInventoryResult {
  final String category;
  final DateTime expiredAt;
  final File imageFile;

  MoveToInventoryResult({
    required this.category,
    required this.expiredAt,
    required this.imageFile,
  });
}

class MoveToInventorySheet extends StatefulWidget {
  final ShoppingItem item;

  const MoveToInventorySheet({super.key, required this.item});

  @override
  State<MoveToInventorySheet> createState() => _MoveToInventorySheetState();
}

class _MoveToInventorySheetState extends State<MoveToInventorySheet> {
  static const _green = Color(0xFF0F9F68);

  String _category = 'kulkas';
  DateTime _expiredAt = DateTime.now().add(const Duration(days: 7));
  File? _imageFile;

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

  void _submit() {
    if (_imageFile == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Foto barang wajib diisi')));
      return;
    }
    Navigator.pop(
      context,
      MoveToInventoryResult(
        category: _category,
        expiredAt: _expiredAt,
        imageFile: _imageFile!,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateStr =
        '${_expiredAt.day.toString().padLeft(2, '0')}/${_expiredAt.month.toString().padLeft(2, '0')}/${_expiredAt.year}';
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Simpan ke Inventory',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            '${widget.item.name} · ${widget.item.quantity.toStringAsFixed(widget.item.quantity.truncateToDouble() == widget.item.quantity ? 0 : 1)} ${widget.item.unit}',
            style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
          ),
          const SizedBox(height: 16),
          ImagePickerTile(file: _imageFile, onTap: _pickImage),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: _category,
            decoration: const InputDecoration(
              labelText: 'Simpan di',
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
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: _green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Pindahkan'),
            ),
          ),
        ],
      ),
    );
  }
}
