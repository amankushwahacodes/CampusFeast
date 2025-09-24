import 'package:flutter/material.dart';
import 'package:campus_feast/models/order.dart';
import 'package:campus_feast/models/vendor.dart';
import 'package:campus_feast/widgets/order_card.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Order> get activeOrders {
    return sampleOrders.where((order) =>
        order.status == OrderStatus.placed ||
        order.status == OrderStatus.accepted ||
        order.status == OrderStatus.preparing ||
        order.status == OrderStatus.ready).toList();
  }

  List<Order> get pastOrders {
    return sampleOrders.where((order) =>
        order.status == OrderStatus.completed ||
        order.status == OrderStatus.cancelled ||
        order.status == OrderStatus.rejected).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Active'),
            Tab(text: 'Past Orders'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Active Orders
          activeOrders.isEmpty
              ? _buildEmptyState(
                  icon: Icons.receipt_long,
                  title: 'No Active Orders',
                  subtitle: 'Your active orders will appear here',
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: activeOrders.length,
                  itemBuilder: (context, index) {
                    final order = activeOrders[index];
                    final vendor = sampleVendors.firstWhere(
                      (v) => v.id == order.vendorId,
                    );
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: OrderCard(
                        order: order,
                        vendor: vendor,
                        isActive: true,
                      ),
                    );
                  },
                ),

          // Past Orders
          pastOrders.isEmpty
              ? _buildEmptyState(
                  icon: Icons.history,
                  title: 'No Past Orders',
                  subtitle: 'Your order history will appear here',
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: pastOrders.length,
                  itemBuilder: (context, index) {
                    final order = pastOrders[index];
                    final vendor = sampleVendors.firstWhere(
                      (v) => v.id == order.vendorId,
                    );
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: OrderCard(
                        order: order,
                        vendor: vendor,
                        isActive: false,
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}