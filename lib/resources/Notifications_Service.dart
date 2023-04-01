// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:AliStore/Dashbord/messageAcitvity.dart';

// class NotificationsService{
//   static final FlutterLocalNotificationsPlugin _localNotificationsPlugin=FlutterLocalNotificationsPlugin();


//   static void initialze(context){
//     final InitializationSettings initializationSettings=InitializationSettings(
//         android:AndroidInitializationSettings("@mipmap/ic_launcher"),
//             iOS: IOSInitializationSettings(defaultPresentAlert: true),
//       linux: LinuxInitializationSettings(defaultSuppressSound: true,defaultActionName: " ")
//     );
//     _localNotificationsPlugin.initialize(initializationSettings,onSelectNotification: (String? id)async{
//     if(id!=null){
//       Navigator.of(context).push(
//           MaterialPageRoute(
//             builder: (context) => message(
//               Name:"",
//               Image: "",
//               Uid: "${id}",isGroup: false,VIP: false,
//             ),
//           ));
//     }
//     });
//   }

//   static void display(RemoteMessage message)async{
//     try {
//       int id=DateTime.now().millisecondsSinceEpoch ~/1000;
//       final NotificationDetails notificationDetails=NotificationDetails(
//           android: AndroidNotificationDetails("channelId", "")
//       );
//         await  _localNotificationsPlugin.show(id, message.notification!.title, message.notification!.body, notificationDetails,
//         payload: message.data["id"]);
//     } on Exception catch (e) {
//      print(e);
//     }
//   }
// }