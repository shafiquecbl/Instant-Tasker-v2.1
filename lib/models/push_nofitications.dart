import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

final String serverToken =
    'AAAAYLRccmc:APA91bFJPMSX1e0j-D2yf3Cc9UJvmiBINew3hOo4wsybG4hHdlJ_GFdnpxomcixSYh64_C1_-K0AQFu-QSlhzpDMb4UZpbntyej-F9SfPfOS4aqEwO7-6Ytvl_B9EsYJvFjZkhXB8xv-';

sendAndRetrieveMessage(
    {@required String token,
    @required String title,
    @required String body}) async {
  await http.post(
    Uri.parse('https://fcm.googleapis.com/fcm/send'),
    headers: <String, String>{
      'Content-Type': 'application/json',
      'Authorization': 'key=$serverToken',
    },
    body: jsonEncode(
      <String, dynamic>{
        'notification': <String, dynamic>{'body': body, 'title': title},
        'priority': 'high',
        'data': <String, dynamic>{
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          'id': '1',
          'status': 'done'
        },
        'to': token,
      },
    ),
  );
}
