// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

import 'package:quick_bite/theme/App_Constants.dart';
import 'package:quick_bite/theme/app_colors.dart';
import 'package:quick_bite/theme/app_texttheme.dart';
import 'package:quick_bite/controllers/App_Settings_Controller.dart';

class SelectLocationScreen extends StatefulWidget {
  const SelectLocationScreen({super.key});

  @override
  State<SelectLocationScreen> createState() =>
      _SelectLocationScreenState();
}

class _SelectLocationScreenState
    extends State<SelectLocationScreen> {
  //============================================================
  // MAP CONTROLLER
  //============================================================

  final MapController _mapController =
      MapController();

  //============================================================
  // APP SETTINGS CONTROLLER
  //============================================================

  final AppSettingsController
      _settingsController =
      Get.find<AppSettingsController>();

  //============================================================
  // QUICK BITE RESTAURANT LOCATION
  //============================================================

  static const LatLng _restaurantLocation =
      LatLng(
    34.0537218,
    -118.2497225,
  );

  //============================================================
  // SELECTED LOCATION
  //============================================================

  LatLng _selectedLocation =
      _restaurantLocation;

  bool _isLoadingLocation = true;

  bool _isInsideDeliveryArea = true;

  //============================================================
  // INIT
  //============================================================

  @override
  void initState() {
    super.initState();

    _initializeLocation();
  }

  //============================================================
  // INITIALIZE LOCATION
  //============================================================

  Future<void> _initializeLocation() async {
    //==========================================================
    // WAIT FOR APP SETTINGS
    //==========================================================

    if (_settingsController.isLoading.value) {
      await _waitForSettings();
    }

    //==========================================================
    // GET LOCATION
    //==========================================================

    await _getCurrentLocation();
  }

  //============================================================
  // WAIT FOR SETTINGS
  //============================================================

  Future<void> _waitForSettings() async {
    while (_settingsController.isLoading.value) {
      await Future.delayed(
        const Duration(milliseconds: 100),
      );
    }
  }

  //============================================================
  // GET DELIVERY RADIUS IN METERS
  //============================================================

  double get _deliveryRadiusMeters {
    return _settingsController.deliveryRadius *
        1000;
  }

  //============================================================
  // GET CURRENT GPS LOCATION
  //============================================================

  Future<void> _getCurrentLocation() async {
    try {
      //========================================================
      // LOCATION SERVICE
      //========================================================

      final bool serviceEnabled =
          await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        if (mounted) {
          setState(() {
            _isLoadingLocation = false;
          });

          _showMessage(
            'Please turn on your location service.',
          );
        }

        return;
      }

      //========================================================
      // LOCATION PERMISSION
      //========================================================

      LocationPermission permission =
          await Geolocator.checkPermission();

      if (permission ==
          LocationPermission.denied) {
        permission =
            await Geolocator.requestPermission();

        if (permission ==
            LocationPermission.denied) {
          if (mounted) {
            setState(() {
              _isLoadingLocation = false;
            });

            _showMessage(
              'Location permission is required.',
            );
          }

          return;
        }
      }

      if (permission ==
          LocationPermission.deniedForever) {
        if (mounted) {
          setState(() {
            _isLoadingLocation = false;
          });

          _showMessage(
            'Location permission is permanently denied. '
            'Please enable it from settings.',
          );
        }

        return;
      }

      //========================================================
      // GET CURRENT POSITION
      //========================================================

      final Position position =
          await Geolocator.getCurrentPosition(
        locationSettings:
            const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      final LatLng currentLocation =
          LatLng(
        position.latitude,
        position.longitude,
      );

      if (!mounted) return;

      setState(() {
        _selectedLocation =
            currentLocation;

        _isInsideDeliveryArea =
            _isLocationInsideDeliveryArea(
          currentLocation,
        );

        _isLoadingLocation = false;
      });

      _mapController.move(
        currentLocation,
        14,
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoadingLocation = false;
      });

      _showMessage(
        'Unable to get your current location.',
      );
    }
  }

  //============================================================
  // MOVE TO CURRENT LOCATION
  //============================================================

  Future<void> _moveToCurrentLocation() async {
    try {
      final Position position =
          await Geolocator.getCurrentPosition(
        locationSettings:
            const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      final LatLng currentLocation =
          LatLng(
        position.latitude,
        position.longitude,
      );

      if (!mounted) return;

      setState(() {
        _selectedLocation =
            currentLocation;

        _isInsideDeliveryArea =
            _isLocationInsideDeliveryArea(
          currentLocation,
        );
      });

      _mapController.move(
        currentLocation,
        14,
      );
    } catch (e) {
      _showMessage(
        'Unable to get your current location.',
      );
    }
  }

  //============================================================
  // CHECK DELIVERY RADIUS
  //============================================================

  bool _isLocationInsideDeliveryArea(
    LatLng location,
  ) {
    final double distanceInMeters =
        Geolocator.distanceBetween(
      _restaurantLocation.latitude,
      _restaurantLocation.longitude,
      location.latitude,
      location.longitude,
    );

    return distanceInMeters <=
        _deliveryRadiusMeters;
  }

  //============================================================
  // GET DISTANCE FROM RESTAURANT
  //============================================================

  double _getDistanceFromRestaurant() {
    return Geolocator.distanceBetween(
      _restaurantLocation.latitude,
      _restaurantLocation.longitude,
      _selectedLocation.latitude,
      _selectedLocation.longitude,
    );
  }

  //============================================================
  // CONFIRM LOCATION
  //============================================================

  void _confirmLocation() {
    final bool inside =
        _isLocationInsideDeliveryArea(
      _selectedLocation,
    );

    if (!inside) {
      _showMessage(
        'Quick Bite does not deliver to this location. '
        'Please select a location within '
        '${_settingsController.deliveryRadius.toStringAsFixed(1)} km.',
      );

      return;
    }

    Navigator.pop(
      context,
      _selectedLocation,
    );
  }

  //============================================================
  // MESSAGE
  //============================================================

  void _showMessage(
    String message,
  ) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  //============================================================
  // BUILD
  //============================================================

  @override
  Widget build(BuildContext context) {
    final double distance =
        _getDistanceFromRestaurant();

    final double deliveryRadius =
        _settingsController.deliveryRadius;

    return Scaffold(
      body: Stack(
        children: [
          //======================================================
          // OPEN STREET MAP
          //======================================================

          FlutterMap(
            mapController:
                _mapController,
            options: MapOptions(
              initialCenter:
                  _selectedLocation,
              initialZoom: 14,

              onPositionChanged:
                  (position, hasGesture) {
                final LatLng newLocation =
                    position.center;

                final bool inside =
                    _isLocationInsideDeliveryArea(
                  newLocation,
                );

                if (mounted) {
                  setState(() {
                    _selectedLocation =
                        newLocation;

                    _isInsideDeliveryArea =
                        inside;
                  });
                }
              },
            ),
            children: [
              //================================================
              // OPENSTREETMAP TILES
              //================================================

              TileLayer(
                urlTemplate:
                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName:
                    'com.example.quick_bite',
              ),

              //================================================
              // DELIVERY CIRCLE
              //================================================

              CircleLayer(
                circles: [
                  CircleMarker(
                    point:
                        _restaurantLocation,

                    radius:
                        _deliveryRadiusMeters,

                    useRadiusInMeter:
                        true,

                    color:
                        Colors.yellow
                            .withValues(
                      alpha: 0.1,
                    ),

                    borderColor:
                        AppColors.primary,

                    borderStrokeWidth: 3,
                  ),
                ],
              ),

              //================================================
              // RESTAURANT MARKER
              //================================================

              MarkerLayer(
                markers: [
                  Marker(
                    point:
                        _restaurantLocation,

                    width: 55,

                    height: 55,

                    child: Container(
                      decoration:
                          BoxDecoration(
                        color: Colors.white,
                        shape:
                            BoxShape.circle,
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 6,
                            color:
                                Colors.black26,
                          ),
                        ],
                      ),

                      child: const Icon(
                        Icons.restaurant,
                        color:
                            AppColors.primary,
                        size: 30,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          //======================================================
          // CENTER PIN
          //======================================================

          const Center(
            child: Padding(
              padding:
                  EdgeInsets.only(
                bottom: 35,
              ),
              child: Icon(
                Icons.location_pin,
                size: 52,
                color: Colors.red,
              ),
            ),
          ),

          //======================================================
          // TOP BAR
          //======================================================

          SafeArea(
            child: Padding(
              padding:
                  const EdgeInsets.all(16),
              child: Row(
                children: [
                  Material(
                    color: Colors.white,
                    elevation: 4,
                    shape:
                        const CircleBorder(),
                    child: InkWell(
                      customBorder:
                          const CircleBorder(),
                      onTap: () {
                        Get.back();
                      },
                      child:
                          const Padding(
                        padding:
                            EdgeInsets.all(12),
                        child: Icon(
                          Icons.arrow_back,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(
                    width: 12,
                  ),

                  Expanded(
                    child: Container(
                      padding:
                          const EdgeInsets
                              .symmetric(
                        horizontal: 18,
                        vertical: 14,
                      ),
                      decoration:
                          BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius
                                .circular(
                          30,
                        ),
                        boxShadow:
                            const [
                          BoxShadow(
                            blurRadius: 8,
                            offset:
                                Offset(0, 3),
                            color:
                                Colors.black26,
                          ),
                        ],
                      ),
                      child: Text(
                        'Select delivery location',
                        style:
                            GoogleFonts.poppins(
                          color:
                              Colors.black,
                          fontSize: 15,
                          fontWeight:
                              FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          //======================================================
          // CURRENT LOCATION BUTTON
          //======================================================

          Positioned(
            right: 16,
            bottom: 205,
            child: Material(
              color: Colors.white,
              elevation: 5,
              shape:
                  const CircleBorder(),
              child: InkWell(
                customBorder:
                    const CircleBorder(),
                onTap:
                    _moveToCurrentLocation,
                child:
                    const Padding(
                  padding:
                      EdgeInsets.all(14),
                  child: Icon(
                    Icons.my_location,
                  ),
                ),
              ),
            ),
          ),

          //======================================================
          // BOTTOM PANEL
          //======================================================

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding:
                  const EdgeInsets.fromLTRB(
                20,
                20,
                20,
                25,
              ),
              decoration:
                  const BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.vertical(
                  top: Radius.circular(40),
                ),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 15,
                    offset:
                        Offset(0, -4),
                    color:
                        Colors.black12,
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize:
                      MainAxisSize.min,
                  children: [
                    Text(
                      'Choose your delivery location',
                      style:
                          GoogleFonts.poppins(
                        color:
                            Colors.black,
                        fontSize: 18,
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    //================================================
                    // DELIVERY STATUS
                    //================================================

                    Container(
                      width:
                          double.infinity,
                      padding:
                          const EdgeInsets
                              .symmetric(
                        horizontal: 15,
                        vertical: 12,
                      ),
                      decoration:
                          BoxDecoration(
                        color:
                            _isInsideDeliveryArea
                                ? AppColors
                                    .primary
                                    .withValues(
                                  alpha:
                                      0.1,
                                )
                                : Colors.red
                                    .withValues(
                                  alpha:
                                      0.10,
                                ),
                        borderRadius:
                            BorderRadius
                                .circular(
                          14,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            _isInsideDeliveryArea
                                ? Icons
                                    .check_circle
                                : Icons
                                    .cancel,
                            color:
                                _isInsideDeliveryArea
                                    ? AppColors
                                        .primary
                                    : Colors.red,
                          ),

                          const SizedBox(
                            width: 10,
                          ),

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                              children: [
                                Text(
                                  _isInsideDeliveryArea
                                      ? 'Delivery available'
                                      : 'Outside delivery area',
                                  style:
                                      GoogleFonts
                                          .poppins(
                                    color:
                                        _isInsideDeliveryArea
                                            ? AppColors
                                                .primary
                                            : Colors
                                                .red,
                                    fontSize:
                                        14,
                                    fontWeight:
                                        FontWeight
                                            .w600,
                                  ),
                                ),

                                const SizedBox(
                                  height: 2,
                                ),

                                Text(
                                  '${(distance / 1000).toStringAsFixed(1)} km from Quick Bite • ${deliveryRadius.toStringAsFixed(1)} km delivery radius',
                                  style:
                                      GoogleFonts
                                          .poppins(
                                    color:
                                        Colors
                                            .black,
                                    fontSize:
                                        12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(
                      height: 12,
                    ),

                    Text(
                      _isLoadingLocation
                          ? 'Getting your current location...'
                          : 'Move the map to position the pin.',
                      textAlign:
                          TextAlign.center,
                      style:
                          GoogleFonts.poppins(
                        color:
                            Colors.grey.shade500,
                        fontSize: 13,
                      ),
                    ),

                    const SizedBox(
                      height: 18,
                    ),

                    //================================================
                    // CONFIRM BUTTON
                    //================================================

                    SizedBox(
                      width:
                          double.infinity,
                      height:
                          AppConstants
                              .buttonHeight,
                      child:
                          ElevatedButton(
                        onPressed:
                            _isLoadingLocation
                                ? null
                                : _confirmLocation,
                        style:
                            ElevatedButton
                                .styleFrom(
                          backgroundColor:
                              AppColors
                                  .primary,
                          foregroundColor:
                              Colors.black,
                          elevation: 0,
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius
                                    .circular(
                              100,
                            ),
                          ),
                        ),
                        child: Text(
                          _isInsideDeliveryArea
                              ? 'Confirm Location'
                              : 'Outside Delivery Area',
                          style:
                              AppTextTheme
                                  .button,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          //======================================================
          // LOADING
          //======================================================

          if (_isLoadingLocation)
            Container(
              color:
                  Colors.black26,
              child:
                  const Center(
                child:
                    CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}