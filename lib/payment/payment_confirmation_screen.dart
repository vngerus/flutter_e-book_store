import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ebook_store/bloc/cart_bloc.dart';
import 'package:flutter_ebook_store/bloc/cart_event.dart';
import 'package:flutter_ebook_store/screen/reading_screen.dart';
import '../models/ebook_models.dart';
import '../widgets/app_colors.dart';

class PaymentConfirmationScreen extends StatelessWidget {
  final List<EbookModel> purchasedBooks;

  const PaymentConfirmationScreen({
    super.key,
    required this.purchasedBooks,
    required Function(List<EbookModel> p1) onPurchaseComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Payment Confirmation"),
        backgroundColor: AppColor.bg1,
      ),
      backgroundColor: AppColor.bg2,
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: AppColor.bg1,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColor.bg2, width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle, color: AppColor.bg2, size: 100),
              const SizedBox(height: 16),
              const Text(
                "Payment Successful!",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  context
                      .read<CartBloc>()
                      .add(CompletePurchase(purchasedBooks));

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReadingScreen(
                        purchasedBooks: purchasedBooks,
                        onBackToExplore: () {
                          Navigator.popUntil(context, (route) => route.isFirst);
                        },
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.bg2,
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 24,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  "Go to My Books",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColor.texto2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
