import 'package:flutter/material.dart';
import 'package:campus_feast/models/admin_models.dart';
import 'package:campus_feast/models/vendor.dart';

class AdminVendorManagementScreen extends StatefulWidget {
  const AdminVendorManagementScreen({super.key});

  @override
  State<AdminVendorManagementScreen> createState() => _AdminVendorManagementScreenState();
}

class _AdminVendorManagementScreenState extends State<AdminVendorManagementScreen> with TickerProviderStateMixin {
  late TabController _tabController;

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
        automaticallyImplyLeading: false,
        title: const Text('Vendor Management'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () => _showBulkActionsDialog(),
            icon: const Icon(Icons.more_vert),
          ),
          const SizedBox(width: 16),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Pending Applications'),
            Tab(text: 'Active Vendors'),
            Tab(text: 'Verification Center'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          PendingApplicationsTab(),
          ActiveVendorsTab(),
          VerificationCenterTab(),
        ],
      ),
    );
  }

  void _showBulkActionsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Bulk Actions'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.download),
              title: const Text('Export Vendor List'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Export functionality
              },
            ),
            ListTile(
              leading: const Icon(Icons.email),
              title: const Text('Send Bulk Notification'),
              onTap: () {
                Navigator.pop(context);
                // TODO: Bulk notification
              },
            ),
          ],
        ),
      ),
    );
  }
}

class PendingApplicationsTab extends StatelessWidget {
  const PendingApplicationsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final pendingVendors = _generateMockPendingVendors();

    return Column(
      children: [
        // Filter Bar
        Container(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search applications...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              FilterChip(
                label: const Text('All'),
                selected: true,
                onSelected: (selected) {},
              ),
              const SizedBox(width: 8),
              FilterChip(
                label: const Text('Pending'),
                selected: false,
                onSelected: (selected) {},
              ),
              const SizedBox(width: 8),
              FilterChip(
                label: const Text('Under Review'),
                selected: false,
                onSelected: (selected) {},
              ),
            ],
          ),
        ),
        
        // Applications List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: pendingVendors.length,
            itemBuilder: (context, index) {
              final vendor = pendingVendors[index];
              return _buildPendingVendorCard(context, vendor);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPendingVendorCard(BuildContext context, PendingVendor vendor) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                  child: Text(
                    vendor.businessName[0].toUpperCase(),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        vendor.businessName,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        vendor.name,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                _buildStatusChip(context, vendor.status),
              ],
            ),
            
            const SizedBox(height: 12),
            
