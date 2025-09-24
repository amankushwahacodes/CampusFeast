import 'package:flutter/material.dart';
import 'package:campus_feast/models/order.dart';
import 'package:campus_feast/models/vendor.dart';

class VendorOrder {
  final String id;
  final String customerName;
  final Map<String, int> items;
  final double total;
  final DateTime timestamp;
  final OrderStatus status;
  final String paymentMethod;

  VendorOrder({
    required this.id,
    required this.customerName,
    required this.items,
    required this.total,
    required this.timestamp,
    required this.status,
    required this.paymentMethod,
  });

  VendorOrder copyWith({
    String? id,
    String? customerName,
    Map<String, int>? items,
    double? total,
    DateTime? timestamp,
    OrderStatus? status,
    String? paymentMethod,
  }) {
    return VendorOrder(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      items: items ?? this.items,
      total: total ?? this.total,
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
    );
  }
}

class OrderManagementScreen extends StatefulWidget {
  const OrderManagementScreen({super.key});

  @override
  State<OrderManagementScreen> createState() => _OrderManagementScreenState();
}

class _OrderManagementScreenState extends State<OrderManagementScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  
  // Sample orders data
  final List<VendorOrder> _newOrders = [
    VendorOrder(
      id: '#1024',
      customerName: 'Rahul Sharma',
      items: {'Veg Biryani': 2, 'Coke': 1},
      total: 180.0,
      timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
      status: OrderStatus.placed,
      paymentMethod: 'Wallet',
    ),
    VendorOrder(
      id: '#1023',
      customerName: 'Priya Patel',
      items: {'Masala Tea': 2, 'Samosa': 4},
      total: 60.0,
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      status: OrderStatus.placed,
      paymentMethod: 'Wallet',
    ),
  ];

  final List<VendorOrder> _preparingOrders = [
    VendorOrder(
      id: '#1022',
      customerName: 'Amit Kumar',
      items: {'Chicken Curry': 1, 'Rice': 2, 'Naan': 2},
      total: 250.0,
      timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
      status: OrderStatus.preparing,
      paymentMethod: 'Wallet',
    ),
    VendorOrder(
      id: '#1021',
      customerName: 'Sneha Singh',
      items: {'Dosa': 3, 'Chutney': 3, 'Coffee': 2},
      total: 120.0,
      timestamp: DateTime.now().subtract(const Duration(minutes: 20)),
      status: OrderStatus.preparing,
      paymentMethod: 'Wallet',
    ),
  ];

  final List<VendorOrder> _readyOrders = [
    VendorOrder(
      id: '#1020',
      customerName: 'Vikash Yadav',
      items: {'Burger': 2, 'Fries': 1, 'Pepsi': 2},
      total: 200.0,
      timestamp: DateTime.now().subtract(const Duration(minutes: 25)),
      status: OrderStatus.ready,
      paymentMethod: 'Wallet',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kitchen Display'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Refresh orders
              setState(() {});
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              _showSettingsDialog();
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              icon: Stack(
                children: [
                  const Icon(Icons.new_releases),
                  if (_newOrders.isNotEmpty)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '${_newOrders.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              text: 'New Orders',
            ),
            Tab(
              icon: Stack(
                children: [
                  const Icon(Icons.kitchen),
                  if (_preparingOrders.isNotEmpty)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '${_preparingOrders.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              text: 'Preparing',
            ),
            Tab(
              icon: Stack(
                children: [
                  const Icon(Icons.check_circle),
                  if (_readyOrders.isNotEmpty)
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '${_readyOrders.length}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
              text: 'Ready',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOrdersList(_newOrders, OrderStatus.placed),
          _buildOrdersList(_preparingOrders, OrderStatus.preparing),
          _buildOrdersList(_readyOrders, OrderStatus.ready),
        ],
      ),
    );
  }

  Widget _buildOrdersList(List<VendorOrder> orders, OrderStatus status) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getStatusIcon(status),
              size: 64,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            Text(
              _getEmptyMessage(status),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        return _buildOrderCard(orders[index]);
      },
    );
  }

  Widget _buildOrderCard(VendorOrder order) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.id,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      order.customerName,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getStatusColor(order.status).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        _getStatusText(order.status),
                        style: TextStyle(
                          color: _getStatusColor(order.status),
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getTimeAgo(order.timestamp),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Order Items
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Items:',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...order.items.entries.map((entry) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${entry.key}'),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'x${entry.value}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Total and Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total: ₹${order.total.toStringAsFixed(0)}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                Row(
                  children: _buildActionButtons(order),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildActionButtons(VendorOrder order) {
    switch (order.status) {
      case OrderStatus.placed:
        return [
          OutlinedButton(
            onPressed: () => _rejectOrder(order),
            child: const Text('Reject'),
          ),
          const SizedBox(width: 8),
          FilledButton(
            onPressed: () => _acceptOrder(order),
            child: const Text('Accept'),
          ),
        ];
      case OrderStatus.preparing:
        return [
          FilledButton(
            onPressed: () => _markReady(order),
            child: const Text('Mark Ready'),
          ),
        ];
      case OrderStatus.ready:
        return [
          FilledButton(
            onPressed: () => _markCompleted(order),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            child: const Text('Complete'),
          ),
        ];
      default:
        return [];
    }
  }

  void _acceptOrder(VendorOrder order) {
    setState(() {
      _newOrders.remove(order);
      _preparingOrders.add(order.copyWith(status: OrderStatus.preparing));
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Order ${order.id} accepted and moved to preparation')),
    );
  }

  void _rejectOrder(VendorOrder order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Reject Order ${order.id}'),
        content: const Text('Are you sure you want to reject this order? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              setState(() {
                _newOrders.remove(order);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Order ${order.id} rejected')),
              );
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Reject'),
          ),
        ],
      ),
    );
  }

  void _markReady(VendorOrder order) {
    setState(() {
      _preparingOrders.remove(order);
      _readyOrders.add(order.copyWith(status: OrderStatus.ready));
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Order ${order.id} marked as ready for pickup')),
    );
  }

  void _markCompleted(VendorOrder order) {
    setState(() {
      _readyOrders.remove(order);
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Order ${order.id} completed successfully')),
    );
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Kitchen Settings'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              title: const Text('Sound Notifications'),
              subtitle: const Text('Play sound for new orders'),
              value: true,
              onChanged: (value) {},
            ),
            SwitchListTile(
              title: const Text('Auto-refresh'),
              subtitle: const Text('Refresh orders every 30 seconds'),
              value: true,
              onChanged: (value) {},
            ),
            ListTile(
              title: const Text('Preparation Time'),
              subtitle: const Text('Average time per order: 15 minutes'),
              trailing: const Icon(Icons.timer),
              onTap: () {
                // Show time picker
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  IconData _getStatusIcon(OrderStatus status) {
    switch (status) {
      case OrderStatus.placed:
        return Icons.new_releases;
      case OrderStatus.preparing:
        return Icons.kitchen;
      case OrderStatus.ready:
        return Icons.check_circle;
      default:
        return Icons.help;
    }
  }

  String _getEmptyMessage(OrderStatus status) {
    switch (status) {
      case OrderStatus.placed:
        return 'No new orders\nYou\'ll see new orders here when customers place them.';
      case OrderStatus.preparing:
        return 'No orders in preparation\nAccept orders from the "New Orders" tab to start preparing.';
      case OrderStatus.ready:
        return 'No orders ready for pickup\nOrders marked as ready will appear here.';
      default:
        return 'No orders found';
    }
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.placed:
        return Colors.blue;
      case OrderStatus.preparing:
        return Colors.orange;
      case OrderStatus.ready:
        return Colors.green;
      case OrderStatus.completed:
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.placed:
        return 'NEW';
      case OrderStatus.preparing:
        return 'PREPARING';
      case OrderStatus.ready:
        return 'READY';
      case OrderStatus.completed:
        return 'COMPLETED';
      default:
        return 'UNKNOWN';
    }
  }

  String _getTimeAgo(DateTime timestamp) {
    final difference = DateTime.now().difference(timestamp);
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}