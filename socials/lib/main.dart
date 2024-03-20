import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socials/firebase/messaging_service.dart';
import 'package:socials/services/chat_controller.dart';
import 'package:socials/shared_preferences/local_storage.dart';
import 'package:socials/utils/notification_service.dart';
import 'package:socials/views/login_screen.dart';
import 'package:socials/views/menu/dashboard.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  NotificationService.initializeNotification();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Social Networking",
      theme: ThemeData(
        primarySwatch: Colors.blue
      ),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    Future.delayed(
        const Duration(seconds: 3),
            () async {
              String? email = await LocalStorage.getUser();
              if(email == null) {
                Get.to(() => const LoginScreen());
              }
              else {
                Get.to(() => const DashBoard());
              }
        }
    );
    return Scaffold(
      backgroundColor: const Color(0xFF2FA2B9),
      body: Center(
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(50),
              bottomLeft: Radius.circular(50),
              bottomRight: Radius.circular(20)
          ),
          child: Image.asset(
            "images/znet.jpg",
            width: 196,
            height: 209,
          ),
        ),
      ),
    );
  }
}

