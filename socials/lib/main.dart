import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:socials/shared_preferences/local_storage.dart';
import 'package:socials/views/login_screen.dart';
import 'package:socials/views/menu/dashboard.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
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
      home: FutureBuilder(
        future: LocalStorage.getUser(),
        builder: (context, snapshot) {
          final data = snapshot.data;
          if(snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(),);
          }
          else if(snapshot.hasError) {
            return const Center(child: CircularProgressIndicator(),);
          }
          else {
            if(data == null) {
              return const LoginScreen();
            }
            else {
              return const DashBoard();
            }
          }
        },
      ),
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
            () {
          Get.to(() => LoginScreen());
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
            "images/image1.jpg",
            width: 196,
            height: 209,
          ),
        ),
      ),
    );
  }
}

