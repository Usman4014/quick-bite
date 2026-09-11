// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';


class OrderCancelDialog {
  static Future<bool> show() async {
    final result = await Get.dialog<bool>(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //------------------------------------------
              // Warning Icon
              //------------------------------------------

              Container(
                width: 85,
                height: 85,
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close_rounded,
                  size: 45,
                  color: Colors.red.shade400,
                ),
              ),

              const SizedBox(height: 20),

              //------------------------------------------
              // Title
              //------------------------------------------

              Text(
                "Cancel Order?",
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              //------------------------------------------
              // Message
              //------------------------------------------

              Text(
                "Are you sure you want to cancel this order?\nThis action cannot be undone.",
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 30),

              //------------------------------------------
              // Buttons
              //------------------------------------------

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Get.back(result: false);
                      },
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 52),
                        side: BorderSide(
                          color: Colors.grey.shade300,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      child: Text(
                        "Keep Order",
                        style: GoogleFonts.poppins(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back(result: true);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        elevation: 0,
                        minimumSize: const Size(double.infinity, 52),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      child: Text(
                        "Yes, Cancel",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    return result ?? false;
  }
}