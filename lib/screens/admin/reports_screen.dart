import 'package:flutter/material.dart';
import 'package:campus_feast/models/admin_models.dart';

class AdminReportsScreen extends StatefulWidget {
  const AdminReportsScreen({super.key});

  @override
  State<AdminReportsScreen> createState() => _AdminReportsScreenState();
}

class _AdminReportsScreenState extends State<AdminReportsScreen> with TickerProviderStateMixin {
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
        title: const Text('Reports & Analytics'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () => _showDateRangeDialog(),
            icon: const Icon(Icons.date_range),
          ),
          IconButton(
            onPressed: () => _showExportDialog(),
            icon: const Icon(Icons.download),
          ),
          const SizedBox(width: 16),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Transactions'),
            Tab(text: 'Settlements'),
            Tab(text: 'Wallet Activity'),
            Tab(text: 'System Reports'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          TransactionReportsTab(),
          SettlementReportsTab(),
          WalletActivityTab(),
          SystemReportsTab(),
        ],
      ),
    );
  }

  void _showDateRangeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Date Range'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Today'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: const Text('Last 7 days'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: const Text('Last 30 days'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: const Text('Custom Range'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showExportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Data'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.table_chart),
              title: const Text('Export as Excel'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Export as Excel
              },
            ),
            ListTile(
              leading: const Icon(Icons.picture_as_pdf),
              title: const Text('Export as PDF'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Export as PDF
              },
            ),
            ListTile(
              leading: const Icon(Icons.code),
              title: const Text('Export as CSV'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Export as CSV
              },
            ),
          ],
        ),
      ),
    );
  }
}

