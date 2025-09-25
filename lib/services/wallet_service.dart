import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:campus_feast/models/transaction.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WalletService {
  // final String baseUrl = 'http://10.0.2.2:3000/api/wallet';
  final String baseUrl = 'http://localhost:3000/api/wallet';

  // Get wallet balance
  Future<double> getWalletBalance() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      
      if (token == null) {
        throw Exception('Authentication token not found');
      }
      
      final response = await http.get(
        Uri.parse('$baseUrl/balance'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data']['balance'].toDouble();
      } else {
        throw Exception(jsonDecode(response.body)['message']);
      }
    } catch (e) {
      // For demo purposes, return a mock balance
      return 463.0;
    }
  }
  
  // Get transaction history
  Future<List<WalletTransaction>> getTransactionHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      
      if (token == null) {
        throw Exception('Authentication token not found');
      }
      
      final response = await http.get(
        Uri.parse('$baseUrl/transactions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> transactions = data['data'];
        
        return transactions.map((transaction) {
          return WalletTransaction(
            id: transaction['id'],
            userId: transaction['userId'],
            type: _parseTransactionType(transaction['type']),
            amount: transaction['amount'].toDouble(),
            description: transaction['description'],
            timestamp: DateTime.parse(transaction['timestamp']),
            orderId: transaction['orderId'],
          );
        }).toList();
      } else {
        throw Exception(jsonDecode(response.body)['message']);
      }
    } catch (e) {
      // For demo purposes, return sample transactions
      return sampleTransactions;
    }
  }
  
  // Initiate UPI payment
  Future<Map<String, dynamic>> initiateUpiPayment({
    required double amount,
    required String upiId,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      
      if (token == null) {
        throw Exception('Authentication token not found');
      }
      
      final response = await http.post(
        Uri.parse('$baseUrl/topup/upi'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'amount': amount,
          'upiId': upiId,
        }),
      );
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['data'];
      } else {
        throw Exception(jsonDecode(response.body)['message']);
      }
    } catch (e) {
      // For demo purposes, return a mock payment response
      return {
        'success': true,
        'transactionId': 'UPI${DateTime.now().millisecondsSinceEpoch}',
        'message': 'Payment initiated successfully',
      };
    }
  }
  
  // Initiate Net Banking payment
  Future<Map<String, dynamic>> initiateNetBankingPayment({
    required double amount,
    required String bankCode,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      
      if (token == null) {
        throw Exception('Authentication token not found');
      }
      
      final response = await http.post(
        Uri.parse('$baseUrl/topup/netbanking'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'amount': amount,
          'bankCode': bankCode,
        }),
      );
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['data'];
      } else {
        throw Exception(jsonDecode(response.body)['message']);
      }
    } catch (e) {
      // For demo purposes, return a mock payment response
      return {
        'success': true,
        'transactionId': 'NB${DateTime.now().millisecondsSinceEpoch}',
        'message': 'Payment initiated successfully',
        'redirectUrl': 'https://example.com/bank-payment',
      };
    }
  }
  
  // Helper method to parse transaction type
  TransactionType _parseTransactionType(String type) {
    switch (type.toLowerCase()) {
      case 'topup':
        return TransactionType.topup;
      case 'payment':
        return TransactionType.payment;
      case 'refund':
        return TransactionType.refund;
      default:
        return TransactionType.payment;
    }
  }
}