import 'package:flutter/material.dart';
import '../components/tab_header.dart';
import '../components/tabs/direct_input_view.dart';
import '../components/tabs/shopping_list_view.dart';

class AddTab extends StatelessWidget {
  const AddTab({super.key});

  static const _green = Color(0xFF0F9F68);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFF9FAFB),
        body: Column(
          children: [
            const TabHeader(
              title: 'Tambah Belanjaan',
              subtitle: 'Catat apa yang perlu dibeli',
            ),
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
                children: [ShoppingListView(), DirectInputView()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
