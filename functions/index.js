const { setGlobalOptions } = require("firebase-functions");
const { onDocumentCreated } =
  require("firebase-functions/v2/firestore");
const logger = require("firebase-functions/logger");

const { initializeApp } =
  require("firebase-admin/app");

const {
  getFirestore,
  FieldValue,
} = require("firebase-admin/firestore");

const { getMessaging } =
  require("firebase-admin/messaging");

initializeApp();

setGlobalOptions({
  maxInstances: 10,
});


// ==============================================================
// 1. NEW ORDER → ADMIN NOTIFICATION
// ==============================================================

exports.createAdminNotificationOnNewOrder =
  onDocumentCreated(
    "orders/{orderId}",
    async (event) => {
      const snapshot = event.data;

      if (!snapshot) {
        logger.error(
          "No order snapshot received.",
        );

        return;
      }

      const orderData = snapshot.data();
      const orderId = event.params.orderId;

      const db = getFirestore();

      // ======================================================
      // CHECK APP SETTINGS
      // ======================================================

      let newOrderNotifications = true;

      try {
        const settingsSnapshot =
          await db
            .collection("settings")
            .doc("restaurant")
            .get();

        if (settingsSnapshot.exists) {
          const settings =
            settingsSnapshot.data() || {};

          newOrderNotifications =
            settings["newOrderNotifications"] === true;
        }

        logger.info(
          "New order notifications setting: " +
          newOrderNotifications,
        );
      } catch (error) {
        logger.error(
          "Failed to read app settings: " +
          error,
        );

        // ====================================================
        // FAIL SAFE
        // ====================================================
        //
        // If settings cannot be read, we keep the
        // notification enabled so that important
        // new-order notifications are not silently lost.
        //

        newOrderNotifications = true;
      }

      // ======================================================
      // NOTIFICATIONS DISABLED
      // ======================================================

      if (!newOrderNotifications) {
        logger.info(
          "New order notification disabled. " +
          "Skipping notification for order #" +
          orderId,
        );

        return;
      }

      // ======================================================
      // CREATE ADMIN NOTIFICATION
      // ======================================================

      await db
        .collection("admin_notifications")
        .add({
          title: "New Order",

          message:
            "Order #" +
            orderId +
            " has been placed.",

          type: "order",

          source: "customer",

          target: "order",

          targetId: orderId,

          orderId: orderId,

          userId:
            orderData["userId"] || null,

          isRead: false,

          createdAt:
            FieldValue.serverTimestamp(),

          sentAt: null,
        });

      // ======================================================
      // LOG
      // ======================================================

      logger.info(
        "Admin notification created for order #" +
        orderId,
      );
    },
  );


// ==============================================================
// 2. CUSTOMER NOTIFICATION → FCM PUSH
// ==============================================================

