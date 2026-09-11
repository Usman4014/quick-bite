// ignore_for_file: file_names

import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class LandingController extends GetxController {
  final PersistentTabController tabController =
      PersistentTabController(initialIndex: 0);

  void changeTab(int index) {
    tabController.jumpToTab(index);
  }
}