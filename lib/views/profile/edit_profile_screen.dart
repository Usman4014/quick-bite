// ignore_for_file: non_constant_identifier_names, file_names

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:quick_bite/controllers/Auth_Controller.dart';
import 'package:quick_bite/controllers/User_Controller.dart';
import 'package:quick_bite/routes/App_Routes.dart';
import 'package:quick_bite/shimmers/profile_image_shimmer.dart';
import 'package:quick_bite/theme/app_colors.dart';
import 'package:quick_bite/theme/app_constants.dart';
import 'package:quick_bite/theme/app_texttheme.dart';
import 'package:quick_bite/widgets/back_button.dart';
import 'package:quick_bite/widgets/snack_bar.dart';
import 'package:quick_bite/widgets/text_field.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final AuthController authController = Get.find<AuthController>();
  final UserController userController = Get.find<UserController>();
  TextEditingController fullnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();

  bool isUploadingImage = false;

  @override
  void initState() {
    super.initState();

    final user = userController.currentUser.value!;

    fullnameController = TextEditingController(text: user.name);
    emailController = TextEditingController(text: user.email);
    phoneController = TextEditingController(text: user.phoneNumber);
  }

  Future<void> _pickAndUploadProfileImage() async {
    try {
      //==========================================================
      // PICK IMAGE
      //==========================================================

      final XFile? pickedImage = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (pickedImage == null) {
        return;
      }

      //==========================================================
      // CONVERT TO FILE
      //==========================================================

      final File imageFile = File(pickedImage.path);

      setState(() {
        isUploadingImage = true;
      });

      //==========================================================
      // UPLOAD TO CLOUDINARY
      //==========================================================

      await userController.uploadProfileImage(imageFile);

      if (!mounted) return;

      setState(() {
        isUploadingImage = false;
      });

      //==========================================================
      // SUCCESS
      //==========================================================

      Snack_Bar.show(
        title: 'Profile Image Updated',
        message: 'Your profile picture has been updated successfully.',
        icon: FontAwesomeIcons.solidCircleCheck,
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isUploadingImage = false;
      });

      Snack_Bar.show(
        title: 'Upload Failed',
        message: e.toString().replaceFirst('Exception: ', ''),
        icon: FontAwesomeIcons.circleExclamation,
      );
    }
  }

  @override
  void dispose() {
    fullnameController.dispose();
    emailController.dispose();
    phoneController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String? profileImage = userController.currentUser.value?.profileImage;
    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: Save_Changes_Button(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Column(
              children: [
                SizedBox(height: 20),
                AppBar(),

                const SizedBox(height: 20),

                Stack(
                  children: [
                    profileImage != null && profileImage.trim().isNotEmpty
                        ? ClipOval(
                            child: Image.network(
                              profileImage,
                              width: 110,
                              height: 110,
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child;
                                    }

                                    return const ProfileImageShimmer();
                                  },
                              errorBuilder: (context, error, stackTrace) {
                                return CircleAvatar(
                                  radius: 55,
                                  backgroundColor: AppColors.primary.withValues(
                                    alpha: 0.1,
                                  ),
                                  child: const FaIcon(
                                    FontAwesomeIcons.user,
                                    color: AppColors.primary,
                                    size: 40,
                                  ),
                                );
                              },
                            ),
                          )
                        : CircleAvatar(
                            radius: 55,
                            backgroundColor: AppColors.primary.withValues(
                              alpha: 0.1,
                            ),
                            child: const FaIcon(
                              FontAwesomeIcons.user,
                              color: AppColors.primary,
                              size: 40,
                            ),
                          ),

                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: GestureDetector(
                        onTap: isUploadingImage
                            ? null
                            : _pickAndUploadProfileImage,
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: isUploadingImage
                              ? Colors.white
                              : AppColors.primary,
                          child: isUploadingImage
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: Center(
                                    child: SpinKitThreeBounce(
                                      color: AppColors.primary,
                                      size: 10,
                                    ),
                                  ),
                                )
                              : const Icon(
                                  Icons.camera_alt,
                                  size: 18,
                                  color: Colors.black,
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                FullName_TextField(),
                SizedBox(height: 20),
                Email_TextField(),
                SizedBox(height: 20),
                Phone_TextField(),
                const SizedBox(height: 25),

                ChangePassword_Button(),
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
          const SizedBox(width: 15),
          Text("Edit Profile", style: AppTextTheme.appbarText),
        ],
      ),
    );
  }

  Widget FullName_TextField() {
    return Column(
      children: [
        Row(
          children: [
            Text(
              textAlign: TextAlign.start,
              'Full Name',
              style: AppTextTheme.textfieldtitleText,
            ),
          ],
        ),
        SizedBox(height: 5),
        Text_Field(
          controller: fullnameController,
          hintText: 'Enter your full name',
          prefixIcon: FontAwesomeIcons.solidUser,
        ),
      ],
    );
  }

  Widget Email_TextField() {
    return Column(
      children: [
        Row(
          children: [
            Text(
              textAlign: TextAlign.start,
              'Email Address',
              style: AppTextTheme.textfieldtitleText,
            ),
          ],
        ),
        SizedBox(height: 5),
        Text_Field(
          controller: emailController,
          hintText: 'Enter your email',
          prefixIcon: FontAwesomeIcons.solidEnvelope,
        ),
      ],
    );
  }

  Widget Phone_TextField() {
    return Column(
      children: [
        Row(
          children: [
            Text(
              textAlign: TextAlign.start,
              'Phone Number',
              style: AppTextTheme.textfieldtitleText,
            ),
          ],
        ),
        SizedBox(height: 5),
        Text_Field(
          // USA ONLY
          prefixText: '+1 ',
          controller: phoneController,
          hintText: 'Enter your phone number',
          prefixIcon: FontAwesomeIcons.phone,
        ),
      ],
    );
  }

  Widget ChangePassword_Button() {
    return GestureDetector(
      onTap: () {
        Get.toNamed(AppRoutes.changepassword);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            //==========================================================
            // ICON
            //==========================================================
            Container(
              height: 45,
              width: 45,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: FaIcon(
                  FontAwesomeIcons.lock,
                  size: 18,
                  color: AppColors.primary,
                ),
              ),
            ),

            const SizedBox(width: 15),

            //==========================================================
            // TEXT
            //==========================================================
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Change Password',
                    style: AppTextTheme.textfieldtitleText,
                  ),

                  const SizedBox(height: 4),

                  Text(
                    'Update your account password',
                    style: AppTextTheme.caption,
                  ),
                ],
              ),
            ),

            //==========================================================
            // ARROW
            //==========================================================
            const FaIcon(
              FontAwesomeIcons.chevronRight,
              size: 14,
              color: Colors.black54,
            ),
          ],
        ),
      ),
    );
  }

  Widget Save_Changes_Button() {
    return Obx(
      () => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
          child: SizedBox(
            height: AppConstants.buttonHeight,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: userController.isSaveChangesLoading.value
                  ? null
                  : () {
                      userController.saveProfileChanges(
                        name: fullnameController.text,
                        email: emailController.text,
                        phoneNumber: phoneController.text,
                      );
                    },
              style: ElevatedButton.styleFrom(
                disabledBackgroundColor: Colors.white,

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
              child: userController.isSaveChangesLoading.value
                  ? const SizedBox(
                      width: 60,
                      height: 24,
                      child: Center(
                        child: SpinKitThreeBounce(
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ),
                    )
                  : Text("Save Changes", style: AppTextTheme.titleText),
            ),
          ),
        ),
      ),
    );
  }
}
