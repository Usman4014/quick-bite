// ignore_for_file: non_constant_identifier_names, file_names

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:geocoding/geocoding.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quick_bite/shimmers/location_picker_shimmer.dart';
import 'package:quick_bite/controllers/Address_Controller.dart';
import 'package:quick_bite/models/Address_Model.dart';
import 'package:quick_bite/models/AddressNeighborhood_Model.dart';
import 'package:quick_bite/models/AddressTypeVariant_Model.dart';
import 'package:quick_bite/theme/App_Constants.dart';
import 'package:quick_bite/theme/app_colors.dart';
import 'package:quick_bite/theme/app_texttheme.dart';
import 'package:shimmer/shimmer.dart';
import 'package:quick_bite/controllers/fixed_asset_controller.dart';
import 'package:quick_bite/views/profile/myaddresses/SelectLocationScreen.dart';
import 'package:quick_bite/widgets/back_button.dart';
import 'package:quick_bite/widgets/snack_bar.dart';
import 'package:quick_bite/widgets/text_field.dart';
import 'package:quick_bite/widgets/phonenumber_formatter.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  //============================================================
// FIXED ASSET CONTROLLER
//============================================================

final FixedAssetController fixedAssetController =
    Get.find<FixedAssetController>();

//============================================================
// DELIVERY LOCATION IMAGE STATE
//============================================================

