// ignore_for_file: avoid_print, file_names

import 'dart:async';

import 'package:get/get.dart';

import 'package:quick_bite/models/fixed_asset_model.dart';
import 'package:quick_bite/services/fixed_asset_service.dart';

class FixedAssetController extends GetxController {
  //============================================================
  // SERVICE
  //============================================================

  final FixedAssetService _service = FixedAssetService();

  //============================================================
  // ASSETS
  //============================================================

  final RxList<FixedAssetModel> assets = <FixedAssetModel>[].obs;

  //============================================================
  // STATE
  //============================================================

  final RxBool isLoading = true.obs;

  final RxString errorMessage = ''.obs;

  //============================================================
  // SUBSCRIPTION
  //============================================================

  StreamSubscription<List<FixedAssetModel>>? _assetSubscription;

  //============================================================
  // INIT
  //============================================================

  @override
  void onInit() {
    super.onInit();

    // Fixed assets are public app assets.
    // They must load even when the user is NOT logged in.
    listenToAssets();
  }

  //============================================================
  // LISTEN TO ASSETS
  //============================================================

  void listenToAssets() {
    _assetSubscription?.cancel();

    isLoading.value = true;
    errorMessage.value = '';

    _assetSubscription = _service.listenToAssets().listen(
      (data) {
        assets.assignAll(data);

        isLoading.value = false;
        errorMessage.value = '';

        print('================ FIXED ASSETS ================');

        print('Total assets loaded: ${assets.length}');

        for (final asset in assets) {
          print(
            'Asset: ${asset.id} | '
            '${asset.title} | '
            '${asset.imageUrl}',
          );
        }

        print('===============================================');
      },
      onError: (error) {
        isLoading.value = false;

        errorMessage.value = 'Unable to load fixed assets.';

        print('FIXED ASSETS ERROR: $error');
      },
    );
  }

  //============================================================
  // GET ASSET
  //============================================================

  FixedAssetModel? getAsset(String assetId) {
    for (final asset in assets) {
      if (asset.id == assetId) {
        return asset;
      }
    }

    return null;
  }

  //============================================================
  // GET IMAGE URL
  //============================================================

  String getImageUrl(String assetId) {
    return getAsset(assetId)?.imageUrl ?? '';
  }

  //============================================================
  // CLOSE
  //============================================================

  @override
  void onClose() {
    _assetSubscription?.cancel();

    super.onClose();
  }
}
