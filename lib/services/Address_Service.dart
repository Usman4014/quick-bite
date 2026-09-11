// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quick_bite/models/AddressNeighborhood_Model.dart';
import 'package:quick_bite/models/Address_Model.dart';
import 'package:quick_bite/models/AddressTypeVariant_Model.dart';

class AddressService {
  //============================================================
  // FIRESTORE
  //============================================================

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;




  //============================================================
  // USER ADDRESSES
  //============================================================

  CollectionReference<Map<String, dynamic>> _addressesCollection(
    String userId,
  ) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('addresses');
  }

  //============================================================
  // GET ADDRESS DOCUMENT
  //============================================================

  DocumentReference<Map<String, dynamic>> _addressDocument(
    String userId,
    String addressId,
  ) {
    return _addressesCollection(userId).doc(addressId);
  }

  //============================================================
  // LISTEN TO USER ADDRESSES
  //============================================================

  Stream<List<AddressModel>> listenToAddresses(
    String userId,
  ) {
    if (userId.trim().isEmpty) {
      return Stream.value(
        <AddressModel>[],
      );
    }

    return _addressesCollection(userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (document) =>
                    AddressModel.fromFirestore(document),
              )
              .toList(growable: false),
        );
  }

  //============================================================
  // ADD ADDRESS
  //============================================================

  Future<void> addAddress({
    required String userId,
    required AddressModel address,
  }) async {
    if (userId.trim().isEmpty) {
      throw Exception('User ID is required.');
    }

    final collection = _addressesCollection(userId);

    final addressReference = collection.doc(address.id);

    final batch = _firestore.batch();

    //==========================================================
    // DEFAULT ADDRESS
    //==========================================================

    if (address.isDefault) {
      final defaultSnapshot = await collection
          .where('isDefault', isEqualTo: true)
          .get();

      for (final document in defaultSnapshot.docs) {
        batch.update(
          document.reference,
          {
            'isDefault': false,
            'updatedAt': FieldValue.serverTimestamp(),
          },
        );
      }
    }

    //==========================================================
    // FIRST ADDRESS
    //==========================================================

    final existingSnapshot =
        await collection.limit(1).get();

    final bool shouldSelectAutomatically =
        existingSnapshot.docs.isEmpty;

    final data = address.toFirestore();

    data['isSelected'] =
        shouldSelectAutomatically ||
        address.isSelected;

    data['createdAt'] =
        FieldValue.serverTimestamp();

    data['updatedAt'] =
        FieldValue.serverTimestamp();

    batch.set(
      addressReference,
      data,
    );

    //==========================================================
    // ONLY ONE SELECTED ADDRESS
    //==========================================================

    if (data['isSelected'] == true) {
      final selectedSnapshot = await collection
          .where('isSelected', isEqualTo: true)
          .get();

      for (final document in selectedSnapshot.docs) {
        if (document.id != address.id) {
          batch.update(
            document.reference,
            {
              'isSelected': false,
              'updatedAt':
                  FieldValue.serverTimestamp(),
            },
          );
        }
      }
    }

    await batch.commit();
  }

  //============================================================
// ADDRESS NEIGHBORHOODS
//============================================================

CollectionReference<Map<String, dynamic>>
    get neighborhoodsCollection =>
        _firestore.collection('neighborhoods');

//============================================================
// LISTEN TO NEIGHBORHOODS
//============================================================

