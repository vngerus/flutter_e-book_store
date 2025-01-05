import 'package:flutter/material.dart';
import 'payment_confirmation_screen.dart';
import '../models/ebook_models.dart';
import '../widgets/app_colors.dart';

class PaymentMethodScreen extends StatefulWidget {
  final List<EbookModel> purchasedBooks;
  final Function(List<EbookModel>) onPurchaseComplete;

  const PaymentMethodScreen({
    super.key,
    required this.purchasedBooks,
    required this.onPurchaseComplete,
  });

  @override
  _PaymentMethodScreenState createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  final double _walletBalance = 50000;
  bool _isDisposed = false;

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Select Payment Method",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColor.texto3,
          ),
        ),
        backgroundColor: AppColor.bg1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black54),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: AppColor.bg2,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Choose a payment method:",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColor.texto3,
              ),
            ),
            const SizedBox(height: 16),
            _buildPaymentOption(
              icon: Icons.credit_card,
              label: "Credit/Debit Card",
              context: context,
              method: "card",
            ),
            const SizedBox(height: 8),
            _buildPaymentOption(
              icon: Icons.account_balance_wallet,
              label: "Wallet (Balance: \$${_walletBalance.toStringAsFixed(0)})",
              context: context,
              method: "wallet",
            ),
            const SizedBox(height: 8),
            _buildPaymentOption(
              icon: Icons.paypal,
              label: "PayPal",
              context: context,
              method: "paypal",
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
    required String method,
  }) {
    return GestureDetector(
      onTap: () => _handlePaymentMethod(context, method),
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
              style: TextStyle(
                fontSize: 16,
                color: AppColor.texto2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handlePaymentMethod(BuildContext context, String method) {
    switch (method) {
      case "card":
        _simulatePayment(context, "Processing Card Payment...");
        break;
      case "wallet":
        _simulatePayment(context, "Processing Wallet Payment...");
        break;
      case "paypal":
        _simulatePayment(context, "Processing PayPal Payment...");
        break;
    }
  }

  void _simulatePayment(BuildContext context, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColor.texto3,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    Future.delayed(const Duration(seconds: 3), () {
      if (!_isDisposed) {
        Navigator.pop(context);
        _navigateToConfirmation(context);
      }
    });
  }

  void _navigateToConfirmation(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentConfirmationScreen(
          purchasedBooks: widget.purchasedBooks,
          onPurchaseComplete: widget.onPurchaseComplete,
        ),
      ),
    );
  }
}
