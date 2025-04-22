import 'dart:convert';
import 'dart:developer';
import 'package:nz_fabrics/src/features/notification/local_notification_service/local_notification_service.dart';
import 'package:get/get.dart';
import 'package:nz_fabrics/src/shared_preferences/auth_utility_controller.dart';
import 'package:web_socket_channel/io.dart';


class NotificationController extends GetxController {
  final String url = "ws://192.168.68.60:8040/ws/live-notification/";
  final String token = "Token ${AuthUtilityController.accessToken}";

  // Variables to hold the notification message and unseen count
  String notificationMessage = "";
  int unseenCount = 0;

  late IOWebSocketChannel channel;
  final NotificationService notificationService = NotificationService(); // Inject NotificationService

  @override
  void onInit() {
    super.onInit();
    connectWebSocket();
  }

  void connectWebSocket() {
    channel = IOWebSocketChannel.connect(
      Uri.parse(url),
      headers: {
        'Authorization': token,
      },
    );

    // Listen for messages from WebSocket
    channel.stream.listen((message) {
      final data = json.decode(message);
      notificationMessage = data['Notification'] ?? '';
      unseenCount = data['unseen'] ?? 0;
      update(); // Update the UI

      // Trigger a local notification automatically

      if(notificationMessage.isNotEmpty){
        notificationService.showNotification(
          title: 'New Notification',
          body: notificationMessage,
        );
      }

    }, onError: (error) {
      log("WebSocket error: $error");
    }, onDone: () {
      log("WebSocket closed");
    });
  }

  @override
  void onClose() {
    channel.sink.close();
    super.onClose();
  }
}
