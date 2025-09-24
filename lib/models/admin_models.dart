// Admin-specific models for the Campus Feast admin panel

class PendingVendor {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String businessName;
  final String businessType;
  final String address;
  final String gstNumber;
  final String panNumber;
  final DateTime applicationDate;
  final VendorApplicationStatus status;
  final String? documents; // URL to uploaded documents
  final String? rejectionReason;

  PendingVendor({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.businessName,
    required this.businessType,
    required this.address,
    required this.gstNumber,
    required this.panNumber,
    required this.applicationDate,
    required this.status,
    this.documents,
    this.rejectionReason,
  });
}

enum VendorApplicationStatus {
  pending,
  underReview,
  approved,
  rejected,
  documentsRequired
}

class SystemReport {
  final String id;
  final String title;
  final ReportType type;
  final DateTime generatedDate;
  final Map<String, dynamic> data;
  final String generatedBy;

  SystemReport({
    required this.id,
    required this.title,
    required this.type,
    required this.generatedDate,
    required this.data,
    required this.generatedBy,
  });
}

enum ReportType {
  transactionSummary,
  vendorPerformance,
  settlementReport,
  walletActivity,
  systemUsage
}

class ComplaintTicket {
  final String id;
  final String userId;
  final String userName;
  final String userType;
  final String subject;
  final String description;
  final ComplaintCategory category;
  final ComplaintStatus status;
  final ComplaintPriority priority;
  final DateTime createdAt;
  final DateTime? resolvedAt;
  final String? assignedTo;
  final String? resolution;
  final List<ComplaintMessage> messages;

  ComplaintTicket({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userType,
    required this.subject,
    required this.description,
    required this.category,
    required this.status,
    required this.priority,
    required this.createdAt,
    this.resolvedAt,
    this.assignedTo,
    this.resolution,
    this.messages = const [],
  });
}

class ComplaintMessage {
  final String id;
  final String senderId;
  final String senderName;
  final String message;
  final DateTime timestamp;
  final bool isAdminMessage;

  ComplaintMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.message,
    required this.timestamp,
    required this.isAdminMessage,
  });
}

enum ComplaintCategory {
  payment,
  order,
  vendor,
  technical,
  account,
  refund,
  other
}

enum ComplaintStatus {
  open,
  inProgress,
  resolved,
  closed,
  escalated
}

enum ComplaintPriority {
  low,
  medium,
  high,
  urgent
}

class SystemAnalytics {
  final int totalUsers;
  final int totalVendors;
  final int totalOrders;
  final double totalRevenue;
  final double totalWalletBalance;
  final int todayOrders;
  final double todayRevenue;
  final Map<String, int> ordersByHour;
  final Map<String, double> revenueByDay;
  final Map<String, int> popularItems;
  final Map<String, int> vendorPerformance;
  final List<PeakHour> peakHours;
  final WalletAnalytics walletAnalytics;

  SystemAnalytics({
    required this.totalUsers,
    required this.totalVendors,
    required this.totalOrders,
    required this.totalRevenue,
    required this.totalWalletBalance,
    required this.todayOrders,
    required this.todayRevenue,
    required this.ordersByHour,
    required this.revenueByDay,
    required this.popularItems,
    required this.vendorPerformance,
    required this.peakHours,
    required this.walletAnalytics,
  });
}

class PeakHour {
  final String timeRange;
  final int orderCount;
  final double revenue;

  PeakHour({
    required this.timeRange,
    required this.orderCount,
    required this.revenue,
  });
}

class WalletAnalytics {
  final double totalTopUps;
  final double totalSpent;
  final double averageBalance;
  final int totalTransactions;
  final Map<String, double> topUpsByDay;
  final Map<String, double> spendingByCategory;

  WalletAnalytics({
    required this.totalTopUps,
    required this.totalSpent,
    required this.averageBalance,
    required this.totalTransactions,
    required this.topUpsByDay,
    required this.spendingByCategory,
  });
}

class SettlementReport {
  final String id;
  final String vendorId;
  final String vendorName;
  final DateTime startDate;
  final DateTime endDate;
  final double totalSales;
  final double platformCommission;
  final double settlementAmount;
  final SettlementStatus status;
  final DateTime? settlementDate;
  final String? transactionReference;

  SettlementReport({
    required this.id,
    required this.vendorId,
    required this.vendorName,
    required this.startDate,
    required this.endDate,
    required this.totalSales,
    required this.platformCommission,
    required this.settlementAmount,
    required this.status,
    this.settlementDate,
    this.transactionReference,
  });
}

enum SettlementStatus {
  pending,
  processed,
  failed,
  disputed
}