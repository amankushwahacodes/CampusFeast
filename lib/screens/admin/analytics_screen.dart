import 'package:flutter/material.dart';

class AdminAnalyticsScreen extends StatefulWidget {
  const AdminAnalyticsScreen({super.key});

  @override
  State createState() => _AdminAnalyticsScreenState();
}

class _AdminAnalyticsScreenState extends State<AdminAnalyticsScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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
        automaticallyImplyLeading: false,
        title: const Text('Analytics Dashboard'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(onPressed: _showTimeRangeSelector, icon: const Icon(Icons.date_range)),
          IconButton(onPressed: _showExportOptions, icon: const Icon(Icons.download)),
          const SizedBox(width: 16),
        ],
        bottom: TabBar(
          isScrollable: true,
          controller: _tabController,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Sales Analytics'),
            Tab(text: 'User Behavior'),
            Tab(text: 'Peak Hours'),
          ],
        ),
      ),
      body: SafeArea(
        child: TabBarView(
          controller: _tabController,
          children: const [
            AnalyticsOverviewTab(),
            SalesAnalyticsTab(),
            UserBehaviorTab(),
            PeakHoursTab(),
          ],
        ),
      ),
    );
  }

  void _showTimeRangeSelector() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Time Range'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            ListTile(title: Text('Today'), leading: Icon(Icons.today)),
            ListTile(title: Text('This Week'), leading: Icon(Icons.date_range)),
            ListTile(title: Text('This Month'), leading: Icon(Icons.calendar_today)),
            ListTile(title: Text('Last 3 Months'), leading: Icon(Icons.calendar_view_month)),
            ListTile(title: Text('Custom Range'), leading: Icon(Icons.edit_calendar)),
          ],
        ),
      ),
    );
  }

  void _showExportOptions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Analytics'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            ListTile(title: Text('Export as PDF Report'), leading: Icon(Icons.picture_as_pdf)),
            ListTile(title: Text('Export Data as Excel'), leading: Icon(Icons.table_chart)),
            ListTile(title: Text('Generate Dashboard URL'), leading: Icon(Icons.link)),
          ],
        ),
      ),
    );
  }
}

class AnalyticsOverviewTab extends StatelessWidget {
  const AnalyticsOverviewTab({super.key});

  int _cols(double w) {
    if (w < 600) return 1;
    if (w < 900) return 2;
    if (w < 1200) return 3;
    return 4;
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    Widget twoPane(Widget left, Widget right) {
      final narrow = w < 900;
      if (narrow) {
        return Column(children: [left, const SizedBox(height: 16), right]);
      }
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 2, child: left),
          const SizedBox(width: 16),
          Expanded(child: right),
        ],
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Key metrics grid
          GridView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: _cols(w),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.2,
            ),
            children: [
              _buildMetricCard(context, 'Total Revenue', '₹12,45,680', '↗ 15.3%', Icons.currency_rupee, Colors.green),
              _buildMetricCard(context, 'Total Orders', '8,456', '↗ 12.8%', Icons.receipt_long, Colors.blue),
              _buildMetricCard(context, 'Active Users', '2,847', '↗ 8.2%', Icons.people, Colors.orange),
              _buildMetricCard(context, 'Avg Order Value', '₹147.20', '↗ 5.6%', Icons.trending_up, Colors.purple),
            ],
          ),
          const SizedBox(height: 32),
          twoPane(
            // Left: revenue chart
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Revenue Trend (Last 30 Days)', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  SizedBox(height: 200, child: _buildRevenueChart(context)),
                ]),
              ),
            ),
            // Right: top vendors
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Top Vendors', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  ...List.generate(5, (i) => _buildVendorRankItem(context, i)),
                ]),
              ),
            ),
          ),
          const SizedBox(height: 32),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('System Health', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                LayoutBuilder(builder: (context, c) {
                  final itemWidth = c.maxWidth < 600 ? c.maxWidth : (c.maxWidth - 16 * 3) / 4;
                  return Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      SizedBox(width: itemWidth, child: _buildHealthMetric(context, 'App Performance', 98.5, Colors.green)),
                      SizedBox(width: itemWidth, child: _buildHealthMetric(context, 'Payment Success Rate', 99.2, Colors.green)),
                      SizedBox(width: itemWidth, child: _buildHealthMetric(context, 'Order Fulfillment', 95.8, Colors.green)),
                      SizedBox(width: itemWidth, child: _buildHealthMetric(context, 'User Satisfaction', 4.6, Colors.blue)),
                    ],
                  );
                }),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(BuildContext context, String title, String value, String change, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const Spacer(),
              Text(change, style: const TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 12),
          Text(value, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(title, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
        ]),
      ),
    );
  }

  Widget _buildRevenueChart(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.trending_up, size: 48, color: Colors.green),
            SizedBox(height: 8),
            Text('Revenue Chart'),
            Text('(Chart implementation needed)'),
          ],
        ),
      ),
    );
  }

  Widget _buildVendorRankItem(BuildContext context, int index) {
    final vendors = ['Cafe Central', 'Quick Bites', 'Healthy Meals', 'Spice Corner', 'Sweet Treats'];
    final revenues = ['₹45,680', '₹38,920', '₹32,150', '₹28,440', '₹25,890'];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(color: index < 3 ? Colors.amber : Colors.grey, shape: BoxShape.circle),
            child: Center(
              child: Text(
                '${index + 1}',
                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              vendors[index],
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
          Text(
            revenues[index],
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthMetric(BuildContext context, String title, double value, Color color) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(color: color.withValues(alpha: 0.2), shape: BoxShape.circle),
          child: Center(
            child: Text(
              title == 'User Satisfaction' ? '$value★' : '${value.toInt()}%',
              style: TextStyle(color: color, fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(title, style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center),
      ],
    );
  }
}

class SalesAnalyticsTab extends StatelessWidget {
  const SalesAnalyticsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final cardWidth = w < 600 ? w - 48 : w < 900 ? (w - 24 - 16) / 2 : (w - 24 - 32) / 3;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Sales Performance Analytics', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              SizedBox(width: cardWidth, child: _buildSalesCard(context, 'Daily Sales', '₹12,456', '+15.3%', Icons.today)),
              SizedBox(width: cardWidth, child: _buildSalesCard(context, 'Weekly Sales', '₹89,240', '+8.7%', Icons.date_range)),
              SizedBox(width: cardWidth, child: _buildSalesCard(context, 'Monthly Sales', '₹3,45,680', '+12.4%', Icons.calendar_month)),
            ],
          ),
          const SizedBox(height: 32),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Sales by Category', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                ...['Beverages', 'Snacks', 'Main Course', 'Desserts', 'Fast Food'].map((category) {
                  final values = {'Beverages': 45, 'Snacks': 32, 'Main Course': 28, 'Desserts': 15, 'Fast Food': 22};
                  return _buildCategoryItem(context, category, values[category]!);
                }),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSalesCard(BuildContext context, String title, String amount, String change, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 12),
          Text(amount, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(title, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 8),
          Text(change, style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w600)),
        ]),
      ),
    );
  }

  Widget _buildCategoryItem(BuildContext context, String category, int percentage) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(width: 100, child: Text(category)),
          Expanded(
            child: LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: Colors.grey.withValues(alpha: 0.3),
            ),
          ),
          const SizedBox(width: 12),
          Text('$percentage%'),
        ],
      ),
    );
  }
}

