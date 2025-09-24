import 'package:flutter/material.dart';
import 'package:campus_feast/models/admin_models.dart';

class AdminSupportScreen extends StatefulWidget {
  const AdminSupportScreen({super.key});

  @override
  State<AdminSupportScreen> createState() => _AdminSupportScreenState();
}

class _AdminSupportScreenState extends State<AdminSupportScreen> with TickerProviderStateMixin {
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
        title: const Text('Support & Feedback'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          Badge(
            label: const Text('7'),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications_outlined),
            ),
          ),
          const SizedBox(width: 16),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Support Tickets'),
            Tab(text: 'Feedback Management'),
            Tab(text: 'Knowledge Base'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          SupportTicketsTab(),
          FeedbackManagementTab(),
          KnowledgeBaseTab(),
        ],
      ),
    );
  }
}

class SupportTicketsTab extends StatefulWidget {
  const SupportTicketsTab({super.key});

  @override
  State<SupportTicketsTab> createState() => _SupportTicketsTabState();
}

class _SupportTicketsTabState extends State<SupportTicketsTab> {
  String _selectedFilter = 'All';
  
  @override
  Widget build(BuildContext context) {
    final tickets = _generateMockTickets();
    
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
                    hintText: 'Search tickets...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              ...['All', 'Open', 'In Progress', 'Resolved'].map((filter) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(filter),
                    selected: _selectedFilter == filter,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() => _selectedFilter = filter);
                      }
                    },
                  ),
                );
              }),
            ],
          ),
        ),
        
        // Quick Stats
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: _buildQuickStat(context, 'Open', '7', Colors.red),
              ),
              Expanded(
                child: _buildQuickStat(context, 'In Progress', '12', Colors.orange),
              ),
              Expanded(
                child: _buildQuickStat(context, 'Resolved Today', '23', Colors.green),
              ),
              Expanded(
                child: _buildQuickStat(context, 'Avg Response Time', '2.3h', Colors.blue),
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Tickets List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: tickets.length,
            itemBuilder: (context, index) {
              final ticket = tickets[index];
              return _buildTicketCard(context, ticket);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStat(BuildContext context, String label, String value, Color color) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTicketCard(BuildContext context, ComplaintTicket ticket) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getPriorityColor(ticket.priority).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    ticket.priority.name.toUpperCase(),
                    style: TextStyle(
                      color: _getPriorityColor(ticket.priority),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '#${ticket.id}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const Spacer(),
                _buildStatusChip(context, ticket.status),
              ],
            ),
            
            const SizedBox(height: 12),
            
            Text(
              ticket.subject,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 8),
            
            Text(
              ticket.description,
              style: Theme.of(context).textTheme.bodyMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            
            const SizedBox(height: 12),
            
            Row(
              children: [
                Icon(
                  Icons.person_outline,
                  size: 16,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 4),
                Text(
                  ticket.userName,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(width: 16),
                Icon(
                  Icons.category_outlined,
                  size: 16,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 4),
                Text(
                  ticket.category.name,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const Spacer(),
                Text(
                  _formatDateTime(ticket.createdAt),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            Row(
              children: [
                OutlinedButton.icon(
                  onPressed: () => _showTicketDetails(context, ticket),
                  icon: const Icon(Icons.visibility, size: 16),
                  label: const Text('View Details'),
                ),
                const SizedBox(width: 8),
                if (ticket.status != ComplaintStatus.resolved)
                  FilledButton.icon(
                    onPressed: () => _showReplyDialog(context, ticket),
                    icon: const Icon(Icons.reply, size: 16),
                    label: const Text('Reply'),
                  ),
                if (ticket.status == ComplaintStatus.open)
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: OutlinedButton.icon(
                      onPressed: () => _assignTicket(context, ticket),
                      icon: const Icon(Icons.assignment_ind, size: 16),
                      label: const Text('Assign'),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context, ComplaintStatus status) {
    Color color;
    String text;
    
    switch (status) {
      case ComplaintStatus.open:
        color = Colors.red;
        text = 'Open';
        break;
      case ComplaintStatus.inProgress:
        color = Colors.orange;
        text = 'In Progress';
        break;
      case ComplaintStatus.resolved:
        color = Colors.green;
        text = 'Resolved';
        break;
      case ComplaintStatus.closed:
        color = Colors.grey;
        text = 'Closed';
        break;
      case ComplaintStatus.escalated:
        color = Colors.purple;
        text = 'Escalated';
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

  Color _getPriorityColor(ComplaintPriority priority) {
    switch (priority) {
      case ComplaintPriority.low:
        return Colors.green;
      case ComplaintPriority.medium:
        return Colors.orange;
      case ComplaintPriority.high:
        return Colors.red;
      case ComplaintPriority.urgent:
        return Colors.purple;
    }
  }

  void _showTicketDetails(BuildContext context, ComplaintTicket ticket) {
    showDialog(
      context: context,
      builder: (context) => TicketDetailsDialog(ticket: ticket),
    );
  }

  void _showReplyDialog(BuildContext context, ComplaintTicket ticket) {
    final replyController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          width: 500,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Reply to Ticket #${ticket.id}',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: replyController,
                decoration: const InputDecoration(
                  hintText: 'Type your reply...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Spacer(),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: () {
                      if (replyController.text.trim().isNotEmpty) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Reply sent successfully!')),
                        );
                      }
                    },
                    child: const Text('Send Reply'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _assignTicket(BuildContext context, ComplaintTicket ticket) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Assign Ticket #${ticket.id}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Admin User 1'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Ticket assigned successfully!')),
                );
              },
            ),
            ListTile(
              title: const Text('Admin User 2'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Ticket assigned successfully!')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  List<ComplaintTicket> _generateMockTickets() {
    return [
      ComplaintTicket(
        id: '1001',
        userId: 'user1',
        userName: 'John Doe',
        userType: 'Student',
        subject: 'Payment failed but amount deducted',
        description: 'I tried to order from Cafe Central but the payment failed, however the amount was deducted from my wallet.',
        category: ComplaintCategory.payment,
        status: ComplaintStatus.open,
        priority: ComplaintPriority.high,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      ComplaintTicket(
        id: '1002',
        userId: 'user2',
        userName: 'Alice Smith',
        userType: 'Staff',
        subject: 'Order never delivered',
        description: 'I placed an order 2 hours ago from Quick Bites but it was never delivered. The status still shows preparing.',
        category: ComplaintCategory.order,
        status: ComplaintStatus.inProgress,
        priority: ComplaintPriority.medium,
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
        assignedTo: 'Admin User 1',
      ),
      ComplaintTicket(
        id: '1003',
        userId: 'user3',
        userName: 'Bob Johnson',
        userType: 'Student',
        subject: 'App keeps crashing',
        description: 'The app crashes whenever I try to browse the menu from Healthy Meals vendor.',
        category: ComplaintCategory.technical,
        status: ComplaintStatus.resolved,
        priority: ComplaintPriority.low,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        resolvedAt: DateTime.now().subtract(const Duration(hours: 3)),
        resolution: 'Fixed the menu loading issue in the latest app update.',
      ),
    ];
  }
}

class FeedbackManagementTab extends StatelessWidget {
  const FeedbackManagementTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.feedback,
            size: 64,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            'Feedback Management',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'Manage user feedback, reviews, and suggestions',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class KnowledgeBaseTab extends StatelessWidget {
  const KnowledgeBaseTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.library_books,
            size: 64,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            'Knowledge Base',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(
            'FAQs, documentation, and help articles',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class TicketDetailsDialog extends StatelessWidget {
  final ComplaintTicket ticket;

  const TicketDetailsDialog({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 600,
        constraints: const BoxConstraints(maxHeight: 600),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Ticket #${ticket.id}',
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
            
            // Ticket Details
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow('Subject', ticket.subject),
                    _buildDetailRow('User', '${ticket.userName} (${ticket.userType})'),
                    _buildDetailRow('Category', ticket.category.name),
                    _buildDetailRow('Priority', ticket.priority.name),
                    _buildDetailRow('Status', ticket.status.name),
                    _buildDetailRow('Created', _formatDateTime(ticket.createdAt)),
                    if (ticket.assignedTo != null)
                      _buildDetailRow('Assigned To', ticket.assignedTo!),
                    
                    const SizedBox(height: 20),
                    
                    Text(
                      'Description',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(ticket.description),
                    
                    if (ticket.resolution != null) ...[
                      const SizedBox(height: 20),
                      Text(
                        'Resolution',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(ticket.resolution!),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            Row(
              children: [
                if (ticket.status != ComplaintStatus.resolved) ...[
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // TODO: Mark as resolved
                    },
                    child: const Text('Mark Resolved'),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: () {
                      Navigator.pop(context);
                      // TODO: Reply to ticket
                    },
                    child: const Text('Reply'),
                  ),
                ] else
                  Text(
                    'Resolved on ${_formatDateTime(ticket.resolvedAt!)}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.green,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}