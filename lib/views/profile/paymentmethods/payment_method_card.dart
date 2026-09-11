// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quick_bite/controllers/PaymentMethod_Controller.dart';
import 'package:quick_bite/models/PaymentMethod_Model.dart';
import 'package:quick_bite/routes/App_Routes.dart';
import 'package:quick_bite/theme/app_colors.dart';

class PaymentMethodCard extends StatelessWidget {
  final PaymentMethodModel paymentMethod;

  PaymentMethodCard({super.key, required this.paymentMethod});

  final PaymentMethodController paymentController =
      Get.find<PaymentMethodController>();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: (){
        paymentController.selectPaymentMethod(paymentMethod);
      },
      child: Container(
        decoration: BoxDecoration(
          color: paymentMethod.isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
              : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: paymentMethod.isSelected
                ? AppColors.primary
                : Colors.grey.shade300,
            width: paymentMethod.isSelected ? 2 : 1,
          ),
        ),
      
        child: Padding(
           padding: const EdgeInsets.only(left: 15, top: 0, bottom: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// TOP ROW
              Row(
                children: [
                  getCardLogo(),
          
                  const Spacer(),
          
                  if (paymentMethod.isDefault)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        "✓ Default",
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
          
                  PopupMenuButton<String>(
                     padding: EdgeInsets.zero,
                            color: Colors.white,
                            constraints: const BoxConstraints(),
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                     icon: const FaIcon(
                              FontAwesomeIcons.ellipsisVertical,
                              size: 18,
                              color: Colors.black,
                            ),
          
                    onSelected: (value) {
      
                       switch (value) {
                                case 'edit':
                                  Get.toNamed(
                                    AppRoutes.addcreditdebitcard,
                                    arguments: paymentMethod
                                  );
                                  break;
      
                                case 'default':
                                   paymentController.setDefaultPaymentMethod(paymentMethod);
                                  break;
      
                                case 'delete':
                                   paymentController.removeCard(paymentMethod);
                                  break;
                              }
                    
                    },
          
                 itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'edit',
                                child: Row(
                                  children: [
                                    FaIcon(
                                      FontAwesomeIcons.pen,
                                      size: 18,
                                      color: AppColors.primary,
                                    ),
                                    SizedBox(width: 12),
                                    Text('Edit'),
                                  ],
                                ),
                              ),
      
                              if (!paymentMethod.isDefault)
                                const PopupMenuItem(
                                  value: 'default',
                                  child: Row(
                                    children: [
                                      FaIcon(
                                        FontAwesomeIcons.solidCircleCheck,
                                        size: 18,
                                        color: AppColors.primary,
                                      ),
                                      SizedBox(width: 12),
                                      Text('Set as Default'),
                                    ],
                                  ),
                                ),
      
                              const PopupMenuItem(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    FaIcon(
                                      FontAwesomeIcons.trash,
                                      size: 18,
                                      color: AppColors.primary,
                                    ),
                                    SizedBox(width: 12),
                                    Text('Delete'),
                                  ],
                                ),
                              ),
                            ],
                  ),
                ],
              ),
          
              /// CARD NUMBER
              Text(
                maskedCardNumber,
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 2,
                ),
              ),
          
              const SizedBox(height: 18),
          
              /// CARD HOLDER
              Text(
                paymentMethod.cardHolderName ?? "",
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
          
              const SizedBox(height: 10),
          
              /// EXPIRY
              Row(
                children: [
                  Text(
                    "Expires ${paymentMethod.expiryDate}",
                    style: GoogleFonts.poppins(
                      color: Colors.grey.shade600,
                      fontSize: 13,
                    ),
                  ),
                  const Spacer(),
                   Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: FaIcon(
                            paymentMethod.isSelected
                                ? FontAwesomeIcons.solidCircleCheck
                                : FontAwesomeIcons.circleCheck,
                            color: paymentMethod.isSelected
                                ? AppColors.primary
                                : Colors.grey.shade400,
                            size: 17,
                          ),
                        ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getCardLogo() {
    switch (paymentMethod.title) {
      case "Visa":
        return Image.asset(
          "assets/Visa_MasterCard_Credit_Debit/visa.png",
          height: 80,
        );

      case "MasterCard":
        return Image.asset(
          "assets/Visa_MasterCard_Credit_Debit/mastercard.png",
          height: 80,
        );

      default:
        return Image.asset(
          'assets/Visa_MasterCard_Credit_Debit/credit_debit.png',
          height: 80,
        );
    }
  }

  String get maskedCardNumber {
    final number = paymentMethod.cardNumber!.replaceAll(" ", "");

    if (number.length < 4) {
      return number;
    }

    return "**** **** **** ${number.substring(number.length - 4)}";
  }
}
