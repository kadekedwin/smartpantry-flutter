import 'package:flutter/material.dart';
import '../../../data/dummy/shopping_data.dart';
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
            Expanded(
              child: TabBarView(
                children: [
                  _buildShoppingListTab(),
                  _buildDirectInputTab(),
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

  Widget _buildShoppingListTab() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
      children: [
        const ShoppingPlanCard(),
        const SizedBox(height: 24),
        const Text(
          'BELUM DIBELI (1)',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Color(0xFF9CA3AF),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        ShoppingListItem(
          item: dummyShoppingList.first,
          onToggle: () {},
        ),
      ],
    );
  }

  Widget _buildDirectInputTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDF4),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.edit_note_rounded,
              color: _green,
              size: 36,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Input Langsung',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Segera hadir',
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }
}
