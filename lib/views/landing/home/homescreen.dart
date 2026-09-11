// ignore_for_file: non_constant_identifier_names

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quick_bite/controllers/Address_Controller.dart';
import 'package:quick_bite/controllers/Banner_Controller.dart';
import 'package:quick_bite/controllers/Product_Controller.dart';
import 'package:quick_bite/controllers/Review_Controller.dart';
import 'package:quick_bite/controllers/Special_Deals_Controller.dart';
import 'package:quick_bite/helpers/cloudinary_image_helper.dart';
import 'package:quick_bite/routes/App_Routes.dart';
import 'package:quick_bite/shimmers/home_categories_shimmer.dart';
import 'package:quick_bite/theme/app_colors.dart';
import 'package:quick_bite/theme/app_texttheme.dart';
import 'package:quick_bite/views/landing/home/chefs_special/chef_special.dart';
import 'package:quick_bite/views/landing/home/popular_right_now/popular_right_now.dart';
import 'package:quick_bite/views/landing/home/special_deals/special_deals_banner.dart';
import 'package:quick_bite/controllers/Category_Controller.dart';
import 'package:quick_bite/views/landing/home/why_quick_bite/why_quick_bite.dart';
import 'package:quick_bite/views/product/listofproducts_screen.dart';
import 'package:quick_bite/widgets/text_field.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final BannerController bannerController = Get.find<BannerController>();
  final CategoryController categoryController = Get.find<CategoryController>();
  final SpecialDealsController specialDealsController =
      Get.find<SpecialDealsController>();
  final productController = Get.find<ProductController>();
  final ReviewController reviewController = Get.find<ReviewController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(height: 10),
              CustomerAddressBar(),
              SizedBox(height: 20),
              SearchFood_TextField(),
              SizedBox(height: 30),
              SpecialDeals_ViewAll_Line(),
              SizedBox(height: 10),
              SpecialDealsBanner(),
              SizedBox(height: 30),
              AllCategoriesText_Line(),
              AllCategories(),
              SizedBox(height: 30),
              PopularRightNow(),
              SizedBox(height: 30),
              ChefSpecial(),
              SizedBox(height: 40),
              WhyQuickBite(),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  final AddressController addressController = Get.find<AddressController>();
  Widget CustomerAddressBar() {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () {
        Get.toNamed(AppRoutes.address);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade500,
                blurRadius: 2,
                offset: const Offset(1, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      //================================================
                      // LOCATION ICON
                      //================================================

                      FaIcon(
                        FontAwesomeIcons.locationDot,
                        color: Colors.black87,
                        size: 25,
                      ),

                      const SizedBox(width: 10),

                      //================================================
                      // ADDRESS
                      //================================================
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //============================================
                            // DELIVER TO
                            //============================================

                            Row(
                              children: [
                                Text(
                                  'Deliver to',
                                  style: AppTextTheme.titleText,
                                ),

                                const SizedBox(width: 10),

                                FaIcon(
                                  FontAwesomeIcons.angleDown,
                                  color: Colors.black,
                                  size: 17,
                                ),
                              ],
                            ),

                            //============================================
                            // ADDRESS STATE
                            //============================================
                            Obx(() {
                              //==========================================
                              // LOADING
                              //==========================================

                              if (addressController.isLoading.value) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 7),
                                  child: Shimmer.fromColors(
                                    baseColor: Colors.grey.shade400,
                                    highlightColor: Colors.grey.shade200,
                                    child: Container(
                                      height: 11,
                                      width: 150,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                  ),
                                );
                              }

                              //==========================================
                              // SELECTED ADDRESS
                              //==========================================

                              final address = addressController.selectedAddress;

                              if (address == null) {
                                return Text(
                                  "Select Address",
                                  style: AppTextTheme.bodyText,
                                );
                              }

                              //==========================================
                              // ADDRESS
                              //==========================================

                              return Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 40),
                                      child: Text(
                                        address.streetAddress,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: AppTextTheme.bodyText,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                //================================================
                // NOTIFICATION BUTTON
                //================================================
                InkWell(
                  splashColor: Colors.transparent,
                  onTap: () {
                    Get.toNamed(AppRoutes.notifications);
                  },
                  child: Container(
                    height: 45,
                    width: 45,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: FaIcon(
                        FontAwesomeIcons.bell,
                        color: AppColors.primary,
                        size: 25,
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

  TextEditingController searchController = TextEditingController();
  Widget SearchFood_TextField() {
    void searchProducts(String value) {
      final query = value.trim();

      if (query.isEmpty) {
        return;
      }

      Get.to(() => ListOfProducts(), arguments: {'searchQuery': query});
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text_Field(
        controller: searchController,
        hintText: 'Search food',
        prefixIcon: FontAwesomeIcons.magnifyingGlass,
        textInputAction: TextInputAction.search,
        onSubmitted: searchProducts,
      ),
    );
  }

  Widget SpecialDeals_ViewAll_Line() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Special Deals',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          GestureDetector(
            onTap: () {
              Get.toNamed(AppRoutes.specialDeal);
            },
            child: Text('View All', style: AppTextTheme.textButton),
          ),
        ],
      ),
    );
  }

  int currentSliderIndex = 0;
  Widget AllSliders() {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        height: 200,
        width: width,
        child: Obx(() {
          final banners = bannerController.banners;

          if (banners.isEmpty) {
            return const SizedBox.shrink();
          }

          return Stack(
            children: [
              CarouselSlider.builder(
                itemCount: banners.length,
                itemBuilder: (context, index, realIndex) {
                  final banner = banners[index];

                  return ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      banner.image,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const SizedBox.shrink();
                      },
                    ),
                  );
                },
                options: CarouselOptions(
                  height: height * 0.85,
                  autoPlay: banners.length > 1,
                  enlargeCenterPage: true,
                  autoPlayInterval: const Duration(seconds: 3),
                  viewportFraction: 1,
                  onPageChanged: (index, reason) {
                    if (!mounted) return;

                    setState(() {
                      currentSliderIndex = index;
                    });
                  },
                ),
              ),

              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.7),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        banners.length,
                        (index) => AnimatedContainer(
                          width: currentSliderIndex == index ? 20 : 8,
                          height: 8,
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color: currentSliderIndex == index
                                ? Colors.grey.shade200
                                : Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget AllCategoriesText_Line() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'All Categories',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget AllCategories() {
    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: SizedBox(
        height: 120,
        child: Obx(() {
          //======================================================
          // LOADING
          //======================================================

          if (categoryController.isLoading.value) {
            return const HomeCategoriesShimmer();
          }

          //======================================================
          // ERROR
          //======================================================

          if (categoryController.errorMessage.value.isNotEmpty) {
            return const SizedBox.shrink();
          }

          //======================================================
          // EMPTY
          //======================================================

          if (categoryController.categories.isEmpty) {
            return const Center(child: Text('No categories available'));
          }

          //======================================================
          // REAL CATEGORIES
          //======================================================

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: categoryController.categories.length,
            itemBuilder: (context, index) {
              final category = categoryController.categories[index];

              return InkWell(
                splashColor: Colors.transparent,
                onTap: () {
                  Get.toNamed(
                    AppRoutes.listofproducts,
                    arguments: category.name,
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                    right: 10,
                    bottom: 10,
                    top: 10,
                    left: 5,
                  ),
                  child: Container(
                    width: 80,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade500,
                          blurRadius: 2,
                          offset: const Offset(1, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 60,
                          width: 60,
                          color: AppColors.primary,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              CloudinaryImageHelper.optimize(
                                category.image,
                                width: 120,
                                height: 120,
                              ),
                              fit: BoxFit.cover,
                              cacheWidth: 120,
                              cacheHeight: 120,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.image_not_supported);
                              },
                            ),
                          ),
                        ),

                        const SizedBox(height: 2),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: Text(
                            category.name,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextTheme.homecategory,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }

  Widget ChefsSpecial_ViewAll_Line() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Chef's Special",
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),

          TextButton(
            onPressed: () {
              // Later:
              // Open All Popular Items Screen
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text("View All", style: AppTextTheme.textButton),
          ),
        ],
      ),
    );
  }
}
