import 'package:flutter/material.dart';
import 'package:campus_feast/models/vendor.dart';
import 'package:campus_feast/models/menu_item.dart';
import 'package:campus_feast/screens/orders/order_success_screen.dart';

class CartScreen extends StatefulWidget {
  final Vendor vendor;
  final Map<String, int> cartItems;
  final List<MenuItem> menuItems;

  const CartScreen({
    super.key,
    required this.vendor,
    required this.cartItems,
    required this.menuItems,
  });

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late Map<String, int> cart;
  bool isProcessingOrder = false;
  final double walletBalance = 463.0; // Sample wallet balance

  @override
  void initState() {
    super.initState();
    cart = Map.from(widget.cartItems);
  }

  List<MenuItem> get cartMenuItems {
    return cart.keys
        .map((itemId) => widget.menuItems.firstWhere((item) => item.id == itemId))
        .toList();
  }

  double get subtotal {
    double total = 0;
    for (String itemId in cart.keys) {
      final item = widget.menuItems.firstWhere((item) => item.id == itemId);
      total += item.price * cart[itemId]!;
    }
    return total;
  }

  double get totalDiscount {
    double discount = 0;
    for (String itemId in cart.keys) {
      final item = widget.menuItems.firstWhere((item) => item.id == itemId);
      if (item.walletDiscount != null) {
        discount += item.walletDiscount! * cart[itemId]!;
      }
    }
    return discount;
  }

  double get finalTotal => subtotal - totalDiscount;

  int get totalItems => cart.values.fold(0, (sum, quantity) => sum + quantity);

  void _updateQuantity(String itemId, int newQuantity) {
    setState(() {
      if (newQuantity <= 0) {
        cart.remove(itemId);
      } else {
        cart[itemId] = newQuantity;
      }
    });
  }

  void _placeOrder() async {
    if (finalTotal > walletBalance) {
      _showInsufficientBalanceDialog();
      return;
    }

    setState(() => isProcessingOrder = true);

    // Simulate order processing
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => OrderSuccessScreen(
            vendor: widget.vendor,
            orderTotal: finalTotal,
            estimatedTime: 15,
          ),
        ),
      );
    }
  }

  void _showInsufficientBalanceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Insufficient Balance'),
        content: Text(
          'Your wallet balance is ₹${walletBalance.toStringAsFixed(2)} but the order total is ₹${finalTotal.toStringAsFixed(2)}.\n\nPlease top up your wallet to continue.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate to wallet top-up
            },
            child: const Text('Top Up Wallet'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (cart.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Your Cart')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.shopping_cart_outlined,
                size: 64,
                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
              ),
              const SizedBox(height: 16),
              Text(
                'Your cart is empty',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Add some delicious items to get started!',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Continue Shopping'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.vendor.name} - Cart'),
      ),
      body: Column(
        children: [
          // Wallet Balance Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.account_balance_wallet,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
                const SizedBox(width: 12),
                Text(
                  'Wallet Balance: ₹${walletBalance.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // Cart Items
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: cartMenuItems.length,
              itemBuilder: (context, index) {
                final item = cartMenuItems[index];
                final quantity = cart[item.id]!;
                
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        // Item Image
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Theme.of(context).colorScheme.surfaceContainerHighest,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              item.image,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.fastfood,
                                  size: 24,
                                  color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
                                );
                              },
                            ),
                          ),
                        ),
                        
                        const SizedBox(width: 16),
                        
                        // Item Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name,
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  if (item.walletDiscount != null && item.walletDiscount! > 0) ...[
                                    Text(
                                      '₹${item.price.toStringAsFixed(0)}',
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        decoration: TextDecoration.lineThrough,
                                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '₹${item.finalPrice.toStringAsFixed(0)}',
                                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).colorScheme.primary,
                                      ),
                                    ),
                                  ] else
                                    Text(
                                      '₹${item.price.toStringAsFixed(0)}',
                                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).colorScheme.primary,
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        
                        // Quantity Controls
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Theme.of(context).colorScheme.outline),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () => _updateQuantity(item.id, quantity - 1),
                                icon: const Icon(Icons.remove),
                                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                                padding: EdgeInsets.zero,
                              ),
                              Container(
                                constraints: const BoxConstraints(minWidth: 32),
                                child: Text(
                                  quantity.toString(),
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              IconButton(
                                onPressed: () => _updateQuantity(item.id, quantity + 1),
                                icon: const Icon(Icons.add),
                                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                                padding: EdgeInsets.zero,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Bill Summary
          Container(
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Bill Summary',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Subtotal ($totalItems items)'),
                    Text('₹${subtotal.toStringAsFixed(2)}'),
                  ],
                ),
                
                if (totalDiscount > 0) ...[
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Wallet Discount',
                        style: TextStyle(color: Theme.of(context).colorScheme.secondary),
                      ),
                      Text(
                        '- ₹${totalDiscount.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
                
                const Divider(),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Amount',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '₹${finalTotal.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                FilledButton(
                  onPressed: isProcessingOrder ? null : _placeOrder,
                  child: isProcessingOrder
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Place Order with Wallet'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}