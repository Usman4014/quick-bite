import 'package:flutter/material.dart';
import 'package:quick_bite/theme/app_texttheme.dart';

class PaymentOptionTile extends StatelessWidget {
  final Widget leading;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const PaymentOptionTile({
    super.key,
    required this.leading,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 18),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: Colors.grey.shade300,
          ),
        ),
        child: Row(
          children: [
            leading,

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextTheme.titleText,
                  ),

                  const SizedBox(height: 4),

                  Text(
                    subtitle,
                    style: AppTextTheme.titleText
                  ),
                ],
              ),
            ),

            const Icon(Icons.arrow_forward_ios_rounded,size:18),
          ],
        ),
      ),
    );
  }
}