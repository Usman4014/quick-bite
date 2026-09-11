// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:quick_bite/models/Category_Model.dart';

class CategoryService {
  //============================================================
  // FIRESTORE
  //============================================================

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  //============================================================
  // CATEGORIES COLLECTION
  //============================================================

  CollectionReference<Map<String, dynamic>>
      get _categoriesCollection =>
          _firestore.collection('categories');

  //============================================================
  // LISTEN TO ACTIVE CATEGORIES
  //============================================================

  Stream<List<CategoryModel>> listenToCategories() {
    return _categoriesCollection
        .where(
          'isActive',
          isEqualTo: true,
        )
        .snapshots()
        .map(
          (snapshot) {
            return snapshot.docs.map(
              (doc) {
                return CategoryModel.fromFirestore(
                  doc.id,
                  doc.data(),
                );
              },
            ).toList();
          },
        );
  }
}