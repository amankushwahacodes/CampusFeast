import 'package:flutter/material.dart';

class PickupSlotsScreen extends StatefulWidget {
  const PickupSlotsScreen({super.key});

  @override
  State<PickupSlotsScreen> createState() => _PickupSlotsScreenState();
}

class _PickupSlotsScreenState extends State<PickupSlotsScreen> {
  List<PickupSlot> slots = [
    PickupSlot(
      startTime: const TimeOfDay(hour: 9, minute: 0),
      endTime: const TimeOfDay(hour: 9, minute: 30),
      capacity: 10,
      booked: 7,
      prepTime: 15,
      isActive: true,
    ),
    PickupSlot(
      startTime: const TimeOfDay(hour: 9, minute: 30),
      endTime: const TimeOfDay(hour: 10, minute: 0),
      capacity: 10,
      booked: 10,
      prepTime: 15,
      isActive: true,
    ),
    PickupSlot(
      startTime: const TimeOfDay(hour: 10, minute: 0),
      endTime: const TimeOfDay(hour: 10, minute: 30),
      capacity: 12,
      booked: 5,
      prepTime: 15,
      isActive: true,
    ),
    PickupSlot(
      startTime: const TimeOfDay(hour: 10, minute: 30),
      endTime: const TimeOfDay(hour: 11, minute: 0),
      capacity: 12,
      booked: 8,
      prepTime: 15,
      isActive: true,
    ),
    PickupSlot(
      startTime: const TimeOfDay(hour: 11, minute: 0),
      endTime: const TimeOfDay(hour: 11, minute: 30),
      capacity: 15,
      booked: 3,
      prepTime: 20,
      isActive: true,
    ),
    PickupSlot(
      startTime: const TimeOfDay(hour: 11, minute: 30),
      endTime: const TimeOfDay(hour: 12, minute: 0),
      capacity: 15,
      booked: 12,
      prepTime: 20,
      isActive: true,
    ),
    PickupSlot(
      startTime: const TimeOfDay(hour: 12, minute: 0),
      endTime: const TimeOfDay(hour: 12, minute: 30),
      capacity: 20,
      booked: 18,
      prepTime: 25,
      isActive: true,
    ),
    PickupSlot(
      startTime: const TimeOfDay(hour: 12, minute: 30),
      endTime: const TimeOfDay(hour: 13, minute: 0),
      capacity: 20,
      booked: 20,
      prepTime: 25,
      isActive: true,
    ),
    PickupSlot(
      startTime: const TimeOfDay(hour: 13, minute: 0),
      endTime: const TimeOfDay(hour: 13, minute: 30),
      capacity: 15,
      booked: 6,
      prepTime: 20,
      isActive: false,
    ),
    PickupSlot(
      startTime: const TimeOfDay(hour: 15, minute: 0),
      endTime: const TimeOfDay(hour: 15, minute: 30),
      capacity: 10,
      booked: 2,
      prepTime: 15,
      isActive: true,
    ),
  ];

  int defaultCapacity = 10;
  int defaultPrepTime = 15;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pickup Slots Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _showGlobalSettings(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Summary Card
          Container(
            margin: const EdgeInsets.all(16),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Today\'s Overview',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildSummaryItem(
                            'Total Slots',
                            '${slots.length}',
                            Icons.schedule,
                            Colors.blue,
                          ),
                        ),
                        Expanded(
                          child: _buildSummaryItem(
                            'Active Slots',
                            '${slots.where((s) => s.isActive).length}',
                            Icons.check_circle,
                            Colors.green,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildSummaryItem(
                            'Total Capacity',
                            '${slots.where((s) => s.isActive).fold(0, (sum, slot) => sum + slot.capacity)}',
                            Icons.groups,
                            Colors.purple,
                          ),
                        ),
                        Expanded(
                          child: _buildSummaryItem(
                            'Bookings',
                            '${slots.fold(0, (sum, slot) => sum + slot.booked)}',
                            Icons.book_online,
                            Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Slots List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: slots.length,
              itemBuilder: (context, index) {
                final slot = slots[index];
                return _buildSlotCard(slot, index);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddSlotDialog(),
        icon: const Icon(Icons.add),
        label: const Text('Add Slot'),
      ),
    );
  }

  Widget _buildSummaryItem(String title, String value, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
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
      ],
    );
  }

