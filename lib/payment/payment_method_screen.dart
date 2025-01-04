import 'package:flutter/material.dart';
import 'payment_confirmation_screen.dart';
import '../models/ebook_models.dart';

class PaymentMethodScreen extends StatelessWidget {
  final List<EbookModel> purchasedBooks;
  final Function(List<EbookModel>) onPurchaseComplete;

  const PaymentMethodScreen({
    super.key,
    required this.purchasedBooks,
    required this.onPurchaseComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Select Payment Method"),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Choose a payment method:",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.credit_card, color: Colors.teal),
              title: const Text("Credit/Debit Card"),
              onTap: () {
                _navigateToConfirmation(context);
              },
            ),
            ListTile(
              leading:
                  const Icon(Icons.account_balance_wallet, color: Colors.teal),
              title: const Text("Wallet"),
              onTap: () {
                _navigateToConfirmation(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.paypal, color: Colors.teal),
              title: const Text("PayPal"),
              onTap: () {
                _navigateToConfirmation(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToConfirmation(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentConfirmationScreen(
          purchasedBooks: purchasedBooks,
          onPurchaseComplete: onPurchaseComplete,
        ),
      ),
    );
  }
}
