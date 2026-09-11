// ignore_for_file: non_constant_identifier_names, file_names

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quick_bite/theme/app_texttheme.dart';

class CheckoutNoteCard extends StatelessWidget {
  CheckoutNoteCard({super.key});

  final TextEditingController noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Order Note", style: AppTextTheme.textfieldtitleText),
        SizedBox(height: 5),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: noteController,
              maxLength: 250,
              maxLines: 4,
              minLines: 4,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText:
                    "Add delivery instructions...\n\nExample:\n• No onions\n• Ring the doorbell\n• Extra ketchup",
                hintStyle: GoogleFonts.poppins(
                  color: Colors.grey.shade500,
                  fontSize: 14,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.all(16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                    color: Colors.grey.shade300
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(color: Colors.grey.shade300)
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                    color: Colors.orange,
                    width: 1.2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
