// ignore_for_file: file_names

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quick_bite/enums/Notification_Type.dart';
import 'package:quick_bite/models/Notification_Model.dart';

class NotificationService {
  //============================================================
  // FIRESTORE
  //============================================================

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //============================================================
  // AUTH
  //============================================================

  final FirebaseAuth _auth = FirebaseAuth.instance;

  //============================================================
  // NOTIFICATIONS COLLECTION
  //============================================================

  CollectionReference<Map<String, dynamic>> get _notificationsCollection =>
      _firestore.collection('customer_notifications');

  //============================================================
  // CURRENT USER
  //============================================================

  User? get _currentUser => _auth.currentUser;

  //============================================================
  // GET CUSTOMER NOTIFICATIONS
  //============================================================

  Stream<List<NotificationModel>> getCustomerNotifications() {
    final user = _currentUser;

    if (user == null) {
      return Stream.value(<NotificationModel>[]);
    }

    //==========================================================
    // ALL CUSTOMERS
    //==========================================================

    final allCustomersStream = _notificationsCollection
        .where(
          'target',
          isEqualTo: 'all_customers',
        )
        .snapshots();

    //==========================================================
    // SPECIFIC CUSTOMER
    //==========================================================

    final specificCustomerStream = _notificationsCollection
        .where(
          'target',
          isEqualTo: 'specific_customer',
        )
        .where(
          'targetId',
          isEqualTo: user.uid,
        )
        .snapshots();

    //==========================================================
    // COMBINE BOTH STREAMS
    //==========================================================

    return _combineNotificationStreams(
      allCustomersStream,
      specificCustomerStream,
      user.uid,
    );
  }

  //============================================================
  // COMBINE NOTIFICATION STREAMS
  //============================================================

  Stream<List<NotificationModel>> _combineNotificationStreams(
    Stream<QuerySnapshot<Map<String, dynamic>>> allCustomersStream,
    Stream<QuerySnapshot<Map<String, dynamic>>> specificCustomerStream,
    String userId,
  ) {
    final controller = StreamController<List<NotificationModel>>();

    QuerySnapshot<Map<String, dynamic>>? allCustomersSnapshot;

    QuerySnapshot<Map<String, dynamic>>? specificCustomerSnapshot;

    StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
        allSubscription;

    StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
        specificSubscription;

    bool emitting = false;

    //==========================================================
    // EMIT COMBINED NOTIFICATIONS
    //==========================================================

    Future<void> emitNotifications() async {
      //==========================================================
      // IMPORTANT:
      //
      // WAIT UNTIL BOTH FIRESTORE STREAMS HAVE RETURNED
      // THEIR FIRST SNAPSHOT.
      //
      // This prevents:
      //
      // Empty state
      //       ↓
      // specific notifications arrive later
      //
      //==========================================================

      if (allCustomersSnapshot == null ||
          specificCustomerSnapshot == null) {
        return;
      }

      // Prevent overlapping rebuilds when both
      // Firestore listeners update almost simultaneously.
      if (emitting) {
        return;
      }

      emitting = true;

      try {
        //======================================================
        // COMBINE DOCUMENTS
        //======================================================

        final Map<String, DocumentSnapshot<Map<String, dynamic>>>
            documents = {};

        //======================================================
        // ALL CUSTOMERS
        //======================================================

        for (final document in allCustomersSnapshot!.docs) {
          documents[document.id] = document;
        }

        //======================================================
        // SPECIFIC CUSTOMER
        //======================================================

        for (final document in specificCustomerSnapshot!.docs) {
          documents[document.id] = document;
        }

        //======================================================
        // LOAD READ STATUS IN PARALLEL
        //======================================================

        final notificationDocuments =
            documents.values.toList(growable: false);

        final readStatusResults = await Future.wait(
          notificationDocuments.map(
            (document) => _isNotificationRead(
              notificationId: document.id,
              userId: userId,
            ),
          ),
        );

        //======================================================
        // BUILD NOTIFICATIONS
        //======================================================

        final notifications = List<NotificationModel>.generate(
          notificationDocuments.length,
          (index) {
            return _notificationFromFirestore(
              notificationDocuments[index],
              isRead: readStatusResults[index],
            );
          },
          growable: false,
        );

        //======================================================
        // SORT NEWEST FIRST
        //======================================================

        notifications.sort(
          (a, b) => b.createdAt.compareTo(a.createdAt),
        );

        //======================================================
        // EMIT
        //======================================================

        if (!controller.isClosed) {
          controller.add(notifications);
        }
      } catch (error, stackTrace) {
        if (!controller.isClosed) {
          controller.addError(
            error,
            stackTrace,
          );
        }
      } finally {
        emitting = false;
      }
    }

    //==========================================================
    // ALL CUSTOMERS LISTENER
    //==========================================================

    allSubscription = allCustomersStream.listen(
      (snapshot) {
        allCustomersSnapshot = snapshot;

        emitNotifications();
      },
      onError: (error, stackTrace) {
        if (!controller.isClosed) {
          controller.addError(
            error,
            stackTrace,
          );
        }
      },
    );

    //==========================================================
    // SPECIFIC CUSTOMER LISTENER
    //==========================================================

    specificSubscription = specificCustomerStream.listen(
      (snapshot) {
        specificCustomerSnapshot = snapshot;

        emitNotifications();
      },
      onError: (error, stackTrace) {
        if (!controller.isClosed) {
          controller.addError(
            error,
            stackTrace,
          );
        }
      },
    );

    //==========================================================
    // CLEANUP
    //==========================================================

    controller.onCancel = () async {
      await allSubscription?.cancel();
      await specificSubscription?.cancel();

      if (!controller.isClosed) {
        await controller.close();
      }
    };

    return controller.stream;
  }

