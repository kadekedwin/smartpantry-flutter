import 'package:flutter/material.dart';
import '../../../services/api_client.dart';
import '../../../services/shopping_service.dart';

class AddShoppingSheet extends StatefulWidget {
  const AddShoppingSheet({super.key});

  @override
  State<AddShoppingSheet> createState() => _AddShoppingSheetState();
}

class _AddShoppingSheetState extends State<AddShoppingSheet> {
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController(text: '1');
  final _unitController = TextEditingController(text: 'pcs');
  bool _loading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _unitController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_loading) return;
    if (_nameController.text.trim().isEmpty) return;
    setState(() => _loading = true);
    try {
      await ShoppingService.create(
        name: _nameController.text.trim(),
        quantity: double.tryParse(_quantityController.text) ?? 1,
        unit: _unitController.text.trim(),
      );
      if (!mounted) return;
      Navigator.pop(context, true);
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
            'Tambah ke Daftar Belanja',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Nama',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _quantityController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Jumlah',
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
                  : const Text('Tambah'),
            ),
          ),
        ],
      ),
    );
  }
}
