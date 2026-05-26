import 'package:flutter/material.dart';
import '../../../data/dummy/shopping_data.dart';
import 'widgets/shopping_plan_card.dart';
import 'widgets/shopping_list_item.dart';

class AddTab extends StatelessWidget {
  const AddTab({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFFAFAFA),
        body: Column(
          children: [
            _buildHeader(context),
            const Material(
              color: Colors.white,
              child: TabBar(
                labelColor: Color(0xFF059669),
                unselectedLabelColor: Color(0xFF9CA3AF),
                indicatorColor: Color(0xFF059669),
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
                  const Center(
                    child: Text(
                      'Input Langsung - Coming Soon',
                      style: TextStyle(color: Color(0xFF6B7280)),
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

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 32,
        left: 24,
        right: 24,
        bottom: 32,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF059669),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tambah Belanjaan',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Catat apa yang perlu di beli hari ini',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFFD1FAE5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShoppingListTab() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      children: [
        const ShoppingPlanCard(),
        const SizedBox(height: 32),
        const Text(
          'BELUM DIBELI (1)',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Color(0xFF9CA3AF),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 16),
        ShoppingListItem(
          item: dummyShoppingList.first,
          onToggle: () {},
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
