// ignore_for_file: file_names, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:quick_bite/controllers/PaymentMethod_Controller.dart';
import 'package:quick_bite/enums/Payment_Method.dart';
import 'package:quick_bite/models/PaymentMethod_Model.dart';
import 'package:quick_bite/theme/App_Constants.dart';
import 'package:quick_bite/theme/app_colors.dart';
import 'package:quick_bite/theme/app_texttheme.dart';
import 'package:quick_bite/widgets/back_button.dart';
import 'package:quick_bite/widgets/cvv_formatter.dart';
import 'package:quick_bite/widgets/expirydate_formatter.dart';
import 'package:quick_bite/widgets/snack_bar.dart';
import 'package:quick_bite/widgets/text_field.dart';
import 'package:quick_bite/widgets/creditcardnumber_formatter.dart';

class AddCreditDebitCardScreen extends StatefulWidget {
  const AddCreditDebitCardScreen({super.key});

  @override
  State<AddCreditDebitCardScreen> createState() =>
      _AddCreditDebitCardScreenState();
}

class _AddCreditDebitCardScreenState extends State<AddCreditDebitCardScreen> {
  final PaymentMethodController paymentController =
      Get.find<PaymentMethodController>();
  PaymentMethodModel? editingPaymetMethod;
  final _formKey = GlobalKey<FormState>();

  final cardHolderNameController = TextEditingController();
  final cardNumberController = TextEditingController();
  final expiryDateController = TextEditingController();
  final cvvController = TextEditingController();

  bool isDefault = false;

  @override
  void initState() {
    super.initState();
    editingPaymetMethod = Get.arguments as PaymentMethodModel?;
    if (editingPaymetMethod != null) {
      cardHolderNameController.text = editingPaymetMethod!.cardHolderName ?? '';
      cardNumberController.text = editingPaymetMethod!.cardNumber ?? '';
      expiryDateController.text = editingPaymetMethod!.expiryDate ?? '';
      cvvController.text = editingPaymetMethod!.cvv ?? '';
      isDefault = editingPaymetMethod!.isDefault;
    }
  }

  @override
  void dispose() {
    cardHolderNameController.dispose();
    cardNumberController.dispose();
    expiryDateController.dispose();
    cvvController.dispose();
    super.dispose();
  }

  String getCardTitle(String cardNumber) {
    if (cardNumber.startsWith('4')) {
      return "Visa";
    }

    if (cardNumber.startsWith('5')) {
      return "MasterCard";
    }

    return "Credit / Debit Card";
  }

  void saveCard() {
    if (cardHolderNameController.text.trim().isEmpty ||
        cardNumberController.text.trim().isEmpty ||
        expiryDateController.text.trim().isEmpty ||
        cvvController.text.trim().isEmpty) {
      Snack_Bar.show(
        title: "Missing Information",
        message: "Please fill in all fields.",
        icon: FontAwesomeIcons.circleExclamation,
      );
      return;
    }

    final card = PaymentMethodModel(
      id:
          editingPaymetMethod?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),

      paymentMethod: PaymentMethod.creditDebitCard,

      title: getCardTitle(cardNumberController.text),

      cardHolderName: cardHolderNameController.text.trim(),

      cardNumber: cardNumberController.text.trim(),

      expiryDate: expiryDateController.text.trim(),

      cvv: cvvController.text.trim(),

      isDefault: isDefault,

      isSelected: editingPaymetMethod?.isSelected ?? false,
    );

