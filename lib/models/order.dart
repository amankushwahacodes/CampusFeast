class Order {
  final String id;
  final String userId;
  final String vendorId;
  final List<OrderItem> items;
  final double subtotal;
  final double discount;
  final double total;
  final OrderStatus status;
  final DateTime orderTime;
  final DateTime? pickupTime;
  final PaymentMethod paymentMethod;

  Order({
    required this.id,
    required this.userId,
    required this.vendorId,
    required this.items,
    required this.subtotal,
    required this.discount,
    required this.total,
    required this.status,
    required this.orderTime,
    this.pickupTime,
    this.paymentMethod = PaymentMethod.wallet,
  });
}

class OrderItem {
  final String menuItemId;
  final String name;
  final double price;
  final double? discount;
  final int quantity;

  OrderItem({
    required this.menuItemId,
    required this.name,
    required this.price,
    this.discount,
    this.quantity = 1,
  });

  double get totalPrice => (price - (discount ?? 0)) * quantity;
}

enum OrderStatus {
  placed,
  accepted,
  preparing,
  ready,
  completed,
  rejected,
  cancelled
}

enum PaymentMethod { wallet, upi, cash }

// Sample orders
final List<Order> sampleOrders = [
  Order(
    id: 'ORD001',
    userId: 'user1',
    vendorId: '1',
    items: [
      OrderItem(menuItemId: '1', name: 'Masala Tea', price: 10.0, discount: 1.0, quantity: 2),
      OrderItem(menuItemId: '2', name: 'Aloo Samosa', price: 20.0, discount: 2.0, quantity: 1),
    ],
    subtotal: 40.0,
    discount: 4.0,
    total: 36.0,
    status: OrderStatus.ready,
    orderTime: DateTime.now().subtract(const Duration(minutes: 15)),
    pickupTime: DateTime.now().add(const Duration(minutes: 5)),
  ),
  Order(
    id: 'ORD002',
    userId: 'user1',
    vendorId: '2',
    items: [
      OrderItem(menuItemId: '4', name: 'Plain Dosa', price: 40.0, discount: 3.0, quantity: 1),
    ],
    subtotal: 40.0,
    discount: 3.0,
    total: 37.0,
    status: OrderStatus.completed,
    orderTime: DateTime.now().subtract(const Duration(hours: 2)),
  ),
];