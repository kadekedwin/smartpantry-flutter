import 'package:flutter/material.dart';
import '../../../data/models/shopping_item.dart';
import '../../../services/shopping_service.dart';
import '../../../services/inventory_service.dart';
import '../../../services/api_client.dart';
import 'widgets/shopping_plan_card.dart';
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
    if (!item.isBought) {
      final result = await showModalBottomSheet<_MoveToInventoryResult>(
        context: context,
        isScrollControlled: true,
        builder: (_) => _MoveToInventorySheet(item: item),
      );
      if (result == null) return;
      try {
        await InventoryService.create(
          name: item.name,
          icon: result.icon,
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
      return;
    }

    try {
      await ShoppingService.toggle(item.id);
      _reload();
    } on ApiException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal (${e.statusCode}): ${e.message}')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memperbarui status: $e')),
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
          return RefreshIndicator(
            onRefresh: () async => _reload(),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
              children: [
                const ShoppingPlanCard(),
                const SizedBox(height: 24),
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
  final _iconController = TextEditingController(text: '📦');
  final _stockController = TextEditingController(text: '1');
  final _unitController = TextEditingController(text: 'pcs');
  String _category = 'kulkas';
  DateTime _expiredAt = DateTime.now().add(const Duration(days: 7));
  bool _loading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _iconController.dispose();
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

  Future<void> _submit() async {
    if (_loading) return;
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama tidak boleh kosong')),
      );
      return;
    }
    setState(() => _loading = true);
    try {
      await InventoryService.create(
        name: _nameController.text.trim(),
        icon: _iconController.text.trim().isEmpty
            ? '📦'
            : _iconController.text.trim(),
        stock: int.tryParse(_stockController.text) ?? 1,
        unit: _unitController.text.trim(),
        expiredAt: _expiredAt,
        category: _category,
      );
      if (!mounted) return;
      _nameController.clear();
      _iconController.text = '📦';
      _stockController.text = '1';
      _unitController.text = 'pcs';
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
              SizedBox(
                width: 90,
                child: TextField(
                  controller: _iconController,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    labelText: 'Icon',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 12),
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

class _MoveToInventoryResult {
  final String category;
  final DateTime expiredAt;
  final String icon;
  _MoveToInventoryResult({
    required this.category,
    required this.expiredAt,
    required this.icon,
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
  final _iconController = TextEditingController(text: '📦');

  @override
  void dispose() {
    _iconController.dispose();
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
          const SizedBox(height: 20),
          Row(
            children: [
              SizedBox(
                width: 90,
                child: TextField(
                  controller: _iconController,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    labelText: 'Icon',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: _category,
                  decoration: const InputDecoration(
                    labelText: 'Simpan di',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'kulkas', child: Text('Kulkas')),
                    DropdownMenuItem(value: 'freezer', child: Text('Freezer')),
                    DropdownMenuItem(
                        value: 'rak_dapur', child: Text('Rak Dapur')),
                  ],
                  onChanged: (v) => setState(() => _category = v ?? 'kulkas'),
                ),
              ),
            ],
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
              onPressed: () => Navigator.pop(
                context,
                _MoveToInventoryResult(
                  category: _category,
                  expiredAt: _expiredAt,
                  icon: _iconController.text.trim().isEmpty
                      ? '📦'
                      : _iconController.text.trim(),
                ),
              ),
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
