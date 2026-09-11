
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quick_bite/theme/app_colors.dart';

class SocialButton extends StatelessWidget {
  final FaIconData icon;

  const SocialButton({
    super.key,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      width: 55,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Center(
        child: FaIcon(
          icon,
          color: AppColors.primary,
          size: 20,
        ),
      ),
    );
  }
}