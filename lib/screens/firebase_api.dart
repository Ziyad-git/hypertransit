import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:hypertransit/screens/login_screen.dart';
import 'package:intl/message_format.dart';

class FirebaseApi {
  // Firebase Messaging instance
  final _firebaseMessaging = FirebaseMessaging.instance;

  //function to intialize notification
  Future<void> initNotification() async {
    await _firebaseMessaging.requestPermission();
  
  final fCMToken = await _firebaseMessaging.getToken();

  print('Token: $fCMToken');

  initPushNotification();
  } 


  void handleMessage(RemoteMessage?message){
  //if the message is null do nothing.
  if (message == null) {
    return;
  }
  

  //navigate to new scrren when message is received and user ttap notification
  // navigatorKey.currentState?.pushNamed('/notification_screen', arguments: message);
  
  }
  //function to initialze background settings
  Future initPushNotification() async {
    //handle notification if app was terminated and now opened
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage );

  //attach event listerners for when a notification open the app
  FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  }
}