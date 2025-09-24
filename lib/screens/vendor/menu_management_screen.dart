import 'package:flutter/material.dart';
import 'package:campus_feast/models/menu_item.dart';

class VendorMenuItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category;
  final bool isVeg;
  final bool isAvailable;
  final String imageUrl;
  final int prepTime;

  VendorMenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.isVeg,
    required this.isAvailable,
    required this.imageUrl,
    required this.prepTime,
  });

  VendorMenuItem copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? category,
    bool? isVeg,
    bool? isAvailable,
    String? imageUrl,
    int? prepTime,
  }) {
    return VendorMenuItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      category: category ?? this.category,
      isVeg: isVeg ?? this.isVeg,
      isAvailable: isAvailable ?? this.isAvailable,
      imageUrl: imageUrl ?? this.imageUrl,
      prepTime: prepTime ?? this.prepTime,
    );
  }
}

class MenuManagementScreen extends StatefulWidget {
  const MenuManagementScreen({super.key});

  @override
  State<MenuManagementScreen> createState() => _MenuManagementScreenState();
}

class _MenuManagementScreenState extends State<MenuManagementScreen> {
  String selectedCategory = 'All';
  final List<String> categories = ['All', 'Main Course', 'Snacks', 'Beverages', 'Desserts'];
  
  List<VendorMenuItem> menuItems = [
    VendorMenuItem(
      id: '1',
      name: 'Veg Biryani',
      description: 'Aromatic basmati rice with mixed vegetables and spices',
      price: 90.0,
      category: 'Main Course',
      isVeg: true,
      isAvailable: true,
      imageUrl: 'https://images.unsplash.com/photo-1563379091339-03246963d7d3?w=300&h=200&fit=crop',
      prepTime: 15,
    ),
    VendorMenuItem(
      id: '2',
      name: 'Chicken Curry',
      description: 'Traditional chicken curry with aromatic spices',
      price: 120.0,
      category: 'Main Course',
      isVeg: false,
      isAvailable: true,
      imageUrl: 'https://images.unsplash.com/photo-1565557623262-b51c2513a641?w=300&h=200&fit=crop',
      prepTime: 20,
    ),
    VendorMenuItem(
      id: '3',
      name: 'Samosa',
      description: 'Crispy fried pastry with spiced potato filling',
      price: 15.0,
      category: 'Snacks',
      isVeg: true,
      isAvailable: false,
      imageUrl: 'https://images.unsplash.com/photo-1601050690597-df0568f70950?w=300&h=200&fit=crop',
      prepTime: 5,
    ),
    VendorMenuItem(
      id: '4',
      name: 'Masala Tea',
      description: 'Traditional Indian spiced tea',
      price: 10.0,
      category: 'Beverages',
      isVeg: true,
      isAvailable: true,
      imageUrl: 'https://images.unsplash.com/photo-1571934811356-5cc061b6821f?w=300&h=200&fit=crop',
      prepTime: 3,
    ),
    VendorMenuItem(
      id: '5',
      name: 'Gulab Jamun',
      description: 'Soft milk dumplings in sugar syrup',
      price: 25.0,
      category: 'Desserts',
      isVeg: true,
      isAvailable: true,
      imageUrl: 'https://images.unsplash.com/photo-1571115764595-644a1f56a55c?w=300&h=200&fit=crop',
      prepTime: 2,
    ),
  ];