String? _deliveryLocationLoadingUrl;
bool _deliveryLocationImageLoaded = false;
  //============================================================
  // CONTROLLER
  //============================================================

  final AddressController addressController = Get.find<AddressController>();

  //============================================================
  // EDITING ADDRESS
  //============================================================

  AddressModel? editingAddress;

  //============================================================
  // FORM CONTROLLERS
  //============================================================

  final TextEditingController phoneNumberController = TextEditingController();

  final TextEditingController streetAddressController = TextEditingController();

  final TextEditingController apartmentController = TextEditingController();

  final TextEditingController deliveryInstructionsController =
      TextEditingController();

  //============================================================
  // FORM STATE
  //============================================================

  AddressTypeVariantModel? selectedAddressType;

  AddressNeighborhoodModel? selectedNeighborhood;

  LatLng? selectedLocation;

  bool isDefault = false;

  bool isLoadingAddress = false;

  bool isSaving = false;

  //============================================================
  // GEOCODING
  //============================================================

  final Geocoding _geocoding = Geocoding();

  //============================================================
  // RESTAURANT LOCATION
  //============================================================

  static const LatLng _restaurantLocation = LatLng(34.0537218, -118.2497225);

  static const double _deliveryRadiusMeters = 10000;

  //============================================================
  // INIT
  //============================================================

  @override
  void initState() {
    super.initState();

    editingAddress = Get.arguments is AddressModel
        ? Get.arguments as AddressModel
        : null;

    _initializeForm();
  }

  //============================================================
  // INITIALIZE FORM
  //============================================================

  void _initializeForm() {
    final address = editingAddress;

    if (address == null) {
      return;
    }

    selectedAddressType = address.addressType;

    phoneNumberController.text = address.phoneNumber;

    streetAddressController.text = address.streetAddress;

    apartmentController.text = address.apartment ?? '';

    deliveryInstructionsController.text = address.deliveryInstructions ?? '';

    isDefault = address.isDefault;

    selectedLocation = LatLng(address.latitude, address.longitude);

    // Match the Firestore-loaded neighborhood
    // after metadata becomes available.
    _selectExistingNeighborhood(address.neighborhood);
  }

  //============================================================
  // MATCH EXISTING NEIGHBORHOOD
  //============================================================

  void _selectExistingNeighborhood(String title) {
    final match = addressController.neighborhoods
        .cast<AddressNeighborhoodModel?>()
        .firstWhere(
          (item) => item?.title.toLowerCase() == title.toLowerCase(),
          orElse: () => null,
        );

    if (match != null && mounted) {
      setState(() {
        selectedNeighborhood = match;
      });
    }
  }

  //============================================================
  // SELECT LOCATION
  //============================================================

  Future<void> selectLocationOnMap() async {
    final LatLng? result = await Get.to<LatLng>(
      () => const SelectLocationScreen(),
    );

    if (result == null || !mounted) {
      return;
    }

    await _reverseGeocodeLocation(result);
  }

  //============================================================
  // CHECK DELIVERY RADIUS
  //============================================================

  bool _isInsideDeliveryRadius(LatLng location) {
    final double distance = const Distance().as(
      LengthUnit.Meter,
      _restaurantLocation,
      location,
    );

    return distance <= _deliveryRadiusMeters;
  }

  //============================================================
  // REVERSE GEOCODE
  //============================================================

  Future<void> _reverseGeocodeLocation(LatLng location) async {
    if (!_isInsideDeliveryRadius(location)) {
      Snack_Bar.show(
        title: 'Outside Delivery Area',
        message:
            'Quick Bite delivers within 10 KM '
            'of the restaurant.',
        icon: FontAwesomeIcons.locationDot,
      );
      return;
    }

    setState(() {
      isLoadingAddress = true;
    });

    try {
      selectedLocation = location;

      final List<Placemark> placemarks = await _geocoding
          .placemarkFromCoordinates(location.latitude, location.longitude);

      if (placemarks.isNotEmpty) {
        final Placemark place = placemarks.first;

        final String street = _buildStreetAddress(place);

        if (street.isNotEmpty) {
          streetAddressController.text = street;
        }

        //======================================================
        // AUTO-DETECT NEIGHBORHOOD
        //======================================================

        final String detectedNeighborhood = _buildNeighborhood(place);

        if (detectedNeighborhood.isNotEmpty) {
          final match = addressController.neighborhoods
              .cast<AddressNeighborhoodModel?>()
              .firstWhere(
                (item) =>
                    item?.title.toLowerCase() ==
                    detectedNeighborhood.toLowerCase(),
                orElse: () => null,
              );

          if (match != null) {
            selectedNeighborhood = match;
          }
        }
      }
    } catch (error) {
      debugPrint('Reverse geocoding error: $error');
    } finally {
      if (mounted) {
        setState(() {
          isLoadingAddress = false;
        });
      }
    }
  }

  //============================================================
  // BUILD STREET ADDRESS
  //============================================================

  String _buildStreetAddress(Placemark place) {
    final List<String> parts = [];

    if (place.subThoroughfare != null &&
        place.subThoroughfare!.trim().isNotEmpty) {
      parts.add(place.subThoroughfare!.trim());
    }

    if (place.thoroughfare != null && place.thoroughfare!.trim().isNotEmpty) {
      parts.add(place.thoroughfare!.trim());
    }

    if (parts.isNotEmpty) {
      return parts.join(' ');
    }

    if (place.street != null && place.street!.trim().isNotEmpty) {
      return place.street!.trim();
    }

    if (place.name != null && place.name!.trim().isNotEmpty) {
      return place.name!.trim();
    }

    return '';
  }

  //============================================================
  // BUILD NEIGHBORHOOD
  //============================================================

  String _buildNeighborhood(Placemark place) {
    if (place.subLocality != null && place.subLocality!.trim().isNotEmpty) {
      return place.subLocality!.trim();
    }

    if (place.locality != null && place.locality!.trim().isNotEmpty) {
      return place.locality!.trim();
    }

    return '';
  }

  //============================================================
  // SAVE ADDRESS
  //============================================================

  Future<void> saveAddress() async {
    if (isSaving) {
      return;
    }

    //==========================================================
    // VALIDATION
    //==========================================================

    if (phoneNumberController.text.trim().isEmpty) {
      _showValidationMessage('Please enter your phone number.');
      return;
    }

    if (streetAddressController.text.trim().isEmpty) {
      _showValidationMessage('Please enter your street address.');
      return;
    }

    if (selectedAddressType == null) {
      _showValidationMessage('Please select an address type.');
      return;
    }

    if (selectedNeighborhood == null) {
      _showValidationMessage('Please select your neighborhood.');
      return;
    }

    if (selectedLocation == null) {
      _showValidationMessage(
        'Please select your delivery location on the map.',
      );
      return;
    }

    //==========================================================
    // FINAL DELIVERY CHECK
    //==========================================================

    if (!_isInsideDeliveryRadius(selectedLocation!)) {
      _showValidationMessage(
        'Quick Bite delivers within 10 KM '
        'of the restaurant.',
      );
      return;
    }

    setState(() {
      isSaving = true;
    });

    //==========================================================
    // MODEL
    //==========================================================

    final AddressModel address = AddressModel(
      id:
          editingAddress?.id ??
          DateTime.now().microsecondsSinceEpoch.toString(),

      phoneNumber: phoneNumberController.text.trim(),

      addressType: selectedAddressType!,

      streetAddress: streetAddressController.text.trim(),

      apartment: apartmentController.text.trim().isEmpty
          ? null
          : apartmentController.text.trim(),

      neighborhood: selectedNeighborhood!.title,

      deliveryInstructions: deliveryInstructionsController.text.trim().isEmpty
          ? null
          : deliveryInstructionsController.text.trim(),

      isDefault: isDefault,

      isSelected: editingAddress?.isSelected ?? false,

      latitude: selectedLocation!.latitude,

      longitude: selectedLocation!.longitude,
    );

    //==========================================================
    // FIRESTORE SAVE
    //==========================================================

    final bool success = editingAddress == null
        ? await addressController.addAddress(address)
        : await addressController.updateAddress(address);

    if (!mounted) {
      return;
    }

    setState(() {
      isSaving = false;
    });

    if (!success) {
      Snack_Bar.show(
        title: 'Unable to Save',
        message: addressController.errorMessage.value.isEmpty
            ? 'Please try again.'
            : addressController.errorMessage.value,
        icon: FontAwesomeIcons.circleExclamation,
      );
      return;
    }

    //==========================================================
    // SUCCESS
    //==========================================================

    Get.back();

    Snack_Bar.show(
      title: editingAddress == null ? 'Address Added' : 'Address Updated',
      message: editingAddress == null
          ? 'Your delivery address has been saved.'
          : 'Your delivery address has been updated.',
      icon: FontAwesomeIcons.locationDot,
    );
  }

  //============================================================
  // VALIDATION MESSAGE
  //============================================================

  void _showValidationMessage(String message) {
    Snack_Bar.show(
      title: 'Missing Information',
      message: message,
      icon: FontAwesomeIcons.circleExclamation,
    );
  }

  //============================================================
  // LOCATION PICKER
  //============================================================

 //============================================================