  //============================================================
  // CHECK CUSTOMER READ STATUS
  //============================================================

  Future<bool> _isNotificationRead({
    required String notificationId,
    required String userId,
  }) async {
    final document = await _notificationsCollection
        .doc(notificationId)
        .collection('read_status')
        .doc(userId)
        .get();

    return document.exists;
  }

  //============================================================
  // CONVERT FIRESTORE DOCUMENT
  //============================================================

  NotificationModel _notificationFromFirestore(
    DocumentSnapshot<Map<String, dynamic>> document, {
    required bool isRead,
  }) {
    final data = document.data() ?? {};

    return NotificationModel(
      id: document.id,
      title: data['title']?.toString() ?? '',
      message: data['message']?.toString() ?? '',
      type: _notificationTypeFromString(
        data['type']?.toString(),
      ),
      target: data['target']?.toString(),
      targetId: data['targetId']?.toString(),
      orderId: data['orderId']?.toString(),
      isRead: isRead,
      createdAt: _dateFromFirestore(
        data['createdAt'],
      ),
    );
  }

  //============================================================
  // NOTIFICATION TYPE
  //============================================================

  NotificationType _notificationTypeFromString(
    String? type,
  ) {
    switch (type) {
      case 'order':
        return NotificationType.order;

      case 'deal':
        return NotificationType.deal;

      case 'offer':
        return NotificationType.offer;

      case 'review':
        return NotificationType.review;

      default:
        return NotificationType.general;
    }
  }

  //============================================================
  // DATE CONVERTER
  //============================================================

  DateTime _dateFromFirestore(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is DateTime) {
      return value;
    }

    return DateTime.now();
  }

  //============================================================
  // MARK ONE AS READ
  //============================================================

  Future<void> markAsRead(
    String notificationId,
  ) async {
    final user = _currentUser;

    if (user == null) {
      return;
    }

    await _notificationsCollection
        .doc(notificationId)
        .collection('read_status')
        .doc(user.uid)
        .set({
      'isRead': true,
      'readAt': FieldValue.serverTimestamp(),
    });
  }

  //============================================================
  // MARK ALL AS READ
  //============================================================

  Future<void> markAllAsRead() async {
    final user = _currentUser;

    if (user == null) {
      return;
    }

    final snapshots = await Future.wait([
      _notificationsCollection
          .where(
            'target',
            isEqualTo: 'all_customers',
          )
          .get(),

      _notificationsCollection
          .where(
            'target',
            isEqualTo: 'specific_customer',
          )
          .where(
            'targetId',
            isEqualTo: user.uid,
          )
          .get(),
    ]);

    //==========================================================
    // COMBINE DOCUMENTS
    //==========================================================

    final Map<String, DocumentSnapshot<Map<String, dynamic>>>
        documents = {};

    for (final snapshot in snapshots) {
      for (final document in snapshot.docs) {
        documents[document.id] = document;
      }
    }

    if (documents.isEmpty) {
      return;
    }

    //==========================================================
    // FIRESTORE BATCH
    //==========================================================

    final batch = _firestore.batch();

    for (final document in documents.values) {
      final readStatusReference = document.reference
          .collection('read_status')
          .doc(user.uid);

      batch.set(
        readStatusReference,
        {
          'isRead': true,
          'readAt': FieldValue.serverTimestamp(),
        },
      );
    }

    await batch.commit();
  }
}