// ignore_for_file: avoid_print, file_names

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class CloudinaryService {
  //============================================================
  // CLOUDINARY CONFIGURATION
  //============================================================

  static const String cloudName = 'lhcufsxw';

  static const String uploadPreset = 'quick_bite_images';

  //============================================================
  // UPLOAD IMAGE
  //============================================================

  Future<String?> uploadImage({
    required File imageFile,
    String folder = 'quick_bite',
  }) async {
    try {
      //==========================================================
      // CLOUDINARY UPLOAD URL
      //==========================================================

      final Uri uploadUrl = Uri.parse(
        'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
      );

      //==========================================================
      // CREATE MULTIPART REQUEST
      //==========================================================

      final http.MultipartRequest request =
          http.MultipartRequest(
        'POST',
        uploadUrl,
      );

      //==========================================================
      // UPLOAD PRESET
      //==========================================================

      request.fields['upload_preset'] = uploadPreset;

      //==========================================================
      // FOLDER
      //==========================================================

      request.fields['folder'] = folder;

      //==========================================================
      // IMAGE FILE
      //==========================================================

      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          imageFile.path,
        ),
      );

      //==========================================================
      // SEND REQUEST
      //==========================================================

      final http.StreamedResponse response =
          await request.send();

      //==========================================================
      // READ RESPONSE
      //==========================================================

      final String responseBody =
          await response.stream.bytesToString();

      //==========================================================
      // SUCCESS
      //==========================================================

      if (response.statusCode == 200) {
        final Map<String, dynamic> data =
            jsonDecode(responseBody);

        final String? secureUrl =
            data['secure_url'];

        print('Cloudinary upload successful.');
        print('Image URL: $secureUrl');

        return secureUrl;
      }

      //==========================================================
      // FAILED
      //==========================================================

      print(
        'Cloudinary upload failed.',
      );

      print(
        'Status Code: ${response.statusCode}',
      );

      print(
        'Response: $responseBody',
      );

      return null;
    } catch (e) {
      //==========================================================
      // EXCEPTION
      //==========================================================

      print(
        'Cloudinary upload error: $e',
      );

      return null;
    }
  }
}