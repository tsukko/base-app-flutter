import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class DebugFireBaseFcm extends StatefulWidget {
  @override
  _DebugFireBaseFcmState createState() => _DebugFireBaseFcmState();
}

class _DebugFireBaseFcmState extends State<DebugFireBaseFcm> {
  final FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    if (Platform.isIOS) iOS_Permission();
    _firebaseMessaging.getToken().then((token) {
      print("tokentoken: $token");
    });
    // ここで通知受信時の挙動を設定しています。
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        sampleDialog(context, "onMessage");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        sampleDialog(context, "onLaunch");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        sampleDialog(context, "onResume");
      },
    );
  }

  void iOS_Permission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("debug_firebase_fcm"),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(children: <Widget>[
      RaisedButton(
        child: const Text('検索',
            style: TextStyle(fontSize: 18, color: Colors.white)),
        color: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        onPressed: () {
          _onChanged1();
        },
      ),
      RaisedButton(
        child: const Text('検索',
            style: TextStyle(fontSize: 18, color: Colors.white)),
        color: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        onPressed: () {
          _onChanged1();
        },
      ),
    ]);
  }

//  _buildSignOutDialogAndroid(context, "");
  Widget sampleDialog(BuildContext context, String message) {
    return AlertDialog(content: Text(message), actions: <Widget>[
      FlatButton(
        child: const Text('CLOSE'),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    ]);
  }

  Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) {
    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
    }

    // Or do other work.
  }

  void _onChanged1() {
    _firebaseMessaging.subscribeToTopic("/topics/gsacademy");
    sampleDialog(context, '通知の受信を開始します');
  }
}
