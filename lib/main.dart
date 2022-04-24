import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
//import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screen/helper/constant.dart';
import 'screen/updateScreen/forceUpdate.dart';
import 'service/authservice.dart';
import 'package:get/get.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {

}

 AndroidNotificationChannel channel;

 FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final prefs = await SharedPreferences.getInstance();


  String fcm = await FirebaseMessaging.instance.getToken();
  if(prefs.isBlank){
    prefs.setString("fcm",fcm);

    if(FirebaseAuth.instance.currentUser.isBlank){
      prefs.setString("fcm",fcm);
      FirebaseFirestore.instance.collection("user_details").doc(FirebaseAuth.instance.currentUser.phoneNumber.replaceAll("+91", "")).update({
        "fcm_token":fcm
      });
    }  }
  else{

    String prefToken =await prefs.getString("fcm");
    if(prefToken != fcm){
      prefs.setString("fcm",fcm);

      if(FirebaseAuth.instance.currentUser.isBlank){
        prefs.setString("fcm",fcm);
        FirebaseFirestore.instance.collection("user_details").doc(FirebaseAuth.instance.currentUser.phoneNumber.replaceAll("+91", "")).update({
          "fcm_token":fcm
        });
      }
    }
  }

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  if (!kIsWeb) {
    channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title// description
      importance: Importance.high,
    );
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );


  }
  runApp(GetMaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      unselectedWidgetColor:Colors.white,
      scaffoldBackgroundColor: Constants().appBackGroundColor,
      backgroundColor:Constants().appBackGroundColor ,
      primaryColor: Constants().appBackGroundColor,
      appBarTheme: AppBarTheme(backgroundColor: Constants().appBackGroundColor),
      textTheme: GoogleFonts.latoTextTheme(),
    ),
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
 /* FirebaseMessaging firebaseMessaging;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();*/


  var version = "9";
  @override
  void initState() {
    super.initState();

    fcm();
    FirebaseFirestore.instance
        .collection("version")
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((element) {

        if (version == element["version"].toString()) {

          Get.offAll(AuthService().handleAuth());
          /*Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => AuthService().handleAuth()));*/
          // return AuthService().handleAuth();
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ForceUpdateView(
                      element["update"].toString(),
                      element['force'].toString(),
                      element['maintance'].toString())));
        }
      });
    });

  }


  fcm()async{
    String token= await FirebaseMessaging.instance.getAPNSToken();

  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Constants().appBackGroundColor,
        child: Image.asset("assets/icons/icon.png"),
      ),
    );
  }
}