class TransactionReportsTab extends StatelessWidget {
  const TransactionReportsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Summary Cards
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  context,
                  'Total Transactions',
                  '12,486',
                  'Today: 156',
                  Icons.receipt_long,
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSummaryCard(
                  context,
                  'Transaction Volume',
                  '₹5,67,890',
                  'Today: ₹12,456',
                  Icons.currency_rupee,
                  Colors.green,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSummaryCard(
                  context,
                  'Average Order Value',
                  '₹45.50',
                  '↑ 12% from last month',
                  Icons.trending_up,
                  Colors.orange,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSummaryCard(
                  context,
                  'Failed Transactions',
                  '23',
                  '0.18% failure rate',
                  Icons.error_outline,
                  Colors.red,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // Transactions Table
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Recent Transactions',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      FilterChip(
                        label: const Text('All'),
                        selected: true,
                        onSelected: (selected) {},
                      ),
                      const SizedBox(width: 8),
                      FilterChip(
                        label: const Text('Success'),
                        selected: false,
                        onSelected: (selected) {},
                      ),
                      const SizedBox(width: 8),
                      FilterChip(
                        label: const Text('Failed'),
                        selected: false,
                        onSelected: (selected) {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildTransactionsTable(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context, String title, String value, String subtitle, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionsTable(BuildContext context) {
    final transactions = _generateMockTransactions();
    
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Transaction ID')),
          DataColumn(label: Text('User')),
          DataColumn(label: Text('Vendor')),
          DataColumn(label: Text('Amount')),
          DataColumn(label: Text('Type')),
          DataColumn(label: Text('Status')),
          DataColumn(label: Text('Date')),
        ],
        rows: transactions.map((transaction) {
          return DataRow(
            cells: [
              DataCell(Text(transaction['id']!)),
              DataCell(Text(transaction['user']!)),
              DataCell(Text(transaction['vendor']!)),
              DataCell(Text(transaction['amount']!)),
              DataCell(Text(transaction['type']!)),
              DataCell(_buildStatusChip(context, transaction['status']!)),
              DataCell(Text(transaction['date']!)),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context, String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'success':
        color = Colors.green;
        break;
      case 'failed':
        color = Colors.red;
        break;
      case 'pending':
        color = Colors.orange;
        break;
      default:
        color = Colors.grey;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  List<Map<String, String>> _generateMockTransactions() {
    return [
      {
        'id': 'TXN001234',
        'user': 'John Doe',
        'vendor': 'Cafe Central',
        'amount': '₹125.50',
        'type': 'Order Payment',
        'status': 'Success',
        'date': '12/12/2024 14:30',
      },
      {
        'id': 'TXN001235',
        'user': 'Alice Smith',
        'vendor': 'Quick Bites',
        'amount': '₹89.00',
        'type': 'Order Payment',
        'status': 'Success',
        'date': '12/12/2024 14:28',
      },
      {
        'id': 'TXN001236',
        'user': 'Bob Johnson',
        'vendor': 'Healthy Meals',
        'amount': '₹156.75',
        'type': 'Order Payment',
        'status': 'Failed',
        'date': '12/12/2024 14:25',
      },
    ];
  }
}

class SettlementReportsTab extends StatelessWidget {
  const SettlementReportsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Settlement Summary
          Row(
            children: [
              Expanded(
                child: _buildSettlementCard(
                  context,
                  'Pending Settlements',
                  '₹45,680',
                  '12 vendors',
                  Icons.pending_actions,
                  Colors.orange,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSettlementCard(
                  context,
                  'Processed Today',
                  '₹1,23,456',
                  '25 settlements',
                  Icons.check_circle,
                  Colors.green,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSettlementCard(
                  context,
                  'This Month',
                  '₹12,45,890',
                  '456 settlements',
                  Icons.calendar_today,
                  Colors.blue,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // Settlements Table
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Settlement Reports',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      FilledButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.add, size: 16),
                        label: const Text('Process Settlement'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildSettlementsTable(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettlementCard(BuildContext context, String title, String amount, String subtitle, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              amount,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettlementsTable(BuildContext context) {
    final settlements = _generateMockSettlements();
    
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Settlement ID')),
          DataColumn(label: Text('Vendor')),
          DataColumn(label: Text('Period')),
          DataColumn(label: Text('Total Sales')),
          DataColumn(label: Text('Commission')),
          DataColumn(label: Text('Settlement Amount')),
          DataColumn(label: Text('Status')),
          DataColumn(label: Text('Actions')),
        ],
        rows: settlements.map((settlement) {
          return DataRow(
            cells: [
              DataCell(Text(settlement['id']!)),
              DataCell(Text(settlement['vendor']!)),
              DataCell(Text(settlement['period']!)),
              DataCell(Text(settlement['sales']!)),
              DataCell(Text(settlement['commission']!)),
              DataCell(Text(settlement['amount']!)),
              DataCell(_buildStatusChip(context, settlement['status']!)),
              DataCell(
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.visibility, size: 16),
                      tooltip: 'View Details',
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.download, size: 16),
                      tooltip: 'Download Report',
                    ),
                  ],
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context, String status) {
    Color color;
    switch (status.toLowerCase()) {
      case 'processed':
        color = Colors.green;
        break;
      case 'pending':
        color = Colors.orange;
        break;
      case 'failed':
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  List<Map<String, String>> _generateMockSettlements() {
    return [
      {
        'id': 'SET001',
        'vendor': 'Cafe Central',
        'period': '1-7 Dec',
        'sales': '₹15,450',
        'commission': '₹773',
        'amount': '₹14,677',
        'status': 'Pending',
      },
      {
        'id': 'SET002',
        'vendor': 'Quick Bites',
        'period': '1-7 Dec',
        'sales': '₹12,890',
        'commission': '₹645',
        'amount': '₹12,245',
        'status': 'Processed',
      },
    ];
  }
}

class WalletActivityTab extends StatelessWidget {
  const WalletActivityTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.account_balance_wallet,
            size: 64,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            'Wallet Activity Reports',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Wallet top-ups, spending patterns, and balance analytics',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class SystemReportsTab extends StatelessWidget {
  const SystemReportsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.assessment,
            size: 64,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            'System Reports',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Comprehensive system usage and performance reports',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}