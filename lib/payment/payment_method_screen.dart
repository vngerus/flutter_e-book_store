import 'package:flutter/material.dart';
import 'payment_confirmation_screen.dart';
import '../models/ebook_models.dart';
import '../widgets/app_colors.dart';

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
        backgroundColor: AppColor.bg1,
      ),
      backgroundColor: AppColor.bg2,
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
            _buildPaymentOption(
              icon: Icons.credit_card,
              label: "Credit/Debit Card",
              context: context,
            ),
            const SizedBox(height: 8),
            _buildPaymentOption(
              icon: Icons.account_balance_wallet,
              label: "Wallet",
              context: context,
            ),
            const SizedBox(height: 8),
            _buildPaymentOption(
              icon: Icons.paypal,
              label: "PayPal",
              context: context,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOption({
    required IconData icon,
    required String label,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: () {
        _navigateToConfirmation(context);
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.bg2,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColor.bg1,
            width: 2,
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          children: [
            Icon(icon, color: AppColor.bg1),
            const SizedBox(width: 16),
            Text(
              label,
              style: const TextStyle(fontSize: 16),
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