exports.sendCustomerNotification =
  onDocumentCreated(
    "customer_notifications/{notificationId}",
    async (event) => {
      const snapshot = event.data;

      if (!snapshot) {
        logger.error(
          "No customer notification snapshot received.",
        );

        return;
      }

      const notification = snapshot.data();

      const notificationId =
        event.params.notificationId;

      const title =
        notification["title"] != null ?
          notification["title"].toString() :
          "Quick Bite";

      const message =
        notification["message"] != null ?
          notification["message"].toString() :
          "";

      const target =
        notification["target"] != null ?
          notification["target"].toString() :
          "";

      const targetId =
        notification["targetId"] != null ?
          notification["targetId"].toString() :
          null;

      const db = getFirestore();

      logger.info(
        "Processing customer notification #" +
        notificationId +
        " | target: " +
        target,
      );

      // ====================================================
      // FIND CUSTOMER USERS
      // ====================================================

      let userDocuments = [];

      // ====================================================
      // SPECIFIC CUSTOMER
      // ====================================================

      if (target === "specific_customer") {
        if (!targetId) {
          logger.error(
            "Specific customer notification has no targetId.",
          );

          return;
        }

        const userDocument =
          await db
            .collection("users")
            .doc(targetId)
            .get();

        if (!userDocument.exists) {
          logger.error(
            "Customer not found: " +
            targetId,
          );

          return;
        }

        userDocuments.push(
          userDocument,
        );
      } else if (target === "all_customers") {
        // ==================================================
        // ALL CUSTOMERS
        // ==================================================

        const usersSnapshot =
          await db
            .collection("users")
            .get();

        userDocuments =
          usersSnapshot.docs;
      } else {
        // ==================================================
        // UNKNOWN TARGET
        // ==================================================

        logger.warn(
          "Unsupported notification target: " +
          target,
        );

        return;
      }

      // ====================================================
      // COLLECT FCM TOKENS
      // ====================================================

      const tokens = [];

      for (const userDocument of userDocuments) {
        const userData =
          userDocument.data();

        const userTokens =
          userData["fcmTokens"];

        if (!Array.isArray(userTokens)) {
          continue;
        }

        for (const token of userTokens) {
          if (
            typeof token === "string" &&
            token.trim().length > 0
          ) {
            tokens.push(token);
          }
        }
      }

      // ====================================================
      // REMOVE DUPLICATE TOKENS
      // ====================================================

      const uniqueTokens =
        [...new Set(tokens)];

      if (uniqueTokens.length === 0) {
        logger.warn(
          "No FCM tokens found for notification #" +
          notificationId,
        );

        return;
      }

      logger.info(
        "Found " +
        uniqueTokens.length +
        " FCM token(s).",
      );

      // ====================================================
      // SEND FCM
      // ====================================================

      const messaging =
        getMessaging();

      const batchSize = 500;

      for (
        let start = 0;
        start < uniqueTokens.length;
        start += batchSize
      ) {
        const tokenBatch =
          uniqueTokens.slice(
            start,
            start + batchSize,
          );

        const response =
          await messaging.sendEachForMulticast({
            tokens: tokenBatch,

            notification: {
              title: title,
              body: message,
            },

            data: {
              notificationId:
                notificationId,

              type:
                notification["type"] != null ?
                  notification["type"].toString() :
                  "general",

              target:
                target,

              targetId:
                targetId || "",

              orderId:
                notification["orderId"] != null ?
                  notification["orderId"].toString() :
                  "",
            },

            android: {
              priority: "high",

              notification: {
                channelId:
                  "quick_bite_notifications",

                sound: "default",
              },
            },
          });

        logger.info(
          "FCM batch sent. " +
          "Success: " +
          response.successCount +
          " | Failure: " +
          response.failureCount,
        );

        // ================================================
        // CLEAN INVALID TOKENS
        // ================================================

        for (
          let i = 0;
          i < response.responses.length;
          i++
        ) {
          const sendResponse =
            response.responses[i];

          if (sendResponse.success) {
            continue;
          }

          const errorCode =
            sendResponse.error != null ?
              sendResponse.error.code :
              null;

          const invalidToken =
            tokenBatch[i];

          if (
            errorCode ===
            "messaging/registration-token-not-registered" ||
            errorCode ===
            "messaging/invalid-registration-token"
          ) {
            logger.warn(
              "Removing invalid FCM token.",
            );

            for (
              const userDocument of userDocuments
            ) {
              const userData =
                userDocument.data();

              const userTokens =
                userData["fcmTokens"];

              if (!Array.isArray(userTokens)) {
                continue;
              }

              if (
                userTokens.includes(
                  invalidToken,
                )
              ) {
                await userDocument.ref.update({
                  fcmTokens:
                    FieldValue.arrayRemove([
                      invalidToken,
                    ]),
                });
              }
            }
          } else {
            logger.error(
              "FCM send failed: " +
              errorCode,
            );
          }
        }
      }

      // ====================================================
      // UPDATE SENT TIME
      // ====================================================

      await snapshot.ref.update({
        sentAt:
          FieldValue.serverTimestamp(),
      });

      logger.info(
        "Customer notification #" +
        notificationId +
        " processed successfully.",
      );
    },
  );