// LOCATION PICKER
//============================================================

Widget LocationPicker() {
  final bool hasLocation = selectedLocation != null;

  //============================================================
  // REVERSE GEOCODING LOADING
  //============================================================

  if (isLoadingAddress) {
    return const LocationPickerShimmer();
  }

  return GestureDetector(
    onTap: selectLocationOnMap,
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: hasLocation
              ? AppColors.primary
              : Colors.grey.shade300,
        ),
      ),
      child: Column(
        children: [
          //======================================================
          // DELIVERY LOCATION IMAGE
          //======================================================

          Obx(() {
            final String imageUrl =
                fixedAssetController.getImageUrl(
              'app_delivery_location',
            );

            //====================================================
            // NO URL YET
            //====================================================

            if (imageUrl.isEmpty) {
              return _deliveryLocationImageShimmer();
            }

            //====================================================
            // NEW URL
            //====================================================

            if (_deliveryLocationLoadingUrl != imageUrl) {
              _deliveryLocationLoadingUrl = imageUrl;
              _deliveryLocationImageLoaded = false;
            }

            //====================================================
            // IMAGE STILL LOADING
            //====================================================

            if (!_deliveryLocationImageLoaded) {
              return _deliveryLocationImageLoadingWidget(
                imageUrl,
              );
            }

            //====================================================
            // IMAGE LOADED
            //====================================================

            return SizedBox(
              width: 120,
              height: 120,
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (
                  context,
                  error,
                  stackTrace,
                ) {
                  return Icon(
                    Icons.location_on_outlined,
                    size: 55,
                    color: AppColors.primary,
                  );
                },
              ),
            );
          }),

          const SizedBox(height: 4),

          //======================================================
          // LOCATION TITLE
          //======================================================

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                hasLocation
                    ? 'Location selected'
                    : 'Select location on map',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),

              const SizedBox(width: 5),

              Icon(
                hasLocation
                    ? Icons.check_circle
                    : Icons.arrow_forward_ios,
                size: 18,
                color: AppColors.primary,
              ),
            ],
          ),

          const SizedBox(height: 4),

          //======================================================
          // COORDINATES / HINT
          //======================================================

          Text(
            hasLocation
                ? '${selectedLocation!.latitude.toStringAsFixed(5)}, '
                      '${selectedLocation!.longitude.toStringAsFixed(5)}'
                : 'Tap to choose your delivery location',
            style: GoogleFonts.poppins(
              fontSize: hasLocation ? 15 : 12,
              fontWeight:
                  hasLocation ? FontWeight.bold : null,
              color: hasLocation
                  ? AppColors.primary
                  : Colors.grey.shade600,
            ),
          ),
        ],
      ),
    ),
  );
}

 
 //============================================================
// DELIVERY LOCATION IMAGE WHILE LOADING
//============================================================

