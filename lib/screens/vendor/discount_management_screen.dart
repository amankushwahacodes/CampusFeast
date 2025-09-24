import 'package:flutter/material.dart';

class DiscountManagementScreen extends StatefulWidget {
  const DiscountManagementScreen({super.key});

  @override
  State<DiscountManagementScreen> createState() => _DiscountManagementScreenState();
}

class _DiscountManagementScreenState extends State<DiscountManagementScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  
  List<Discount> activeDiscounts = [
    Discount(
      id: '1',
      name: 'Happy Hour Special',
      type: DiscountType.percentage,
      value: 20.0,
      description: 'Get 20% off on all items during happy hours',
      startTime: TimeOfDay(hour: 15, minute: 0),
      endTime: TimeOfDay(hour: 17, minute: 0),
      isActive: true,
      usageCount: 45,
      maxUsage: 100,
    ),
    Discount(
      id: '2',
      name: 'Student Special',
      type: DiscountType.flat,
      value: 15.0,
      description: 'Flat ₹15 off for students',
      minOrderAmount: 50.0,
      isActive: true,
      usageCount: 23,
      maxUsage: 50,
    ),
    Discount(
      id: '3',
      name: 'Combo Deal',
      type: DiscountType.combo,
      value: 25.0,
      description: 'Buy 2 Main Course + 1 Beverage for ₹199',
      applicableItems: ['Veg Biryani', 'Chicken Curry', 'Any Beverage'],
      isActive: true,
      usageCount: 12,
      maxUsage: 30,
    ),
  ];

  List<Discount> inactiveDiscounts = [
    Discount(
      id: '4',
      name: 'Weekend Bonanza',
      type: DiscountType.percentage,
      value: 30.0,
      description: 'Weekend special discount on all items',
      isActive: false,
      usageCount: 67,
      maxUsage: 100,
    ),
  ];

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discount Management'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              text: 'Active (${activeDiscounts.length})',
              icon: const Icon(Icons.check_circle),
            ),
            Tab(
              text: 'Inactive (${inactiveDiscounts.length})',
              icon: const Icon(Icons.cancel),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDiscountsList(activeDiscounts, true),
          _buildDiscountsList(inactiveDiscounts, false),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateDiscountDialog(),
        icon: const Icon(Icons.add),
        label: const Text('Create Offer'),
      ),
    );
  }

  Widget _buildDiscountsList(List<Discount> discounts, bool isActive) {
    if (discounts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isActive ? Icons.local_offer : Icons.local_offer_outlined,
              size: 64,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            Text(
              isActive ? 'No active offers' : 'No inactive offers',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isActive 
                  ? 'Create your first discount offer to boost sales!'
                  : 'Deactivated offers will appear here.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: discounts.length,
      itemBuilder: (context, index) {
        return _buildDiscountCard(discounts[index]);
      },
    );
  }

  Widget _buildDiscountCard(Discount discount) {
    final usagePercent = discount.maxUsage > 0 ? (discount.usageCount / discount.maxUsage) : 0.0;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _getDiscountTypeColor(discount.type).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getDiscountTypeIcon(discount.type),
                    color: _getDiscountTypeColor(discount.type),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        discount.name,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: discount.isActive 
                                  ? Colors.green.withValues(alpha: 0.2)
                                  : Colors.grey.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              discount.isActive ? 'ACTIVE' : 'INACTIVE',
                              style: TextStyle(
                                color: discount.isActive ? Colors.green[700] : Colors.grey[700],
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: _getDiscountTypeColor(discount.type).withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              _getDiscountTypeText(discount.type),
                              style: TextStyle(
                                color: _getDiscountTypeColor(discount.type),
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: discount.isActive,
                  onChanged: (value) {
                    _toggleDiscountStatus(discount);
                  },
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Discount Value
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getDiscountValueText(discount),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (discount.description.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      discount.description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimaryContainer.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Details
            if (discount.startTime != null || discount.endTime != null) ...[
              Row(
                children: [
                  const Icon(Icons.schedule, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    'Time: ${discount.startTime?.format(context) ?? 'Any'} - ${discount.endTime?.format(context) ?? 'Any'}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],

            if (discount.minOrderAmount > 0) ...[
              Row(
                children: [
                  const Icon(Icons.shopping_cart, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    'Minimum order: ₹${discount.minOrderAmount.toStringAsFixed(0)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],

            if (discount.applicableItems.isNotEmpty) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.restaurant_menu, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Applicable to: ${discount.applicableItems.join(', ')}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],

            // Usage Stats
            Row(
              children: [
                const Icon(Icons.analytics, size: 16),
                const SizedBox(width: 8),
                Text(
                  'Used: ${discount.usageCount}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                if (discount.maxUsage > 0) ...[
                  Text(
                    ' / ${discount.maxUsage}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: LinearProgressIndicator(
                      value: usagePercent,
                      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        usagePercent > 0.8 ? Colors.red : Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ],
            ),

            const SizedBox(height: 16),

            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () => _showDiscountDetails(discount),
                  icon: const Icon(Icons.visibility),
                  label: const Text('View'),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: () => _showEditDiscountDialog(discount),
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit'),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: () => _deleteDiscount(discount),
                  icon: const Icon(Icons.delete),
                  label: const Text('Delete'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateDiscountDialog() {
    _showDiscountDialog(null);
  }

  void _showEditDiscountDialog(Discount discount) {
    _showDiscountDialog(discount);
  }

  void _showDiscountDialog(Discount? discount) {
    final isEditing = discount != null;
    final nameController = TextEditingController(text: discount?.name ?? '');
    final descriptionController = TextEditingController(text: discount?.description ?? '');
    final valueController = TextEditingController(text: discount?.value.toString() ?? '');
    final minOrderController = TextEditingController(text: discount?.minOrderAmount.toString() ?? '0');
    final maxUsageController = TextEditingController(text: discount?.maxUsage.toString() ?? '0');
    
    DiscountType selectedType = discount?.type ?? DiscountType.percentage;
    TimeOfDay? startTime = discount?.startTime;
    TimeOfDay? endTime = discount?.endTime;
    bool isActive = discount?.isActive ?? true;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(isEditing ? 'Edit Discount' : 'Create New Discount'),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Discount Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<DiscountType>(
                    value: selectedType,
                    decoration: const InputDecoration(
                      labelText: 'Discount Type',
                      border: OutlineInputBorder(),
                    ),
                    items: DiscountType.values.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(_getDiscountTypeText(type)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setDialogState(() {
                        selectedType = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: valueController,
                          decoration: InputDecoration(
                            labelText: selectedType == DiscountType.percentage 
                                ? 'Discount (%)'
                                : 'Discount Amount (₹)',
                            border: const OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          controller: minOrderController,
                          decoration: const InputDecoration(
                            labelText: 'Min Order (₹)',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: maxUsageController,
                    decoration: const InputDecoration(
                      labelText: 'Max Usage (0 for unlimited)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Time Restrictions (Optional)',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () async {
                            final time = await showTimePicker(
                              context: context,
                              initialTime: startTime ?? TimeOfDay.now(),
                            );
                            if (time != null) {
                              setDialogState(() {
                                startTime = time;
                              });
                            }
                          },
                          child: Text(startTime?.format(context) ?? 'Start Time'),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () async {
                            final time = await showTimePicker(
                              context: context,
                              initialTime: endTime ?? TimeOfDay.now(),
                            );
                            if (time != null) {
                              setDialogState(() {
                                endTime = time;
                              });
                            }
                          },
                          child: Text(endTime?.format(context) ?? 'End Time'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text('Active'),
                    subtitle: const Text('Discount will be available to customers'),
                    value: isActive,
                    onChanged: (value) {
                      setDialogState(() {
                        isActive = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final newDiscount = Discount(
                  id: discount?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                  name: nameController.text,
                  description: descriptionController.text,
                  type: selectedType,
                  value: double.tryParse(valueController.text) ?? 0.0,
                  minOrderAmount: double.tryParse(minOrderController.text) ?? 0.0,
                  maxUsage: int.tryParse(maxUsageController.text) ?? 0,
                  startTime: startTime,
                  endTime: endTime,
                  isActive: isActive,
                  usageCount: discount?.usageCount ?? 0,
                );

                setState(() {
                  if (isEditing) {
                    // Remove from both lists
                    activeDiscounts.removeWhere((d) => d.id == discount!.id);
                    inactiveDiscounts.removeWhere((d) => d.id == discount!.id);
                    
                    // Add to appropriate list
                    if (newDiscount.isActive) {
                      activeDiscounts.add(newDiscount);
                    } else {
                      inactiveDiscounts.add(newDiscount);
                    }
                  } else {
                    if (newDiscount.isActive) {
                      activeDiscounts.add(newDiscount);
                    } else {
                      inactiveDiscounts.add(newDiscount);
                    }
                  }
                });

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(isEditing 
                        ? 'Discount updated successfully' 
                        : 'Discount created successfully'),
                  ),
                );
              },
              child: Text(isEditing ? 'Update' : 'Create'),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleDiscountStatus(Discount discount) {
    setState(() {
      final updatedDiscount = Discount(
        id: discount.id,
        name: discount.name,
        description: discount.description,
        type: discount.type,
        value: discount.value,
        minOrderAmount: discount.minOrderAmount,
        maxUsage: discount.maxUsage,
        startTime: discount.startTime,
        endTime: discount.endTime,
        applicableItems: discount.applicableItems,
        isActive: !discount.isActive,
        usageCount: discount.usageCount,
      );

      if (discount.isActive) {
        activeDiscounts.removeWhere((d) => d.id == discount.id);
        inactiveDiscounts.add(updatedDiscount);
      } else {
        inactiveDiscounts.removeWhere((d) => d.id == discount.id);
        activeDiscounts.add(updatedDiscount);
      }
    });
  }

  void _showDiscountDetails(Discount discount) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(discount.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Type: ${_getDiscountTypeText(discount.type)}'),
            const SizedBox(height: 8),
            Text('Value: ${_getDiscountValueText(discount)}'),
            const SizedBox(height: 8),
            Text('Description: ${discount.description}'),
            const SizedBox(height: 8),
            Text('Usage: ${discount.usageCount}/${discount.maxUsage == 0 ? '∞' : discount.maxUsage}'),
            if (discount.startTime != null || discount.endTime != null) ...[
              const SizedBox(height: 8),
              Text('Time: ${discount.startTime?.format(context) ?? 'Any'} - ${discount.endTime?.format(context) ?? 'Any'}'),
            ],
            if (discount.minOrderAmount > 0) ...[
              const SizedBox(height: 8),
              Text('Minimum Order: ₹${discount.minOrderAmount.toStringAsFixed(0)}'),
            ],
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

  void _deleteDiscount(Discount discount) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Discount'),
        content: Text('Are you sure you want to delete "${discount.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              setState(() {
                activeDiscounts.removeWhere((d) => d.id == discount.id);
                inactiveDiscounts.removeWhere((d) => d.id == discount.id);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Discount deleted successfully')),
              );
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Color _getDiscountTypeColor(DiscountType type) {
    switch (type) {
      case DiscountType.percentage:
        return Colors.blue;
      case DiscountType.flat:
        return Colors.green;
      case DiscountType.combo:
        return Colors.purple;
    }
  }

  IconData _getDiscountTypeIcon(DiscountType type) {
    switch (type) {
      case DiscountType.percentage:
        return Icons.percent;
      case DiscountType.flat:
        return Icons.money_off;
      case DiscountType.combo:
        return Icons.local_offer;
    }
  }

  String _getDiscountTypeText(DiscountType type) {
    switch (type) {
      case DiscountType.percentage:
        return 'Percentage';
      case DiscountType.flat:
        return 'Flat Amount';
      case DiscountType.combo:
        return 'Combo Deal';
    }
  }

  String _getDiscountValueText(Discount discount) {
    switch (discount.type) {
      case DiscountType.percentage:
        return '${discount.value.toStringAsFixed(0)}% OFF';
      case DiscountType.flat:
        return '₹${discount.value.toStringAsFixed(0)} OFF';
      case DiscountType.combo:
        return 'Combo for ₹${discount.value.toStringAsFixed(0)}';
    }
  }
}

class Discount {
  final String id;
  final String name;
  final String description;
  final DiscountType type;
  final double value;
  final double minOrderAmount;
  final int maxUsage;
  final TimeOfDay? startTime;
  final TimeOfDay? endTime;
  final List<String> applicableItems;
  final bool isActive;
  final int usageCount;

  Discount({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.value,
    this.minOrderAmount = 0.0,
    this.maxUsage = 0,
    this.startTime,
    this.endTime,
    this.applicableItems = const [],
    this.isActive = true,
    this.usageCount = 0,
  });
}

enum DiscountType { percentage, flat, combo }