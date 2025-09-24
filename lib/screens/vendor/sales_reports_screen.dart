import 'package:flutter/material.dart';

class SalesReportsScreen extends StatefulWidget {
  const SalesReportsScreen({super.key});

  @override
  State<SalesReportsScreen> createState() => _SalesReportsScreenState();
}

class _SalesReportsScreenState extends State<SalesReportsScreen> {
  String selectedPeriod = 'Today';
  final List<String> periods = ['Today', 'Yesterday', 'This Week', 'This Month'];

  // Sample data
  final Map<String, SalesData> salesData = {
    'Today': SalesData(
      totalRevenue: 1250.0,
      totalOrders: 24,
      averageOrderValue: 52.08,
      totalItems: 47,
      topSellingItems: [
        TopSellingItem('Veg Biryani', 8, 720.0),
        TopSellingItem('Masala Tea', 15, 150.0),
        TopSellingItem('Chicken Curry', 5, 600.0),
        TopSellingItem('Samosa', 12, 180.0),
      ],
      hourlyData: [
        HourlyData(9, 2, 80.0),
        HourlyData(10, 3, 120.0),
        HourlyData(11, 5, 250.0),
        HourlyData(12, 8, 420.0),
        HourlyData(13, 4, 200.0),
        HourlyData(14, 2, 180.0),
      ],
      discountUsage: [
        DiscountUsage('Happy Hour Special', 12, 240.0),
        DiscountUsage('Student Special', 8, 120.0),
        DiscountUsage('Combo Deal', 3, 75.0),
      ],
    ),
    'Yesterday': SalesData(
      totalRevenue: 1580.0,
      totalOrders: 31,
      averageOrderValue: 50.97,
      totalItems: 62,
      topSellingItems: [
        TopSellingItem('Chicken Curry', 12, 1440.0),
        TopSellingItem('Veg Biryani', 10, 900.0),
        TopSellingItem('Masala Tea', 18, 180.0),
        TopSellingItem('Dosa', 8, 240.0),
      ],
      hourlyData: [],
      discountUsage: [],
    ),
  };

  @override
  Widget build(BuildContext context) {
    final currentData = salesData[selectedPeriod] ?? salesData['Today']!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales Analytics'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (period) {
              setState(() {
                selectedPeriod = period;
              });
            },
            itemBuilder: (context) => periods.map((period) {
              return PopupMenuItem(
                value: period,
                child: Text(period),
              );
            }).toList(),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    selectedPeriod,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Overview Cards
            _buildOverviewCards(currentData),
            
            const SizedBox(height: 24),
            
            // Top Selling Items
            _buildTopSellingItems(currentData.topSellingItems),
            
            const SizedBox(height: 24),
            
            // Hourly Sales Chart (only for Today)
            if (selectedPeriod == 'Today' && currentData.hourlyData.isNotEmpty)
              _buildHourlySalesChart(currentData.hourlyData),
            
            const SizedBox(height: 24),
            
            // Discount Usage
            if (currentData.discountUsage.isNotEmpty)
              _buildDiscountUsage(currentData.discountUsage),
            
            const SizedBox(height: 24),
            
