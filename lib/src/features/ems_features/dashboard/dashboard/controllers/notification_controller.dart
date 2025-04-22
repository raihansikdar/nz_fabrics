// import 'dart:convert';
// import 'package:nz_ums/src/features/ems_features/dashboard/dashboard/model/notification_model.dart';
// import 'package:get/get.dart';
// import 'package:web_socket_channel/io.dart';
//
//
// class NotificationController extends GetxController {
//   late IOWebSocketChannel channel;
//   NotificationModel? notificationData;
//
//   @override
//   void onInit() {
//     super.onInit();
//     // Establish WebSocket connection
//     connectToWebSocket();
//   }
//
//   void connectToWebSocket() {
//     const String token = 'Token 23a18b30c6c5593749fe6bb9ca717388be4ecc40';
//     final Uri uri = Uri.parse('ws://192.168.68.20:8086/ws/live-notification/');
//
//     // Use IOWebSocketChannel to include headers
//     channel = IOWebSocketChannel.connect(
//       uri,
//       headers: {'Authorization': token},
//     );
//
//     // Listen to the WebSocket stream
//     channel.stream.listen((data) {
//       final Map<String, dynamic> jsonData = jsonDecode(data);
//       notificationData = NotificationModel.fromJson(jsonData);
//       update(); // Call GetX's update method to rebuild the UI
//     });
//   }
//
//   @override
//   void onClose() {
//     channel.sink.close(); // Close the WebSocket connection when controller is destroyed
//     super.onClose();
//   }
// }
// import 'dart:convert';
// import 'package:nz_ums/src/features/ems_features/dashboard/dashboard/model/notification_model.dart';
// import 'package:get/get.dart';
// import 'package:web_socket_channel/io.dart';
//
// class NotificationController extends GetxController {
//   late IOWebSocketChannel channel;
//   NotificationModel? notificationData;
//
//   @override
//   void onInit() {
//     super.onInit();
//     // Establish WebSocket connection
//     connectToWebSocket();
//   }
//
//   void connectToWebSocket() {
//     const String token = 'Token 23a18b30c6c5593749fe6bb9ca717388be4ecc40';
//     final Uri uri = Uri.parse('ws://192.168.68.20:8086/ws/live-notification/');
//
//     // Use IOWebSocketChannel to include headers
//     channel = IOWebSocketChannel.connect(
//       uri,
//       headers: {'Authorization': token},
//     );
//
//     // Listen to the WebSocket stream
//     channel.stream.listen((data) {
//       // Print the raw data received to the terminal
//       print('WebSocket data received: $data');
//
//       // Decode the data and print the decoded data
//       final Map<String, dynamic> jsonData = jsonDecode(data);
//       print('Decoded WebSocket JSON: $jsonData');
//
//       // Assign the decoded data to the model and update the UI
//       notificationData = NotificationModel.fromJson(jsonData);
//       update(); // Call GetX's update method to rebuild the UI
//     }, onError: (error) {
//       // Print any errors that occur
//       print('WebSocket error: $error');
//     }, onDone: () {
//       // Notify when the WebSocket connection is closed
//       print('WebSocket connection closed');
//     });
//   }
//
//   @override
//   void onClose() {
//     // Close the WebSocket connection and notify
//     print('Closing WebSocket connection');
//     channel.sink.close();
//     super.onClose();
//   }
// }
// import 'dart:convert';
// import 'package:nz_ums/src/features/ems_features/dashboard/dashboard/model/notification_model.dart';
// import 'package:get/get.dart';
// import 'package:web_socket_channel/io.dart';
//
// class NotificationController extends GetxController {
//   late IOWebSocketChannel channel;
//   NotificationModel? notificationData;
//
//   @override
//   void onInit() {
//     super.onInit();
//     // Establish WebSocket connection
//     connectToWebSocket();
//   }
//
//   void connectToWebSocket() {
//     const String token = 'Token 23a18b30c6c5593749fe6bb9ca717388be4ecc40';
//     final Uri uri = Uri.parse('ws://192.168.68.20:8086/ws/live-notification/');
//
//     // Use IOWebSocketChannel to include headers
//     channel = IOWebSocketChannel.connect(
//       uri,
//       headers: {'Authorization': token},
//     );
//
//     // Listen to the WebSocket stream
//     channel.stream.listen((data) {
//       // Print the raw data received
//       print('WebSocket data received: $data');
//
//       // Decode the data
//       final Map<String, dynamic> jsonData = jsonDecode(data);
//
//       // Check if the message contains the fields expected in NotificationModel
//       if (jsonData.containsKey('unseen') && jsonData.containsKey('time') && jsonData.containsKey('Notification')) {
//         // If it matches, parse it into the model
//         notificationData = NotificationModel.fromJson(jsonData);
//         print('Decoded WebSocket JSON: $jsonData');
//         update(); // Call GetX's update method to rebuild the UI
//       } else {
//         // Handle other types of messages (like status updates)
//         print('Received a different type of WebSocket message: $jsonData');
//       }
//     }, onError: (error) {
//       // Print any errors that occur
//       print('WebSocket error: $error');
//     }, onDone: () {
//       // Notify when the WebSocket connection is closed
//       print('WebSocket connection closed');
//     });
//   }
//
//   @override
//   void onClose() {
//     channel.sink.close(); // Close the WebSocket connection when controller is destroyed
//     super.onClose();
//   }
// }
