class WalletTransaction {
  final String id;
  final String userId;
  final TransactionType type;
  final double amount;
  final String description;
  final DateTime timestamp;
  final String? orderId;

  WalletTransaction({
    required this.id,
    required this.userId,
    required this.type,
    required this.amount,
    required this.description,
    required this.timestamp,
    this.orderId,
  });
}

enum TransactionType { topup, payment, refund }

// Sample transactions
final List<WalletTransaction> sampleTransactions = [
  WalletTransaction(
    id: 'TXN001',
    userId: 'user1',
    type: TransactionType.topup,
    amount: 500.0,
    description: 'Wallet top-up via UPI',
    timestamp: DateTime.now().subtract(const Duration(days: 2)),
  ),
  WalletTransaction(
    id: 'TXN002',
    userId: 'user1',
    type: TransactionType.payment,
    amount: -37.0,
    description: 'Payment for Dosa - South Corner Stall',
    timestamp: DateTime.now().subtract(const Duration(hours: 2)),
    orderId: 'ORD002',
  ),
  WalletTransaction(
    id: 'TXN003',
    userId: 'user1',
    type: TransactionType.topup,
    amount: 300.0,
    description: 'Wallet top-up via Net Banking',
    timestamp: DateTime.now().subtract(const Duration(hours: 5)),
  ),
];