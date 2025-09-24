import 'package:flutter/material.dart';
import 'package:campus_feast/models/admin_models.dart';

class AdminAnalyticsScreen extends StatefulWidget {
  const AdminAnalyticsScreen({super.key});

  @override
  State<AdminAnalyticsScreen> createState() => _AdminAnalyticsScreenState();
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
          IconButton(
            onPressed: () => _showTimeRangeSelector(),
            icon: const Icon(Icons.date_range),
          ),
          IconButton(
            onPressed: () => _showExportOptions(),
            icon: const Icon(Icons.download),
          ),
          const SizedBox(width: 16),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Sales Analytics'),
            Tab(text: 'User Behavior'),
            Tab(text: 'Peak Hours'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          AnalyticsOverviewTab(),
          SalesAnalyticsTab(),
          UserBehaviorTab(),
          PeakHoursTab(),
        ],
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
          children: [
            ListTile(
              title: const Text('Today'),
              leading: const Icon(Icons.today),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: const Text('This Week'),
              leading: const Icon(Icons.date_range),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: const Text('This Month'),
              leading: const Icon(Icons.calendar_today),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: const Text('Last 3 Months'),
              leading: const Icon(Icons.calendar_view_month),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: const Text('Custom Range'),
              leading: const Icon(Icons.edit_calendar),
              onTap: () => Navigator.pop(context),
            ),
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
          children: [
            ListTile(
              title: const Text('Export as PDF Report'),
              leading: const Icon(Icons.picture_as_pdf),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: const Text('Export Data as Excel'),
              leading: const Icon(Icons.table_chart),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: const Text('Generate Dashboard URL'),
              leading: const Icon(Icons.link),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}

class AnalyticsOverviewTab extends StatelessWidget {
  const AnalyticsOverviewTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Key Metrics
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.2,
            children: [
              _buildMetricCard(
                context,
                'Total Revenue',
                '₹12,45,680',
                '↗ 15.3%',
                Icons.currency_rupee,
                Colors.green,
              ),
              _buildMetricCard(
                context,
                'Total Orders',
                '8,456',
                '↗ 12.8%',
                Icons.receipt_long,
                Colors.blue,
              ),
              _buildMetricCard(
                context,
                'Active Users',
                '2,847',
                '↗ 8.2%',
                Icons.people,
                Colors.orange,
              ),
              _buildMetricCard(
                context,
                'Avg Order Value',
                '₹147.20',
                '↗ 5.6%',
                Icons.trending_up,
                Colors.purple,
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Revenue Chart
              Expanded(
                flex: 2,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Revenue Trend (Last 30 Days)',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 200,
                          child: _buildRevenueChart(context),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              
              const SizedBox(width: 16),
              
              // Top Performing Vendors
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Top Vendors',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ...List.generate(5, (index) => _buildVendorRankItem(context, index)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // System Health
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'System Health',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: _buildHealthMetric(context, 'App Performance', 98.5, Colors.green),
                      ),
                      Expanded(
                        child: _buildHealthMetric(context, 'Payment Success Rate', 99.2, Colors.green),
                      ),
                      Expanded(
                        child: _buildHealthMetric(context, 'Order Fulfillment', 95.8, Colors.green),
                      ),
                      Expanded(
                        child: _buildHealthMetric(context, 'User Satisfaction', 4.6, Colors.blue),
                      ),
                    ],
                  ),
                ],
              ),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const Spacer(),
                Text(
                  change,
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRevenueChart(BuildContext context) {
    // Placeholder for revenue chart - in real app, use a charting library
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
            decoration: BoxDecoration(
              color: index < 3 ? Colors.amber : Colors.grey,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              vendors[index],
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            revenues[index],
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.primary,
            ),
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
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              title == 'User Satisfaction' ? '$value★' : '${value.toInt()}%',
              style: TextStyle(
                color: color,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class SalesAnalyticsTab extends StatelessWidget {
  const SalesAnalyticsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sales Performance Analytics',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          
          // Sales Summary Cards
          Row(
            children: [
              Expanded(
                child: _buildSalesCard(context, 'Daily Sales', '₹12,456', '+15.3%', Icons.today),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSalesCard(context, 'Weekly Sales', '₹89,240', '+8.7%', Icons.date_range),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSalesCard(context, 'Monthly Sales', '₹3,45,680', '+12.4%', Icons.calendar_month),
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // Category Performance
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sales by Category',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ...['Beverages', 'Snacks', 'Main Course', 'Desserts', 'Fast Food'].map((category) {
                    final index = ['Beverages', 'Snacks', 'Main Course', 'Desserts', 'Fast Food'].indexOf(category);
                    final values = [45, 32, 28, 15, 22];
                    return _buildCategoryItem(context, category, values[index]);
                  }),
                ],
              ),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 12),
            Text(
              amount,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(title, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 8),
            Text(
              change,
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem(BuildContext context, String category, int percentage) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(category),
          ),
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people,
            size: 64,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            'User Behavior Analytics',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'User engagement patterns, preferences, and activity insights',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class PeakHoursTab extends StatelessWidget {
  const PeakHoursTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Peak Hours Analysis',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          
          // Peak Hours Summary
          Row(
            children: [
              Expanded(
                child: _buildPeakCard(context, 'Morning Peak', '8:00 - 10:00 AM', '245 orders', Colors.orange),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildPeakCard(context, 'Lunch Peak', '12:00 - 2:00 PM', '458 orders', Colors.green),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildPeakCard(context, 'Evening Peak', '5:00 - 7:00 PM', '312 orders', Colors.blue),
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // Hourly Distribution
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hourly Order Distribution',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 200,
                    child: _buildHourlyChart(context),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Day-wise Peak Analysis
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Weekly Peak Analysis',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ...['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'].map((day) {
                    final index = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'].indexOf(day);
                    final values = [85, 92, 88, 95, 100, 45, 32];
                    return _buildDayItem(context, day, values[index]);
                  }),
                ],
              ),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              time,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              orders,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
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
          SizedBox(
            width: 80,
            child: Text(day),
          ),
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