import 'package:flutter/material.dart';

class AdminReportsScreen extends StatefulWidget {
  const AdminReportsScreen({super.key});

  @override
  State createState() => _AdminReportsScreenState();
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
          IconButton(onPressed: _showDateRangeDialog, icon: const Icon(Icons.date_range)),
          IconButton(onPressed: _showExportDialog, icon: const Icon(Icons.download)),
          const SizedBox(width: 16),
        ],
        bottom: TabBar(
          isScrollable: true,
          controller: _tabController,
          tabs: const [
            Tab(text: 'Transactions'),
            Tab(text: 'Settlements'),
            Tab(text: 'Wallet Activity'),
            Tab(text: 'System Reports'),
          ],
        ),
      ),
      body: SafeArea(
        child: TabBarView(
          controller: _tabController,
          children: const [
            TransactionReportsTab(),
            SettlementReportsTab(),
            WalletActivityTab(),
            SystemReportsTab(),
          ],
        ),
      ),
    );
  }

  void _showDateRangeDialog() {
    showDialog(
      context: context,
      builder: (context) => const AlertDialog(
        title: Text('Select Date Range'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(title: Text('Today')),
            ListTile(title: Text('Last 7 days')),
            ListTile(title: Text('Last 30 days')),
            ListTile(title: Text('Custom Range')),
          ],
        ),
      ),
    );
  }

  void _showExportDialog() {
    showDialog(
      context: context,
      builder: (context) => const AlertDialog(
        title: Text('Export Data'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(leading: Icon(Icons.table_chart), title: Text('Export as Excel')),
            ListTile(leading: Icon(Icons.picture_as_pdf), title: Text('Export as PDF')),
            ListTile(leading: Icon(Icons.code), title: Text('Export as CSV')),
          ],
        ),
      ),
    );
  }
}

class TransactionReportsTab extends StatelessWidget {
  const TransactionReportsTab({super.key});

  int _cols(double w) {
    if (w < 600) return 1;
    if (w < 900) return 2;
    if (w < 1200) return 3;
    return 4;
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Summary Cards as responsive grid
          GridView(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: _cols(w),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.6,
            ),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildSummaryCard(context, 'Total Transactions', '12,486', 'Today: 156', Icons.receipt_long, Colors.blue),
              _buildSummaryCard(context, 'Transaction Volume', '₹5,67,890', 'Today: ₹12,456', Icons.currency_rupee, Colors.green),
              _buildSummaryCard(context, 'Average Order Value', '₹45.50', '↑ 12% from last month', Icons.trending_up, Colors.orange),
              _buildSummaryCard(context, 'Failed Transactions', '23', '0.18% failure rate', Icons.error_outline, Colors.red),
            ],
          ),
          const SizedBox(height: 32),
          // Transactions Table
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Recent Transactions', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    FilterChip(label: const Text('All'), selected: true, onSelected: (_) {}),
                    FilterChip(label: const Text('Success'), selected: false, onSelected: (_) {}),
                    FilterChip(label: const Text('Failed'), selected: false, onSelected: (_) {}),
                  ],
                ),
                const SizedBox(height: 20),
                _buildTransactionsTable(context),
              ]),
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
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 12),
            Expanded(child: Text(title, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant))),
          ]),
          const SizedBox(height: 12),
          Text(value, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(subtitle, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
        ]),
      ),
    );
  }

  Widget _buildTransactionsTable(BuildContext context) {
    final transactions = _generateMockTransactions();
    return LayoutBuilder(builder: (context, constraints) {
      final compact = constraints.maxWidth < 700;

      final columns = compact
          ? const [
              DataColumn(label: Text('ID')),
              DataColumn(label: Text('User')),
              DataColumn(label: Text('Amt')),
              DataColumn(label: Text('Status')),
            ]
          : const [
              DataColumn(label: Text('Transaction ID')),
              DataColumn(label: Text('User')),
              DataColumn(label: Text('Vendor')),
              DataColumn(label: Text('Amount')),
              DataColumn(label: Text('Type')),
              DataColumn(label: Text('Status')),
              DataColumn(label: Text('Date')),
            ];

      final rows = transactions.map((t) {
        return DataRow(
          cells: compact
              ? [
                  DataCell(Text(t['id']!)),
                  DataCell(Text(t['user']!)),
                  DataCell(Text(t['amount']!)),
                  DataCell(_statusChip(context, t['status']!)),
                ]
              : [
                  DataCell(Text(t['id']!)),
                  DataCell(Text(t['user']!)),
                  DataCell(Text(t['vendor']!)),
                  DataCell(Text(t['amount']!)),
                  DataCell(Text(t['type']!)),
                  DataCell(_statusChip(context, t['status']!)),
                  DataCell(Text(t['date']!)),
                ],
        );
      }).toList();

      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: compact ? 520 : constraints.maxWidth),
          child: DataTable(columns: columns, rows: rows),
        ),
      );
    });
  }

  Widget _statusChip(BuildContext context, String status) {
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
      decoration: BoxDecoration(color: color.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)),
      child: Text(status, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }

  List<Map<String, String>> _generateMockTransactions() {
    return [
      {'id': 'TXN001234', 'user': 'John Doe', 'vendor': 'Cafe Central', 'amount': '₹125.50', 'type': 'Order Payment', 'status': 'Success', 'date': '12/12/2024 14:30'},
      {'id': 'TXN001235', 'user': 'Alice Smith', 'vendor': 'Quick Bites', 'amount': '₹89.00', 'type': 'Order Payment', 'status': 'Success', 'date': '12/12/2024 14:28'},
      {'id': 'TXN001236', 'user': 'Bob Johnson', 'vendor': 'Healthy Meals', 'amount': '₹156.75', 'type': 'Order Payment', 'status': 'Failed', 'date': '12/12/2024 14:25'},
    ];
  }
}