Widget _deliveryLocationImageLoadingWidget(
  String imageUrl,
) {
  return Stack(
    alignment: Alignment.center,
    children: [
      //========================================================
      // LOAD ACTUAL IMAGE IN BACKGROUND
      //========================================================

      SizedBox(
        width: 120,
        height: 120,
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,

          //======================================================
          // IMAGE FINISHED LOADING
          //======================================================

          frameBuilder: (
            BuildContext context,
            Widget child,
            int? frame,
            bool wasSynchronouslyLoaded,
          ) {
            if (wasSynchronouslyLoaded || frame != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted &&
                    _deliveryLocationLoadingUrl == imageUrl &&
                    !_deliveryLocationImageLoaded) {
                  setState(() {
                    _deliveryLocationImageLoaded = true;
                  });
                }
              });
            }

            return Opacity(
              opacity: 0,
              child: child,
            );
          },

          //======================================================
          // IMAGE ERROR
          //======================================================

          errorBuilder: (
            context,
            error,
            stackTrace,
          ) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted &&
                  _deliveryLocationLoadingUrl == imageUrl) {
                setState(() {
                  _deliveryLocationImageLoaded = true;
                });
              }
            });

            return const SizedBox();
          },
        ),
      ),

      //========================================================
      // SHIMMER
      //========================================================

      _deliveryLocationImageShimmer(),
    ],
  );
}

//============================================================
// DELIVERY LOCATION IMAGE SHIMMER
//============================================================