            Row(
              children: [
                Expanded(
                  child: _buildInfoItem(context, 'Type', vendor.businessType),
                ),
                Expanded(
                  child: _buildInfoItem(context, 'Phone', vendor.phone),
                ),
                Expanded(
                  child: _buildInfoItem(context, 'Applied', _formatDate(vendor.applicationDate)),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            Row(
              children: [
                OutlinedButton.icon(
                  onPressed: () => _showVendorDetails(context, vendor),
                  icon: const Icon(Icons.visibility, size: 16),
                  label: const Text('View Details'),
                ),
                const SizedBox(width: 8),
                FilledButton.icon(
                  onPressed: () => _showApprovalDialog(context, vendor),
                  icon: const Icon(Icons.check, size: 16),
                  label: const Text('Approve'),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: () => _showRejectionDialog(context, vendor),
                  icon: const Icon(Icons.close, size: 16),
                  label: const Text('Reject'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context, VendorApplicationStatus status) {
    Color color;
    String text;
    
    switch (status) {
      case VendorApplicationStatus.pending:
        color = Colors.orange;
        text = 'Pending';
        break;
      case VendorApplicationStatus.underReview:
        color = Colors.blue;
        text = 'Under Review';
        break;
      case VendorApplicationStatus.approved:
        color = Colors.green;
        text = 'Approved';
        break;
      case VendorApplicationStatus.rejected:
        color = Colors.red;
        text = 'Rejected';
        break;
      case VendorApplicationStatus.documentsRequired:
        color = Colors.purple;
        text = 'Docs Required';
        break;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildInfoItem(BuildContext context, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  void _showVendorDetails(BuildContext context, PendingVendor vendor) {
    showDialog(
      context: context,
      builder: (context) => VendorDetailsDialog(vendor: vendor),
    );
  }

  void _showApprovalDialog(BuildContext context, PendingVendor vendor) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Approve Vendor'),
        content: Text('Are you sure you want to approve ${vendor.businessName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Approve vendor logic
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${vendor.businessName} approved successfully!')),
              );
            },
            child: const Text('Approve'),
          ),
        ],
      ),
    );
  }

  void _showRejectionDialog(BuildContext context, PendingVendor vendor) {
    final reasonController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reject Application'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Provide a reason for rejecting ${vendor.businessName}:'),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                hintText: 'Rejection reason...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (reasonController.text.trim().isNotEmpty) {
                Navigator.pop(context);
                // TODO: Reject vendor logic
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${vendor.businessName} rejected.')),
                );
              }
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Reject'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  List<PendingVendor> _generateMockPendingVendors() {
    return [
      PendingVendor(
        id: '1',
        name: 'Rajesh Kumar',
        email: 'rajesh@cafecenter.com',
        phone: '+91 9876543210',
        businessName: 'Cafe Central',
        businessType: 'Coffee Shop',
        address: 'Building A, Ground Floor, Campus',
        gstNumber: 'GST123456789',
        panNumber: 'ABCDE1234F',
        applicationDate: DateTime.now().subtract(const Duration(days: 2)),
        status: VendorApplicationStatus.pending,
      ),
      PendingVendor(
        id: '2',
        name: 'Priya Sharma',
        email: 'priya@quickbites.com',
        phone: '+91 9876543211',
        businessName: 'Quick Bites',
        businessType: 'Fast Food',
        address: 'Food Court, Level 2, Campus',
        gstNumber: 'GST987654321',
        panNumber: 'FGHIJ5678K',
        applicationDate: DateTime.now().subtract(const Duration(days: 5)),
        status: VendorApplicationStatus.underReview,
      ),
      PendingVendor(
        id: '3',
        name: 'Mohammed Ali',
        email: 'ali@healthyfood.com',
        phone: '+91 9876543212',
        businessName: 'Healthy Meals',
        businessType: 'Health Food',
        address: 'Near Library, Campus',
        gstNumber: 'GST456789123',
        panNumber: 'LMNOP9012Q',
        applicationDate: DateTime.now().subtract(const Duration(days: 1)),
        status: VendorApplicationStatus.documentsRequired,
      ),
    ];
  }
}

class ActiveVendorsTab extends StatelessWidget {
  const ActiveVendorsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.store,
            size: 64,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            'Active Vendors Management',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Coming in the next implementation phase',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class VerificationCenterTab extends StatelessWidget {
  const VerificationCenterTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.verified_user,
            size: 64,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            'KYC Verification Center',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Document verification and KYC processes',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class VendorDetailsDialog extends StatelessWidget {
  final PendingVendor vendor;

  const VendorDetailsDialog({super.key, required this.vendor});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 600,
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Vendor Application Details',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            
            const Divider(),
            
            const SizedBox(height: 16),
            
            // Business Information
            Text(
              'Business Information',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildDetailRow(context, 'Business Name', vendor.businessName),
            _buildDetailRow(context, 'Business Type', vendor.businessType),
            _buildDetailRow(context, 'Address', vendor.address),
            
            const SizedBox(height: 20),
            
            // Contact Information
            Text(
              'Contact Information',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildDetailRow(context, 'Owner Name', vendor.name),
            _buildDetailRow(context, 'Email', vendor.email),
            _buildDetailRow(context, 'Phone', vendor.phone),
            
            const SizedBox(height: 20),
            
            // Legal Information
            Text(
              'Legal Information',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildDetailRow(context, 'GST Number', vendor.gstNumber),
            _buildDetailRow(context, 'PAN Number', vendor.panNumber),
            _buildDetailRow(context, 'Application Date', _formatDate(vendor.applicationDate)),
            
            const SizedBox(height: 24),
            
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // TODO: View documents
                    },
                    child: const Text('View Documents'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // TODO: Contact vendor
                    },
                    child: const Text('Contact Vendor'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          const Text(': '),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}