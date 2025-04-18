import 'package:flutter/material.dart';
import 'package:flutter_ebook_store/widgets/app_colors.dart';

class AppPrimaryButton extends StatelessWidget {
  final Function()? onTap;
  final String text;
  final double? height;
  final double? fontSize;

  const AppPrimaryButton({
    super.key,
    required this.onTap,
    required this.text,
    this.height = 50,
    this.fontSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: height,
        decoration: BoxDecoration(
          color: AppColor.bg3,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: AppColor.aquagreen,
              fontSize: fontSize,
            ),
          ),
        ),
      ),
    );
  }
}