Widget _deliveryLocationImageShimmer() {
  return Shimmer.fromColors(
    baseColor: Colors.grey.shade300,
    highlightColor: Colors.grey.shade100,
    child: Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
    ),
  );
}
 
 
  //============================================================
  // ADDRESS TYPE
  //============================================================

  Widget AddressType() {
    return Obx(() {
      final types = addressController.addressTypes;

      if (types.isEmpty) {
        return const SizedBox.shrink();
      }

      // Set first Firestore type for new address.
      if (editingAddress == null && selectedAddressType == null) {
        selectedAddressType = types.first;
      }

      return Wrap(
        spacing: 12,
        children: types
            .map((variant) {
              final bool isSelected = selectedAddressType?.id == variant.id;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedAddressType = variant;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : Colors.grey.shade300,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FaIcon(
                          variant.icon,
                          size: 18,
                          color: isSelected
                              ? Colors.black
                              : Colors.grey.shade400,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          variant.title,
                          style: GoogleFonts.poppins(
                            color: isSelected
                                ? Colors.black
                                : Colors.grey.shade600,
                            fontWeight: isSelected ? FontWeight.w600 : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            })
            .toList(growable: false),
      );
    });
  }

  //============================================================
  // PHONE
  //============================================================

  Widget PhoneNumber_TextField() {
    return Column(
      children: [
        _RequiredTitle(title: 'Phone Number'),
        const SizedBox(height: 5),
        TextFormField(
          keyboardType: TextInputType.phone,
          controller: phoneNumberController,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            PhoneNumberFormatter(),
          ],
          decoration: InputDecoration(
            prefixText: '+1 ',
            prefixStyle: AppTextTheme.titleText,
            prefixIcon: const Center(
              widthFactor: 1,
              heightFactor: 1,
              child: FaIcon(
                FontAwesomeIcons.phone,
                color: AppColors.primary,
                size: AppConstants.textfieldiconSize,
              ),
            ),
            hintText: '362 2633 8463',
            hintStyle: AppTextTheme.caption,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(100),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(100),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
              borderRadius: BorderRadius.circular(100),
            ),
          ),
        ),
      ],
    );
  }

  //============================================================
  // STREET
  //============================================================

  Widget StreetAddress_TextField() {
    return Column(
      children: [
        _RequiredTitle(title: 'Street Address'),
        const SizedBox(height: 5),
        Text_Field(
          controller: streetAddressController,
          hintText: 'House number and street name',
          prefixIcon: FontAwesomeIcons.house,
        ),
      ],
    );
  }

  //============================================================
  // APARTMENT
  //============================================================

  Widget Apartment_Suite_Unit_TextField() {
    return Column(
      children: [
        Text(
          'Apartment / Suite / Unit (Optional)',
          style: AppTextTheme.textfieldtitleText,
        ),
        const SizedBox(height: 5),
        Text_Field(
          controller: apartmentController,
          hintText: 'Apartment, Suite, Unit (Optional)',
          prefixIcon: FontAwesomeIcons.building,
        ),
      ],
    );
  }

  //============================================================
  // NEIGHBORHOOD
  //============================================================

  Widget Neighborhood_Dropdown() {
    return Obx(() {
      final neighborhoods = addressController.neighborhoods;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _RequiredTitle(title: 'Neighborhood'),
          const SizedBox(height: 5),
          DropdownButtonFormField<AddressNeighborhoodModel>(
            initialValue: selectedNeighborhood,
            hint: Text('Select your neighborhood', style: AppTextTheme.caption),
            isExpanded: true,
            menuMaxHeight: 300,
            dropdownColor: Colors.white,
            borderRadius: BorderRadius.circular(20),
            decoration: InputDecoration(
              prefixIcon: const Center(
                widthFactor: 1,
                heightFactor: 1,
                child: FaIcon(
                  FontAwesomeIcons.mapLocationDot,
                  size: AppConstants.textfieldiconSize,
                  color: AppColors.primary,
                ),
              ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(100),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(100),
                borderSide: const BorderSide(color: Color(0xFFEEEEEE)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(100),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 2,
                ),
              ),
            ),
            items: neighborhoods
                .map(
                  (neighborhood) => DropdownMenuItem<AddressNeighborhoodModel>(
                    value: neighborhood,
                    child: Text(
                      neighborhood.title,
                      style: AppTextTheme.titleText,
                    ),
                  ),
                )
                .toList(growable: false),
            onChanged: neighborhoods.isEmpty
                ? null
                : (value) {
                    setState(() {
                      selectedNeighborhood = value;
                    });
                  },
          ),
        ],
      );
    });
  }

  //============================================================
  // DELIVERY INSTRUCTIONS
  //============================================================

  Widget DeliveryInstructions_TextField() {
    return Column(
      children: [
        Text(
          'Delivery Instructions (Optional)',
          style: AppTextTheme.textfieldtitleText,
        ),
        const SizedBox(height: 5),
        Text_Field(
          controller: deliveryInstructionsController,
          hintText: 'Leave at the door, gate code, landmark, etc.',
          prefixIcon: FontAwesomeIcons.noteSticky,
        ),
      ],
    );
  }

  //============================================================
  // APP BAR
  //============================================================

  Widget AppBar() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Back_Button(),
            const SizedBox(width: 15),
            Text(
              editingAddress == null ? 'Add Address' : 'Edit Address',
              style: AppTextTheme.appbarText,
            ),
          ],
        ),
      ),
    );
  }

  //============================================================
  // BUILD
  //============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            AppBar(),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      AddressType(),

                      const SizedBox(height: 10),

                      LocationPicker(),

                      const SizedBox(height: 30),

                      PhoneNumber_TextField(),

                      const SizedBox(height: 20),

                      StreetAddress_TextField(),

                      const SizedBox(height: 20),

                      Apartment_Suite_Unit_TextField(),

                      const SizedBox(height: 20),

                      Neighborhood_Dropdown(),

                      const SizedBox(height: 20),

                      DeliveryInstructions_TextField(),

                      const SizedBox(height: 20),

                      SwitchListTile(
                        value: isDefault,
                        activeThumbColor: AppColors.primary,
                        inactiveThumbColor: Colors.grey.shade500,
                        inactiveTrackColor: AppColors.background,
                        title: Text(
                          'Set as Default Address',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        onChanged: isSaving
                            ? null
                            : (value) {
                                setState(() {
                                  isDefault = value;
                                });
                              },
                      ),

                      const SizedBox(height: 20),

                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: SizedBox(
                          width: double.infinity,
                          height: AppConstants.buttonHeight,
                          child: ElevatedButton(
                            onPressed: isSaving ? null : saveAddress,
                            child: isSaving
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    editingAddress == null
                                        ? 'Save Address'
                                        : 'Update Address',
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
          ],
        ),
      ),
    );
  }

  //============================================================
  // DISPOSE
  //============================================================

  @override
  void dispose() {
    phoneNumberController.dispose();
    streetAddressController.dispose();
    apartmentController.dispose();
    deliveryInstructionsController.dispose();

    super.dispose();
  }
}

//==============================================================
// REQUIRED FIELD TITLE
//==============================================================

class _RequiredTitle extends StatelessWidget {
  final String title;

  const _RequiredTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title, style: AppTextTheme.textfieldtitleText),
        const SizedBox(width: 3),
        Text(
          '*',
          style: GoogleFonts.poppins(
            color: Colors.red,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
      ],
    );
  }
}
