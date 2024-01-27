
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:social/api/api_service.dart';
import 'package:social/connect/connecting_websocket.dart';
import 'package:social/utils/constant.dart';
import 'package:social/views/menu/dashboard.dart';
import 'package:social/views/register_screen.dart';

import '../models/user.dart';
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var isObsecure = true.obs;

  void login() async {
    User user = User.auth(emailController.text.trim(),
                          passwordController.text.trim());
    final auth = await APIService.login(user);
    if(auth != null) {
      Get.snackbar(
        'Đăng nhập thành công',
        "Let's get started!",
        duration: const Duration(seconds: 3),
        snackPosition: SnackPosition.TOP,
        colorText: Colors.white,
        backgroundColor: Colors.black,
      );
      Utils.user = auth;
      Future.delayed(const Duration(seconds: 3), () {
        Get.off(() => const DashBoard());
      });
    }
    else {
      Get.snackbar(
          'Đăng nhập thất bại',
          'Email hoặc mật khẩu không chính xác',
          duration: const Duration(seconds: 3),
          snackPosition: SnackPosition.TOP,
          colorText: Colors.white,
          backgroundColor: Colors.black
      );
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 285,
              child: Image.asset(
                "images/login.jpg",
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: const BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.all(
                        Radius.circular(60)
                    ),
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 8,
                          color: Colors.black26,
                          offset: Offset(0, -3)
                      ),
                    ]
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(30, 30, 30, 8),
                  child: Column(
                    children: [
                      Form(
                        key: formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: emailController,
                              validator: (val) => val == "" ? "Please write email" : null,
                              decoration: InputDecoration(
                                prefixIcon: const Icon(
                                  Icons.email,
                                  color: Colors.black,
                                ),
                                hintText: "email...",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: const BorderSide(
                                      color: Colors.white60,
                                    )
                                ),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: const BorderSide(
                                      color: Colors.white60,
                                    )
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: const BorderSide(
                                      color: Colors.white60,
                                    )
                                ),
                                disabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: const BorderSide(
                                      color: Colors.white60,
                                    )
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 6,
                                ),
                                fillColor: Colors.white,
                                filled: true,
                              ),
                            ),
                            const SizedBox(height: 18,),
                            Obx(
                                    () => TextFormField(
                                  controller: passwordController,
                                  obscureText: isObsecure.value,
                                  validator: (val) => val == "" ? "Please write password" : null,
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(
                                      Icons.vpn_key_sharp,
                                      color: Colors.black,
                                    ),
                                    suffixIcon: Obx(
                                            () => GestureDetector(
                                          onTap: () {
                                            isObsecure.value = !isObsecure.value;
                                          },
                                          child: Icon(
                                            isObsecure.value ? Icons.visibility_off : Icons.visibility,
                                            color: Colors.black,
                                          ),
                                        )
                                    ),
                                    hintText: "password...",
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: const BorderSide(
                                          color: Colors.white60,
                                        )
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: const BorderSide(
                                          color: Colors.white60,
                                        )
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: const BorderSide(
                                          color: Colors.white60,
                                        )
                                    ),
                                    disabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(30),
                                        borderSide: const BorderSide(
                                          color: Colors.white60,
                                        )
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 6,
                                    ),
                                    fillColor: Colors.white,
                                    filled: true,
                                  ),
                                )
                            ),
                            const SizedBox(height: 18,),
                            Material(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(30),
                              child: InkWell(
                                onTap: () {
                                  login();
                                },
                                borderRadius: BorderRadius.circular(30),
                                child: const Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 28
                                  ),
                                  child: Text(
                                    "Login",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 16,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't have an Account ?",
                            style: TextStyle(color: Colors.white),
                          ),
                          TextButton(
                            onPressed: () {
                              Get.to(() => const RegisterScreen());
                            },
                            child: const Text("Register Here", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                          ),
                        ],
                      ),
                      const Text("Or", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Are you an Admin ?",
                            style: TextStyle(color: Colors.white),
                          ),
                          TextButton(
                            onPressed: () {

                            },
                            child: const Text("Click Here", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