class SettlementReportsTab extends StatelessWidget {
  const SettlementReportsTab({super.key});

  int _cols(double w) {
    if (w < 600) return 1;
    if (w < 900) return 2;
    return 3;
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        GridView(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: _cols(w),
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.8,
          ),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildSettlementCard(context, 'Pending Settlements', '₹45,680', '12 vendors', Icons.pending_actions, Colors.orange),
            _buildSettlementCard(context, 'Processed Today', '₹1,23,456', '25 settlements', Icons.check_circle, Colors.green),
            _buildSettlementCard(context, 'This Month', '₹12,45,890', '456 settlements', Icons.calendar_today, Colors.blue),
          ],
        ),
        const SizedBox(height: 32),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                children: [
                  Text('Settlement Reports', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const Spacer(),
                  FilledButton.icon(onPressed: () {}, icon: const Icon(Icons.add, size: 16), label: const Text('Process Settlement')),
                ],
              ),
              const SizedBox(height: 20),
              _buildSettlementsTable(context),
            ]),
          ),
        ),
      ]),
    );
  }

  Widget _buildSettlementCard(BuildContext context, String title, String amount, String subtitle, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Text(title, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
            ),
          ]),
          const SizedBox(height: 12),
          Text(amount, style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(subtitle, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
        ]),
      ),
    );
  }

  Widget _buildSettlementsTable(BuildContext context) {
    final settlements = _generateMockSettlements();
    return LayoutBuilder(builder: (context, constraints) {
      final compact = constraints.maxWidth < 750;

      final columns = compact
          ? const [
              DataColumn(label: Text('ID')),
              DataColumn(label: Text('Vendor')),
              DataColumn(label: Text('Amount')),
              DataColumn(label: Text('Status')),
            ]
          : const [
              DataColumn(label: Text('Settlement ID')),
              DataColumn(label: Text('Vendor')),
              DataColumn(label: Text('Period')),
              DataColumn(label: Text('Total Sales')),
              DataColumn(label: Text('Commission')),
              DataColumn(label: Text('Settlement Amount')),
              DataColumn(label: Text('Status')),
              DataColumn(label: Text('Actions')),
            ];

      final rows = settlements.map((s) {
        return DataRow(
          cells: compact
              ? [
                  DataCell(Text(s['id']!)),
                  DataCell(Text(s['vendor']!)),
                  DataCell(Text(s['amount']!)),
                  DataCell(_statusChip(context, s['status']!)),
                ]
              : [
                  DataCell(Text(s['id']!)),
                  DataCell(Text(s['vendor']!)),
                  DataCell(Text(s['period']!)),
                  DataCell(Text(s['sales']!)),
                  DataCell(Text(s['commission']!)),
                  DataCell(Text(s['amount']!)),
                  DataCell(_statusChip(context, s['status']!)),
                  DataCell(Row(mainAxisSize: MainAxisSize.min, children: [
                    IconButton(onPressed: () {}, icon: const Icon(Icons.visibility, size: 16), tooltip: 'View Details'),
                    IconButton(onPressed: () {}, icon: const Icon(Icons.download, size: 16), tooltip: 'Download Report'),
                  ])),
                ],
        );
      }).toList();

      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: compact ? 560 : constraints.maxWidth),
          child: DataTable(columns: columns, rows: rows),
        ),
      );
    });
  }

  Widget _statusChip(BuildContext context, String status) {
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
      decoration: BoxDecoration(color: color.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)),
      child: Text(status, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600)),
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
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.account_balance_wallet, size: 64, color: Theme.of(context).colorScheme.onSurfaceVariant),
        const SizedBox(height: 16),
        Text('Wallet Activity Reports', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        Text(
          'Wallet top-ups, spending patterns, and balance analytics',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
      ]),
    );
  }
}

class SystemReportsTab extends StatelessWidget {
  const SystemReportsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.assessment, size: 64, color: Theme.of(context).colorScheme.onSurfaceVariant),
        const SizedBox(height: 16),
        Text('System Reports', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        Text(
          'Comprehensive system usage and performance reports',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
        ),
      ]),
    );
  }
}