Stream<List<AddressNeighborhoodModel>>
    listenToNeighborhoods() {
  return neighborhoodsCollection
      .where('isActive', isEqualTo: true)
      .orderBy('displayOrder')
      .snapshots()
      .map(
        (snapshot) => snapshot.docs
            .map(
              (document) =>
                  AddressNeighborhoodModel.fromFirestore(
                document,
              ),
            )
            .where(
              (neighborhood) =>
                  neighborhood.title.isNotEmpty,
            )
            .toList(growable: false),
      );
}

  //============================================================
  // UPDATE ADDRESS
  //============================================================

  Future<void> updateAddress({
    required String userId,
    required AddressModel address,
  }) async {
    if (userId.trim().isEmpty) {
      throw Exception('User ID is required.');
    }

    final collection = _addressesCollection(userId);

    final batch = _firestore.batch();

    //==========================================================
    // DEFAULT ADDRESS
    //==========================================================

    if (address.isDefault) {
      final defaultSnapshot = await collection
          .where('isDefault', isEqualTo: true)
          .get();

      for (final document in defaultSnapshot.docs) {
        if (document.id != address.id) {
          batch.update(
            document.reference,
            {
              'isDefault': false,
              'updatedAt':
                  FieldValue.serverTimestamp(),
            },
          );
        }
      }
    }

    //==========================================================
    // SELECTED ADDRESS
    //==========================================================

    if (address.isSelected) {
      final selectedSnapshot = await collection
          .where('isSelected', isEqualTo: true)
          .get();

      for (final document in selectedSnapshot.docs) {
        if (document.id != address.id) {
          batch.update(
            document.reference,
            {
              'isSelected': false,
              'updatedAt':
                  FieldValue.serverTimestamp(),
            },
          );
        }
      }
    }

    //==========================================================
    // UPDATE
    //==========================================================

    batch.update(
      _addressDocument(userId, address.id),
      {
        ...address.toFirestore(),
        'updatedAt':
            FieldValue.serverTimestamp(),
      },
    );

    await batch.commit();
  }

  //============================================================
  // DELETE ADDRESS
  //============================================================

  Future<void> deleteAddress({
    required String userId,
    required String addressId,
  }) async {
    if (userId.trim().isEmpty) {
      throw Exception('User ID is required.');
    }

    await _addressDocument(
      userId,
      addressId,
    ).delete();
  }

  //============================================================
  // SELECT ADDRESS
  //============================================================

  Future<void> selectAddress({
    required String userId,
    required String addressId,
  }) async {
    if (userId.trim().isEmpty) {
      throw Exception('User ID is required.');
    }

    final collection = _addressesCollection(userId);

    final selectedSnapshot = await collection
        .where('isSelected', isEqualTo: true)
        .get();

    final batch = _firestore.batch();

    for (final document in selectedSnapshot.docs) {
      if (document.id != addressId) {
        batch.update(
          document.reference,
          {
            'isSelected': false,
            'updatedAt':
                FieldValue.serverTimestamp(),
          },
        );
      }
    }

    batch.update(
      collection.doc(addressId),
      {
        'isSelected': true,
        'updatedAt':
            FieldValue.serverTimestamp(),
      },
    );

    await batch.commit();
  }

  //============================================================
  // SET DEFAULT ADDRESS
  //============================================================

  Future<void> setDefaultAddress({
    required String userId,
    required String addressId,
  }) async {
    if (userId.trim().isEmpty) {
      throw Exception('User ID is required.');
    }

    final collection = _addressesCollection(userId);

    final defaultSnapshot = await collection
        .where('isDefault', isEqualTo: true)
        .get();

    final batch = _firestore.batch();

    for (final document in defaultSnapshot.docs) {
      if (document.id != addressId) {
        batch.update(
          document.reference,
          {
            'isDefault': false,
            'updatedAt':
                FieldValue.serverTimestamp(),
          },
        );
      }
    }

    batch.update(
      collection.doc(addressId),
      {
        'isDefault': true,
        'updatedAt':
            FieldValue.serverTimestamp(),
      },
    );

    await batch.commit();
  }

  //============================================================
  // GET SINGLE ADDRESS
  //============================================================

  Future<AddressModel?> getAddress({
    required String userId,
    required String addressId,
  }) async {
    final document = await _addressDocument(
      userId,
      addressId,
    ).get();

    if (!document.exists) {
      return null;
    }

    return AddressModel.fromFirestore(document);
  }

  //============================================================
  // ADDRESS TYPES
  //============================================================

  CollectionReference<Map<String, dynamic>>
      get addressTypesCollection =>
          _firestore.collection('addressTypes');

  Stream<List<AddressTypeVariantModel>>
      listenToAddressTypes() {
    return addressTypesCollection
        .where('isActive', isEqualTo: true)
        .orderBy('displayOrder')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (document) =>
                    AddressTypeVariantModel.fromFirestore(
                  document,
                ),
              )
              .toList(growable: false),
        );
  }
}