            // Inventory Insights
            _buildInventoryInsights(),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewCards(SalesData data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Overview - $selectedPeriod',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1.5,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: [
            _buildStatCard(
              'Total Revenue',
              '₹${data.totalRevenue.toStringAsFixed(0)}',
              Icons.currency_rupee,
              Colors.green,
              '+12%',
            ),
            _buildStatCard(
              'Total Orders',
              '${data.totalOrders}',
              Icons.shopping_bag,
              Colors.blue,
              '+8%',
            ),
            _buildStatCard(
              'Avg Order Value',
              '₹${data.averageOrderValue.toStringAsFixed(0)}',
              Icons.analytics,
              Colors.orange,
              '+5%',
            ),
            _buildStatCard(
              'Items Sold',
              '${data.totalItems}',
              Icons.restaurant,
              Colors.purple,
              '+15%',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color, String change) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: color),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    change,
                    style: const TextStyle(
                      color: Colors.green,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopSellingItems(List<TopSellingItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Top Selling Items',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Column(
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return Column(
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _getRankColor(index + 1),
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(item.name),
                    subtitle: Text('${item.quantity} sold'),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '₹${item.revenue.toStringAsFixed(0)}',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        Text(
                          'Revenue',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (index < items.length - 1) const Divider(height: 1),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildHourlySalesChart(List<HourlyData> hourlyData) {
    final maxRevenue = hourlyData.map((d) => d.revenue).reduce((a, b) => a > b ? a : b);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hourly Sales Today',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                SizedBox(
                  height: 200,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: hourlyData.map((data) {
                      final height = (data.revenue / maxRevenue) * 150;
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            '₹${data.revenue.toStringAsFixed(0)}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          const SizedBox(height: 4),
                          Container(
                            width: 30,
                            height: height,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${data.hour}:00',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: hourlyData.map((data) {
                    return Column(
                      children: [
                        Text(
                          '${data.orders}',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Orders',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDiscountUsage(List<DiscountUsage> discounts) {
    final totalDiscountRevenue = discounts.fold(0.0, (sum, discount) => sum + discount.totalSaved);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Discount Usage',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Discounts Given',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      '₹${totalDiscountRevenue.toStringAsFixed(0)}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ...discounts.map((discount) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text(discount.name),
                        ),
                        Expanded(
                          child: Text(
                            '${discount.usageCount} uses',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '₹${discount.totalSaved.toStringAsFixed(0)}',
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInventoryInsights() {
    final insights = [
      InventoryInsight('Veg Biryani', 'High demand', 'Consider increasing portions', Colors.green),
      InventoryInsight('Samosa', 'Stock running low', 'Restock recommended', Colors.orange),
      InventoryInsight('Cold Coffee', 'Low demand', 'Consider promotion', Colors.red),
      InventoryInsight('Masala Tea', 'Consistent sales', 'Maintain current stock', Colors.blue),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Inventory Insights',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Column(
            children: insights.map((insight) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: insight.color.withValues(alpha: 0.2),
                  child: Icon(
                    _getInsightIcon(insight.status),
                    color: insight.color,
                    size: 20,
                  ),
                ),
                title: Text(insight.itemName),
                subtitle: Text(insight.recommendation),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: insight.color.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    insight.status,
                    style: TextStyle(
                      color: insight.color,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return Colors.amber;
      case 2:
        return Colors.grey[400]!;
      case 3:
        return Colors.brown[400]!;
      default:
        return Colors.blue[400]!;
    }
  }

  IconData _getInsightIcon(String status) {
    switch (status.toLowerCase()) {
      case 'high demand':
        return Icons.trending_up;
      case 'stock running low':
        return Icons.warning;
      case 'low demand':
        return Icons.trending_down;
      case 'consistent sales':
        return Icons.check_circle;
      default:
        return Icons.info;
    }
  }
}

class SalesData {
  final double totalRevenue;
  final int totalOrders;
  final double averageOrderValue;
  final int totalItems;
  final List<TopSellingItem> topSellingItems;
  final List<HourlyData> hourlyData;
  final List<DiscountUsage> discountUsage;

  SalesData({
    required this.totalRevenue,
    required this.totalOrders,
    required this.averageOrderValue,
    required this.totalItems,
    required this.topSellingItems,
    required this.hourlyData,
    required this.discountUsage,
  });
}

class TopSellingItem {
  final String name;
  final int quantity;
  final double revenue;

  TopSellingItem(this.name, this.quantity, this.revenue);
}

class HourlyData {
  final int hour;
  final int orders;
  final double revenue;

  HourlyData(this.hour, this.orders, this.revenue);
}

class DiscountUsage {
  final String name;
  final int usageCount;
  final double totalSaved;

  DiscountUsage(this.name, this.usageCount, this.totalSaved);
}

class InventoryInsight {
  final String itemName;
  final String status;
  final String recommendation;
  final Color color;

  InventoryInsight(this.itemName, this.status, this.recommendation, this.color);
}