  List<VendorMenuItem> get filteredItems {
    if (selectedCategory == 'All') return menuItems;
    return menuItems.where((item) => item.category == selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: MenuItemSearchDelegate(menuItems));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Category Filter
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = selectedCategory == category;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        selectedCategory = category;
                      });
                    },
                  ),
                );
              },
            ),
          ),

          // Menu Items List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredItems.length,
              itemBuilder: (context, index) {
                final item = filteredItems[index];
                return _buildMenuItemCard(item);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddItemDialog(),
        icon: const Icon(Icons.add),
        label: const Text('Add Item'),
      ),
    );
  }

  Widget _buildMenuItemCard(VendorMenuItem item) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image and Basic Info
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
                child: Image.network(
                  item.imageUrl,
                  width: 120,
                  height: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 120,
                      height: 100,
                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
                      child: const Icon(Icons.restaurant, size: 40),
                    );
                  },
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              item.name,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              if (item.isVeg)
                                Container(
                                  width: 16,
                                  height: 16,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.green, width: 2),
                                  ),
                                  child: Center(
                                    child: Container(
                                      width: 8,
                                      height: 8,
                                      decoration: const BoxDecoration(
                                        color: Colors.green,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                )
                              else
                                Container(
                                  width: 16,
                                  height: 16,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.red, width: 2),
                                  ),
                                  child: const Center(
                                    child: Icon(Icons.change_history, size: 8, color: Colors.red),
                                  ),
                                ),
                              const SizedBox(width: 8),
                              Switch(
                                value: item.isAvailable,
                                onChanged: (value) {
                                  setState(() {
                                    final index = menuItems.indexWhere((i) => i.id == item.id);
                                    menuItems[index] = menuItems[index].copyWith(isAvailable: value);
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.description,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            '₹${item.price.toStringAsFixed(0)}',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Icon(Icons.timer, size: 16, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6)),
                          const SizedBox(width: 4),
                          Text(
                            '${item.prepTime}min',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Status and Actions
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: item.isAvailable 
                        ? Colors.green.withValues(alpha: 0.2)
                        : Colors.red.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    item.isAvailable ? 'Available' : 'Out of Stock',
                    style: TextStyle(
                      color: item.isAvailable ? Colors.green[700] : Colors.red[700],
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
                Row(
                  children: [
                    OutlinedButton(
                      onPressed: () => _showEditItemDialog(item),
                      child: const Text('Edit'),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton(
                      onPressed: () => _deleteItem(item),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                      ),
                      child: const Text('Delete'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddItemDialog() {
    _showItemDialog(null);
  }

  void _showEditItemDialog(VendorMenuItem item) {
    _showItemDialog(item);
  }

  void _showItemDialog(VendorMenuItem? item) {
    final isEditing = item != null;
    final nameController = TextEditingController(text: item?.name ?? '');
    final descriptionController = TextEditingController(text: item?.description ?? '');
    final priceController = TextEditingController(text: item?.price.toString() ?? '');
    final prepTimeController = TextEditingController(text: item?.prepTime.toString() ?? '');
    final imageUrlController = TextEditingController(text: item?.imageUrl ?? '');
    
    String selectedCategory = item?.category ?? 'Main Course';
    bool isVeg = item?.isVeg ?? true;
    bool isAvailable = item?.isAvailable ?? true;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(isEditing ? 'Edit Menu Item' : 'Add Menu Item'),
          content: SizedBox(
            width: double.maxFinite,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Item Name',
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
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: priceController,
                          decoration: const InputDecoration(
                            labelText: 'Price (₹)',
                            border: OutlineInputBorder(),
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
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: selectedCategory,
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(),
                    ),
                    items: categories.where((cat) => cat != 'All').map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setDialogState(() {
                        selectedCategory = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: imageUrlController,
                    decoration: const InputDecoration(
                      labelText: 'Image URL',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Switch(
                              value: isVeg,
                              onChanged: (value) {
                                setDialogState(() {
                                  isVeg = value;
                                });
                              },
                            ),
                            const SizedBox(width: 8),
                            Text(isVeg ? 'Vegetarian' : 'Non-Vegetarian'),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            Switch(
                              value: isAvailable,
                              onChanged: (value) {
                                setDialogState(() {
                                  isAvailable = value;
                                });
                              },
                            ),
                            const SizedBox(width: 8),
                            const Text('Available'),
                          ],
                        ),
                      ),
                    ],
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
                final newItem = VendorMenuItem(
                  id: item?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                  name: nameController.text,
                  description: descriptionController.text,
                  price: double.tryParse(priceController.text) ?? 0.0,
                  category: selectedCategory,
                  isVeg: isVeg,
                  isAvailable: isAvailable,
                  imageUrl: imageUrlController.text.isEmpty 
                      ? 'https://via.placeholder.com/300x200?text=No+Image'
                      : imageUrlController.text,
                  prepTime: int.tryParse(prepTimeController.text) ?? 5,
                );

                setState(() {
                  if (isEditing) {
                    final index = menuItems.indexWhere((i) => i.id == item!.id);
                    menuItems[index] = newItem;
                  } else {
                    menuItems.add(newItem);
                  }
                });

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(isEditing 
                        ? 'Menu item updated successfully' 
                        : 'Menu item added successfully'),
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

  void _deleteItem(VendorMenuItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Menu Item'),
        content: Text('Are you sure you want to delete "${item.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              setState(() {
                menuItems.removeWhere((i) => i.id == item.id);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Menu item deleted successfully')),
              );
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class MenuItemSearchDelegate extends SearchDelegate<VendorMenuItem?> {
  final List<VendorMenuItem> menuItems;

  MenuItemSearchDelegate(this.menuItems);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    final results = menuItems
        .where((item) => 
            item.name.toLowerCase().contains(query.toLowerCase()) ||
            item.description.toLowerCase().contains(query.toLowerCase()) ||
            item.category.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final item = results[index];
        return ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              item.imageUrl,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 60,
                  height: 60,
                  color: Colors.grey[300],
                  child: const Icon(Icons.restaurant),
                );
              },
            ),
          ),
          title: Text(item.name),
          subtitle: Text('₹${item.price.toStringAsFixed(0)} • ${item.category}'),
          trailing: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: item.isAvailable 
                  ? Colors.green.withValues(alpha: 0.2)
                  : Colors.red.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              item.isAvailable ? 'Available' : 'Out of Stock',
              style: TextStyle(
                color: item.isAvailable ? Colors.green[700] : Colors.red[700],
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          onTap: () {
            close(context, item);
          },
        );
      },
    );
  }
}