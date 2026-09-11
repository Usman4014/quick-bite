
// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quick_bite/models/User_Model.dart';

class UserService {
  // final FirebaseFirestore _firestore =
  //     FirebaseFirestore.instance;

  final CollectionReference<Map<String, dynamic>>
      _usersCollection =
      FirebaseFirestore.instance.collection('users');

  //============================================================
  // CREATE USER DOCUMENT
  //============================================================

  Future<void> createUser({
    required User firebaseUser,
    required String name,
    String phoneNumber = '',
    String? profileImage,
  }) async {
    final userData = <String, dynamic>{
      'id': firebaseUser.uid,
      'name': name,
      'email': firebaseUser.email ?? '',
      'phoneNumber': phoneNumber.isNotEmpty
          ? phoneNumber
          : (firebaseUser.phoneNumber ?? ''),
      'profileImage': profileImage ?? firebaseUser.photoURL,

      // New user starts with empty collections.
      'addresses': [],
      'favoriteProducts': [],
      'paymentMethods': [],
      'notifications': [],

      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };

    await _usersCollection
        .doc(firebaseUser.uid)
        .set(userData);
  }

  //============================================================
  // CHECK IF USER EXISTS
  //============================================================

  Future<bool> userExists(String uid) async {
    final document =
        await _usersCollection.doc(uid).get();

    return document.exists;
  }

  //============================================================
  // GET RAW USER DATA
  //============================================================

  Future<Map<String, dynamic>?> getUserData(
    String uid,
  ) async {
    final document =
        await _usersCollection.doc(uid).get();

    if (!document.exists) {
      return null;
    }

    return document.data();
  }

  //============================================================
  // GET USER MODEL
  //============================================================

  Future<UserModel?> getUser(String uid) async {
    final document =
        await _usersCollection.doc(uid).get();

    if (!document.exists) {
      return null;
    }

    final data = document.data();

    if (data == null) {
      return null;
    }

    return UserModel(
      id: data['id'] ?? uid,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      phoneNumber: data['phoneNumber'] ?? '',
      
      profileImage: data['profileImage'],

      // These will be connected to their
      // Firestore serializers later.
      addresses: [],
      favoriteProducts: [],
      paymentMethods: [],
      notifications: [],
    );
  }

  //============================================================
  // UPDATE USER BASIC INFORMATION
  //============================================================

  Future<void> updateUser({
    required String uid,
    String? name,
    String? email,
    String? phoneNumber,
    String? profileImage,
  }) async {
    final Map<String, dynamic> data = {};

    if (name != null) {
      data['name'] = name;
    }

    if (email != null) {
      data['email'] = email;
    }

    if (phoneNumber != null) {
      data['phoneNumber'] = phoneNumber;
    }

    if (profileImage != null) {
      data['profileImage'] = profileImage;
    }

    data['updatedAt'] =
        FieldValue.serverTimestamp();

   if (data.isNotEmpty) {
  await _usersCollection.doc(uid).update(data);
}
  }

  //============================================================
  // DELETE USER FIRESTORE DOCUMENT
  //============================================================

  Future<void> deleteUserDocument(
    String uid,
  ) async {
    await _usersCollection
        .doc(uid)
        .delete();
  }

  //============================================================
// CREATE USER IF IT DOES NOT EXIST
//============================================================

Future<void> createUserIfNotExists({
  required User firebaseUser,
  String? name,
  String? phoneNumber,
  String? profileImage,
}) async {
  final exists = await userExists(firebaseUser.uid);

  if (!exists) {
    await createUser(
      firebaseUser: firebaseUser,
      name: name ??
          firebaseUser.displayName ??
          '',
      phoneNumber: phoneNumber ??
          firebaseUser.phoneNumber ??
          '',
      profileImage: profileImage ??
          firebaseUser.photoURL,
    );

    return;
  }

  //==========================================================
  // USER ALREADY EXISTS
  //==========================================================

  await updateUser(
    uid: firebaseUser.uid,
    email: firebaseUser.email?.trim().toLowerCase(),
    name: firebaseUser.displayName,
    phoneNumber: firebaseUser.phoneNumber,

    // IMPORTANT:
    // Use the supplied Facebook image first.
    profileImage: profileImage ?? firebaseUser.photoURL,
  );
}

  //============================================================
  // UPDATE LAST MODIFIED TIME
  //============================================================

  Future<void> updateLastModified(
    String uid,
  ) async {
    await _usersCollection.doc(uid).update({
      'updatedAt':
          FieldValue.serverTimestamp(),
    });
  }
}