    if (editingPaymetMethod == null) {
      paymentController.addCard(card);
    } else {
      paymentController.updateCard(card);
    }
    Get.back();
    Snack_Bar.show(
      title: "Success",
      message: "Card added successfully.",
      icon: FontAwesomeIcons.circleCheck,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                AppBar(),
                const SizedBox(height: 30),
                CardHolderName_TextField(),
                const SizedBox(height: 20),
                CardNumber_TextField(),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(child: ExpiryDate_TextField()),
                    SizedBox(width: 15),
                    Expanded(child: CVV_TextField()),
                  ],
                ),

                SizedBox(height: 20),

                SwitchListTile(
                  value: isDefault,
                  activeThumbColor: AppColors.primary,
                  inactiveThumbColor: Colors.grey.shade500,
                  inactiveTrackColor: AppColors.background,
                  title: Text(
                    "Set as Default",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      isDefault = value;
                    });
                  },
                ),

                SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: SizedBox(
                    width: double.infinity,
                    height: AppConstants.buttonHeight,
                    child: ElevatedButton(
                      onPressed: () {
                        saveCard();
                      },
                      child: Text(
                        editingPaymetMethod == null
                            ? "Save Card"
                            : "Update Card",
                        style: AppTextTheme.titleText,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget AppBar() {
    return SafeArea(
      child: Row(
        children: [
          Back_Button(),
          SizedBox(width: 15),
          Text(
            editingPaymetMethod == null
                ? 'Add Credit/Debit Card'
                : 'Update Credit/Debit Card',
            style: AppTextTheme.appbarText,
          ),
        ],
      ),
    );
  }

  Widget CardHolderName_TextField() {
    return Column(
      children: [
        Row(
          children: [
            Text(
              textAlign: TextAlign.start,
              'Card Holder Name',

              style: AppTextTheme.textfieldtitleText,
            ),
          ],
        ),
        SizedBox(height: 5),
        Text_Field(
          controller: cardHolderNameController,
          hintText: 'Enter card holder name',

          prefixIcon: FontAwesomeIcons.user,
        ),
      ],
    );
  }

  Widget CardNumber_TextField() {
    return Column(
      children: [
        Row(
          children: [
            Text(
              textAlign: TextAlign.start,
              'Card Number',

              style: AppTextTheme.textfieldtitleText,
            ),
          ],
        ),
        SizedBox(height: 5),
        TextFormField(
          keyboardType: TextInputType.phone,

          controller: cardNumberController,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            CardNumberFormatter(),
          ],
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(100),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFEEEEEE)),
              borderRadius: BorderRadius.circular(100),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.primary, width: 2),
              borderRadius: BorderRadius.circular(100),
            ),
            hintText: '1234 5678 9012 3456',
            prefixStyle: AppTextTheme.titleText,
            filled: true,
            fillColor: Colors.white,
            hintStyle: AppTextTheme.caption,
            prefixIcon: Center(
              widthFactor: 1,
              heightFactor: 1,
              child: FaIcon(
                FontAwesomeIcons.creditCard,
                color: AppColors.primary,
                size: AppConstants.textfieldiconSize,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget ExpiryDate_TextField() {
    return Column(
      children: [
        Row(
          children: [
            Text(
              textAlign: TextAlign.start,
              'Expiry Date',

              style: AppTextTheme.textfieldtitleText,
            ),
          ],
        ),
        SizedBox(height: 5),
        TextFormField(
          keyboardType: TextInputType.phone,

          controller: expiryDateController,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            ExpiryDateFormatter(),
          ],
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(100),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFEEEEEE)),
              borderRadius: BorderRadius.circular(100),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.primary, width: 2),
              borderRadius: BorderRadius.circular(100),
            ),
            hintText: 'MM/YY',
            prefixStyle: AppTextTheme.titleText,
            filled: true,
            fillColor: Colors.white,
            hintStyle: AppTextTheme.caption,
            prefixIcon: Center(
              widthFactor: 1,
              heightFactor: 1,
              child: FaIcon(
                FontAwesomeIcons.calendarDays,
                color: AppColors.primary,
                size: AppConstants.textfieldiconSize,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget CVV_TextField() {
    return Column(
      children: [
        Row(
          children: [
            Text(
              textAlign: TextAlign.start,
              'CVV',

              style: AppTextTheme.textfieldtitleText,
            ),
          ],
        ),
        SizedBox(height: 5),
        TextFormField(
          keyboardType: TextInputType.phone,

          controller: cvvController,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            CVVFormatter(),
          ],
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(100),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFEEEEEE)),
              borderRadius: BorderRadius.circular(100),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.primary, width: 2),
              borderRadius: BorderRadius.circular(100),
            ),
            hintText: 'CVV',
            prefixStyle: AppTextTheme.titleText,
            filled: true,
            fillColor: Colors.white,
            hintStyle: AppTextTheme.caption,
            prefixIcon: Center(
              widthFactor: 1,
              heightFactor: 1,
              child: FaIcon(
                FontAwesomeIcons.lock,
                color: AppColors.primary,
                size: AppConstants.textfieldiconSize,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
