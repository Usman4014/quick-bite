// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Back_Button extends StatelessWidget {
  const Back_Button({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,width:45,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade300)
      ),
      child: IconButton(
        onPressed: Get.back,
        icon:  Icon(
          Icons.arrow_back,
          color: Colors.black,
        ),
      ),
    );
  }
}