  Widget _buildSlotCard(PickupSlot slot, int index) {
    final utilizationPercent = slot.capacity > 0 ? (slot.booked / slot.capacity) : 0.0;
    final isFullyBooked = slot.booked >= slot.capacity;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: slot.isActive 
                        ? (isFullyBooked ? Colors.red : Colors.green)
                        : Colors.grey,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    slot.isActive 
                        ? (isFullyBooked ? Icons.block : Icons.schedule)
                        : Icons.pause_circle,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${slot.startTime.format(context)} - ${slot.endTime.format(context)}',
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
                              color: slot.isActive 
                                  ? Colors.green.withValues(alpha: 0.2)
                                  : Colors.grey.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              slot.isActive ? 'ACTIVE' : 'INACTIVE',
                              style: TextStyle(
                                color: slot.isActive ? Colors.green[700] : Colors.grey[700],
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          if (isFullyBooked && slot.isActive)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.red.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'FULL',
                                style: TextStyle(
                                  color: Colors.red[700],
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
                  value: slot.isActive,
                  onChanged: (value) {
                    setState(() {
                      slots[index] = slot.copyWith(isActive: value);
                    });
                    
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(value 
                            ? 'Slot activated successfully'
                            : 'Slot deactivated successfully'),
                      ),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Capacity and Bookings
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Capacity & Bookings',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            '${slot.booked}',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: isFullyBooked ? Colors.red : Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            ' / ${slot.capacity}',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Prep Time',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.timer, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            '${slot.prepTime} min',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Utilization Bar
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Utilization',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                    Text(
                      '${(utilizationPercent * 100).toStringAsFixed(0)}%',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: utilizationPercent > 0.8 ? Colors.red : Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: utilizationPercent,
                  backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    utilizationPercent > 0.9 
                        ? Colors.red
                        : utilizationPercent > 0.7 
                            ? Colors.orange
                            : Colors.green,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () => _showSlotDetails(slot),
                  icon: const Icon(Icons.visibility),
                  label: const Text('View'),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: () => _showEditSlotDialog(slot, index),
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit'),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: () => _deleteSlot(index),
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

  void _showAddSlotDialog() {
    _showSlotDialog(null, null);
  }

  void _showEditSlotDialog(PickupSlot slot, int index) {
    _showSlotDialog(slot, index);
  }

  void _showSlotDialog(PickupSlot? slot, int? index) {
    final isEditing = slot != null;
    TimeOfDay startTime = slot?.startTime ?? const TimeOfDay(hour: 9, minute: 0);
    TimeOfDay endTime = slot?.endTime ?? const TimeOfDay(hour: 9, minute: 30);
    final capacityController = TextEditingController(text: (slot?.capacity ?? defaultCapacity).toString());
    final prepTimeController = TextEditingController(text: (slot?.prepTime ?? defaultPrepTime).toString());
    bool isActive = slot?.isActive ?? true;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(isEditing ? 'Edit Pickup Slot' : 'Add Pickup Slot'),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Time Selection
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () async {
                            final time = await showTimePicker(
                              context: context,
                              initialTime: startTime,
                            );
                            if (time != null) {
                              setDialogState(() {
                                startTime = time;
                              });
                            }
                          },
                          child: Column(
                            children: [
                              const Text('Start Time'),
                              const SizedBox(height: 4),
                              Text(
                                startTime.format(context),
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () async {
                            final time = await showTimePicker(
                              context: context,
                              initialTime: endTime,
                            );
                            if (time != null) {
                              setDialogState(() {
                                endTime = time;
                              });
                            }
                          },
                          child: Column(
                            children: [
                              const Text('End Time'),
                              const SizedBox(height: 4),
                              Text(
                                endTime.format(context),
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Capacity and Prep Time
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: capacityController,
                          decoration: const InputDecoration(
                            labelText: 'Capacity',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.groups),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          controller: prepTimeController,
                          decoration: const InputDecoration(
                            labelText: 'Prep Time (min)',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.timer),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Active Switch
                  SwitchListTile(
                    title: const Text('Active'),
                    subtitle: const Text('Slot will be available for bookings'),
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
                final newSlot = PickupSlot(
                  startTime: startTime,
                  endTime: endTime,
                  capacity: int.tryParse(capacityController.text) ?? defaultCapacity,
                  booked: slot?.booked ?? 0,
                  prepTime: int.tryParse(prepTimeController.text) ?? defaultPrepTime,
                  isActive: isActive,
                );

                setState(() {
                  if (isEditing && index != null) {
                    slots[index] = newSlot;
                  } else {
                    slots.add(newSlot);
                    // Sort slots by start time
                    slots.sort((a, b) => _timeOfDayToMinutes(a.startTime).compareTo(_timeOfDayToMinutes(b.startTime)));
                  }
                });

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(isEditing 
                        ? 'Slot updated successfully'
                        : 'Slot added successfully'),
                  ),
                );
              },
              child: Text(isEditing ? 'Update' : 'Add'),
            ),
          ],
        ),
      ),
    );
  }

  void _showSlotDetails(PickupSlot slot) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Slot Details'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Time Slot', '${slot.startTime.format(context)} - ${slot.endTime.format(context)}'),
            _buildDetailRow('Capacity', '${slot.capacity} orders'),
            _buildDetailRow('Current Bookings', '${slot.booked} orders'),
            _buildDetailRow('Available', '${slot.capacity - slot.booked} orders'),
            _buildDetailRow('Preparation Time', '${slot.prepTime} minutes'),
            _buildDetailRow('Status', slot.isActive ? 'Active' : 'Inactive'),
            _buildDetailRow('Utilization', '${((slot.booked / slot.capacity) * 100).toStringAsFixed(1)}%'),
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

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(value),
        ],
      ),
    );
  }

  void _deleteSlot(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Slot'),
        content: const Text('Are you sure you want to delete this pickup slot?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              setState(() {
                slots.removeAt(index);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Slot deleted successfully')),
              );
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showGlobalSettings() {
    final capacityController = TextEditingController(text: defaultCapacity.toString());
    final prepTimeController = TextEditingController(text: defaultPrepTime.toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Global Settings'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: capacityController,
              decoration: const InputDecoration(
                labelText: 'Default Capacity',
                border: OutlineInputBorder(),
                helperText: 'Used for new slots',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: prepTimeController,
              decoration: const InputDecoration(
                labelText: 'Default Prep Time (minutes)',
                border: OutlineInputBorder(),
                helperText: 'Used for new slots',
              ),
              keyboardType: TextInputType.number,
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
              setState(() {
                defaultCapacity = int.tryParse(capacityController.text) ?? 10;
                defaultPrepTime = int.tryParse(prepTimeController.text) ?? 15;
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Settings updated successfully')),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  int _timeOfDayToMinutes(TimeOfDay time) {
    return time.hour * 60 + time.minute;
  }
}

class PickupSlot {
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final int capacity;
  final int booked;
  final int prepTime;
  final bool isActive;

  PickupSlot({
    required this.startTime,
    required this.endTime,
    required this.capacity,
    required this.booked,
    required this.prepTime,
    required this.isActive,
  });

  PickupSlot copyWith({
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    int? capacity,
    int? booked,
    int? prepTime,
    bool? isActive,
  }) {
    return PickupSlot(
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      capacity: capacity ?? this.capacity,
      booked: booked ?? this.booked,
      prepTime: prepTime ?? this.prepTime,
      isActive: isActive ?? this.isActive,
    );
  }
}