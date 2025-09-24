import 'package:flutter/material.dart';
import 'package:campus_feast/models/vendor.dart';
import 'package:campus_feast/models/menu_item.dart';
import 'package:campus_feast/widgets/menu_item_card.dart';
import 'package:campus_feast/screens/cart/cart_screen.dart';

class VendorMenuScreen extends StatefulWidget {
  final Vendor vendor;

  const VendorMenuScreen({super.key, required this.vendor});

  @override
  State<VendorMenuScreen> createState() => _VendorMenuScreenState();
}

class _VendorMenuScreenState extends State<VendorMenuScreen> {
  ItemCategory? selectedCategory;
  final Map<String, int> cart = {};

  List<MenuItem> get vendorItems {
    return sampleMenuItems
        .where((item) => item.vendorId == widget.vendor.id)
        .toList();
  }

  List<MenuItem> get filteredItems {
    if (selectedCategory == null) return vendorItems;
    return vendorItems.where((item) => item.category == selectedCategory).toList();
  }

  List<ItemCategory> get availableCategories {
    return vendorItems.map((item) => item.category).toSet().toList();
  }

  void _addToCart(MenuItem item) {
    setState(() {
      cart[item.id] = (cart[item.id] ?? 0) + 1;
    });
  }

  void _removeFromCart(MenuItem item) {
    setState(() {
      if (cart[item.id] != null && cart[item.id]! > 0) {
        cart[item.id] = cart[item.id]! - 1;
        if (cart[item.id] == 0) {
          cart.remove(item.id);
        }
      }
    });
  }

  double get cartTotal {
    double total = 0;
    for (String itemId in cart.keys) {
      final item = vendorItems.firstWhere((item) => item.id == itemId);
      total += item.finalPrice * cart[itemId]!;
    }
    return total;
  }

  int get cartItemCount {
    return cart.values.fold(0, (sum, quantity) => sum + quantity);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.vendor.name),
        actions: [
          if (cart.isNotEmpty)
            Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => CartScreen(
                          vendor: widget.vendor,
                          cartItems: cart,
                          menuItems: vendorItems,
                        ),
                      ),
                    );
                  },
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.error,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      cartItemCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
      body: Column(
        children: [
          // Vendor Info Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: widget.vendor.isOpen ? Colors.green : Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        widget.vendor.isOpen ? 'Open' : 'Closed',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Icon(Icons.star, color: Colors.amber, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      '${widget.vendor.rating} (${widget.vendor.reviewCount} reviews)',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  widget.vendor.description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 16,
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      widget.vendor.openingHours,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Category Filter
          if (availableCategories.length > 1)
            SizedBox(
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                children: [
                  FilterChip(
                    label: const Text('All'),
                    selected: selectedCategory == null,
                    onSelected: (selected) {
                      setState(() => selectedCategory = null);
                    },
                  ),
                  const SizedBox(width: 8),
                  ...availableCategories.map((category) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(_getCategoryLabel(category)),
                      selected: selectedCategory == category,
                      onSelected: (selected) {
                        setState(() => selectedCategory = selected ? category : null);
                      },
                    ),
                  )),
                ],
              ),
            ),

          // Menu Items
          Expanded(
            child: filteredItems.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.restaurant_menu,
                          size: 64,
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No items available',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = filteredItems[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: MenuItemCard(
                          item: item,
                          quantity: cart[item.id] ?? 0,
                          onAdd: () => _addToCart(item),
                          onRemove: () => _removeFromCart(item),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: cart.isNotEmpty
          ? Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$cartItemCount items',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                            ),
                          ),
                          Text(
                            '₹${cartTotal.toStringAsFixed(2)}',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    FilledButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => CartScreen(
                              vendor: widget.vendor,
                              cartItems: cart,
                              menuItems: vendorItems,
                            ),
                          ),
                        );
                      },
                      child: const Text('View Cart'),
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }

  String _getCategoryLabel(ItemCategory category) {
    switch (category) {
      case ItemCategory.beverages:
        return 'Beverages';
      case ItemCategory.snacks:
        return 'Snacks';
      case ItemCategory.meals:
        return 'Meals';
      case ItemCategory.desserts:
        return 'Desserts';
      case ItemCategory.fastFood:
        return 'Fast Food';
    }
  }
}