class UserBehaviorTab extends StatelessWidget {
  const UserBehaviorTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.people, size: 64, color: Theme.of(context).colorScheme.onSurfaceVariant),
        const SizedBox(height: 16),
        Text('User Behavior Analytics', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        Text(
          'User engagement patterns, preferences, and activity insights',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
      ]),
    );
  }
}

class PeakHoursTab extends StatelessWidget {
  const PeakHoursTab({super.key});

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final cardWidth = w < 600 ? w - 48 : w < 900 ? (w - 24 - 16) / 2 : (w - 24 - 32) / 3;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Peak Hours Analysis', style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              SizedBox(width: cardWidth, child: _buildPeakCard(context, 'Morning Peak', '8:00 - 10:00 AM', '245 orders', Colors.orange)),
              SizedBox(width: cardWidth, child: _buildPeakCard(context, 'Lunch Peak', '12:00 - 2:00 PM', '458 orders', Colors.green)),
              SizedBox(width: cardWidth, child: _buildPeakCard(context, 'Evening Peak', '5:00 - 7:00 PM', '312 orders', Colors.blue)),
            ],
          ),
          const SizedBox(height: 32),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Hourly Order Distribution', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                SizedBox(height: 200, child: _buildHourlyChart(context)),
              ]),
            ),
          ),
          const SizedBox(height: 32),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Weekly Peak Analysis', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                ...['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'].map((day) {
                  final values = {'Monday': 85, 'Tuesday': 92, 'Wednesday': 88, 'Thursday': 95, 'Friday': 100, 'Saturday': 45, 'Sunday': 32};
                  return _buildDayItem(context, day, values[day]!);
                }),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeakCard(BuildContext context, String title, String time, String orders, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 8),
          Text(time, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
          const SizedBox(height: 12),
          Text(orders, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
        ]),
      ),
    );
  }

  Widget _buildHourlyChart(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bar_chart, size: 48, color: Colors.blue),
            SizedBox(height: 8),
            Text('Hourly Distribution Chart'),
            Text('(Chart implementation needed)'),
          ],
        ),
      ),
    );
  }

  Widget _buildDayItem(BuildContext context, String day, int percentage) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(width: 80, child: Text(day)),
          Expanded(
            child: LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: Colors.grey.withValues(alpha: 0.3),
              color: percentage > 90 ? Colors.green : percentage > 70 ? Colors.orange : Colors.blue,
            ),
          ),
          const SizedBox(width: 12),
          Text('$percentage%'),
        ],
      ),
    );
  }
}
