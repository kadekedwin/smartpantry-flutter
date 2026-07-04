import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../data/models/shopping_item.dart';
import '../../../services/shopping_service.dart';
import '../../../services/inventory_service.dart';
import '../../../services/api_client.dart';
import 'widgets/shopping_list_item.dart';

class AddTab extends StatelessWidget {
  const AddTab({super.key});

  static const _green = Color(0xFF0F9F68);
  static const _bg = Color(0xFFF9FAFB);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: _bg,
        body: Column(
          children: [
            _buildHeader(context),
            Container(
              color: Colors.white,
              child: const TabBar(
                labelColor: _green,
                unselectedLabelColor: Color(0xFF9CA3AF),
                indicatorColor: _green,
                indicatorWeight: 2,
                tabs: [
                  Tab(text: 'Daftar Belanja'),
                  Tab(text: 'Input Langsung'),
                ],
              ),
            ),
            const Expanded(
              child: TabBarView(
                children: [
                  _ShoppingListView(),
                  _DirectInputView(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: _green,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        child: Stack(
          children: [
            Positioned(
              right: -50,
              top: -30,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.08),
                ),
              ),
            ),
            Positioned(
              right: 70,
              top: 20,
              child: Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.06),
                ),
              ),
            ),
            Positioned(
              left: -20,
              bottom: -40,
              child: Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.05),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(24, statusBarHeight + 20, 24, 28),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tambah Belanjaan',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Catat apa yang perlu dibeli',
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFFE5E7EB),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.add_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShoppingListView extends StatefulWidget {
  const _ShoppingListView();

  @override
  State<_ShoppingListView> createState() => _ShoppingListViewState();
}

class _ShoppingListViewState extends State<_ShoppingListView> {
  late Future<List<ShoppingItem>> _future;

  @override
  void initState() {
    super.initState();
    _future = ShoppingService.list();
  }

  void _reload() {
    setState(() {
      _future = ShoppingService.list();
    });
  }

  Future<void> _toggle(ShoppingItem item) async {
    final result = await showModalBottomSheet<_MoveToInventoryResult>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _MoveToInventorySheet(item: item),
    );
    if (result == null) return;
    try {
      await InventoryService.create(
        name: item.name,
        imageFile: result.imageFile,
        stock: item.quantity.round().clamp(1, 1 << 30),
        unit: item.unit,
        expiredAt: result.expiredAt,
        category: result.category,
      );
      await ShoppingService.toggle(item.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Dipindahkan ke inventory'),
          backgroundColor: Color(0xFF0F9F68),
        ),
      );
      _reload();
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal (${e.statusCode}): ${e.message}')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memindahkan: $e')),
      );
    }
  }

  Future<void> _showAddDialog() async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const _AddShoppingSheet(),
    );
    if (result == true) _reload();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: FutureBuilder<List<ShoppingItem>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            final err = snapshot.error;
            final msg = err is ApiException
                ? err.message
                : 'Tidak dapat terhubung ke server';
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(msg),
                  const SizedBox(height: 12),
                  TextButton(
                      onPressed: _reload, child: const Text('Coba lagi')),
                ],
              ),
            );
          }
          final items = snapshot.data ?? [];
          final notBought = items.where((e) => !e.isBought).toList();
          final bought = items.where((e) => e.isBought).toList();
          return RefreshIndicator(
            onRefresh: () async => _reload(),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
              children: [
                Text(
                  'BELUM DIBELI (${notBought.length})',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF9CA3AF),
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 12),
                ...notBought.map(
                  (item) => ShoppingListItem(
                    item: item,
                    onToggle: () => _toggle(item),
                  ),
                ),
                if (bought.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text(
                    'SUDAH DIBELI (${bought.length})',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF9CA3AF),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...bought.map(
                    (item) => ShoppingListItem(item: item),
                  ),
                ],
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        backgroundColor: const Color(0xFF0F9F68),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class _AddShoppingSheet extends StatefulWidget {
  const _AddShoppingSheet();

  @override
  State<_AddShoppingSheet> createState() => _AddShoppingSheetState();
}

class _AddShoppingSheetState extends State<_AddShoppingSheet> {
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
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
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

class _DirectInputView extends StatefulWidget {
  const _DirectInputView();

  @override
  State<_DirectInputView> createState() => _DirectInputViewState();
}

class _DirectInputViewState extends State<_DirectInputView> {
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
    final source = await _showImageSourceSheet(context);
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama tidak boleh kosong')),
      );
      return;
    }
    if (_imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Foto barang wajib diisi')),
      );
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
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
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
          _ImagePickerTile(
            file: _imageFile,
            onTap: _pickImage,
          ),
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

Future<ImageSource?> _showImageSourceSheet(BuildContext context) {
  return showModalBottomSheet<ImageSource>(
    context: context,
    builder: (ctx) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.photo_camera_rounded),
            title: const Text('Kamera'),
            onTap: () => Navigator.pop(ctx, ImageSource.camera),
          ),
          ListTile(
            leading: const Icon(Icons.photo_library_rounded),
            title: const Text('Galeri'),
            onTap: () => Navigator.pop(ctx, ImageSource.gallery),
          ),
        ],
      ),
    ),
  );
}

class _ImagePickerTile extends StatelessWidget {
  final File? file;
  final VoidCallback onTap;
  const _ImagePickerTile({required this.file, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: 160,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFF0FDF4),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        clipBehavior: Clip.antiAlias,
        child: file == null
            ? const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.photo_camera_rounded,
                      size: 36, color: Color(0xFF0F9F68)),
                  SizedBox(height: 8),
                  Text(
                    'Tambahkan foto barang',
                    style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF0F9F68),
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 2),
                  Text('Kamera / Galeri',
                      style:
                          TextStyle(fontSize: 11, color: Color(0xFF6B7280))),
                ],
              )
            : Stack(
                fit: StackFit.expand,
                children: [
                  Image.file(file!, fit: BoxFit.cover),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.55),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.edit_rounded,
                              size: 14, color: Colors.white),
                          SizedBox(width: 4),
                          Text('Ganti',
                              style: TextStyle(
                                  fontSize: 11, color: Colors.white)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _MoveToInventoryResult {
  final String category;
  final DateTime expiredAt;
  final File imageFile;
  _MoveToInventoryResult({
    required this.category,
    required this.expiredAt,
    required this.imageFile,
  });
}

class _MoveToInventorySheet extends StatefulWidget {
  final ShoppingItem item;
  const _MoveToInventorySheet({required this.item});

  @override
  State<_MoveToInventorySheet> createState() => _MoveToInventorySheetState();
}

class _MoveToInventorySheetState extends State<_MoveToInventorySheet> {
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
    final source = await _showImageSourceSheet(context);
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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Foto barang wajib diisi')),
      );
      return;
    }
    Navigator.pop(
      context,
      _MoveToInventoryResult(
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
          _ImagePickerTile(file: _imageFile, onTap: _pickImage),
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
