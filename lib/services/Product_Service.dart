// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:quick_bite/models/Product_Model.dart';
import 'package:quick_bite/models/ProductVariant_Model.dart';

class ProductService {
  //============================================================
  // FIRESTORE
  //============================================================

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  //============================================================
  // PRODUCTS COLLECTION
  //============================================================

  CollectionReference<Map<String, dynamic>>
      get _productsCollection =>
          _firestore.collection('products');

  //============================================================
  // GET ACTIVE PRODUCTS
  //============================================================

  Future<List<ProductModel>> getActiveProducts() async {
    final QuerySnapshot<Map<String, dynamic>> snapshot =
        await _productsCollection
            .where(
              'isActive',
              isEqualTo: true,
            )
            .get();

    return _mapProducts(snapshot);
  }

  //============================================================
  // GET SINGLE ACTIVE PRODUCT
  //============================================================

  Future<ProductModel?> getProductById(
    String productId,
  ) async {
    final DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _productsCollection
            .doc(productId)
            .get();

    //==========================================================
    // PRODUCT DOES NOT EXIST
    //==========================================================

    if (!snapshot.exists || snapshot.data() == null) {
      return null;
    }

    final Map<String, dynamic> data =
        snapshot.data()!;

    //==========================================================
    // PRODUCT IS INACTIVE
    //==========================================================

    if (data['isActive'] as bool? ?? false == false) {
      return null;
    }

    return _mapProduct(
      snapshot.id,
      data,
    );
  }

  //============================================================
  // MAP PRODUCTS
  //============================================================

  List<ProductModel> _mapProducts(
    QuerySnapshot<Map<String, dynamic>> snapshot,
  ) {
    return snapshot.docs.map((doc) {
      return _mapProduct(
        doc.id,
        doc.data(),
      );
    }).toList(growable: false);
  }

  //============================================================
  // MAP SINGLE PRODUCT
  //============================================================

  ProductModel _mapProduct(
    String id,
    Map<String, dynamic> data,
  ) {
    //==========================================================
    // VARIANTS
    //==========================================================

    final List<dynamic> variantsData =
        data['variants'] as List<dynamic>? ?? const [];

    final List<ProductVariantModel> variants =
        List<ProductVariantModel>.generate(
      variantsData.length,
      (index) {
        final variant =
            variantsData[index] as Map;

        return ProductVariantModel(
          id: variant['id']?.toString() ?? '',
          name: variant['name']?.toString() ?? '',
          price:
              (variant['price'] as num?)?.toDouble() ?? 0.0,
        );
      },
      growable: false,
    );

    //==========================================================
    // PRODUCT
    //==========================================================

    return ProductModel(
      id: id,
      name: data['name']?.toString() ?? '',
      description: data['description']?.toString() ?? '',
      image: data['image']?.toString() ?? '',
      categoryId:
          data['categoryId']?.toString() ?? '',
      category:
          data['category']?.toString() ?? '',
      isChefSpecial:
          data['isChefSpecial'] as bool? ?? false,
      totalOrders:
          (data['totalOrders'] as num?)?.toInt() ?? 0,
      variants: variants,
    );
  }
}