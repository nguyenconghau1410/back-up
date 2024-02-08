import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> with SingleTickerProviderStateMixin {
  double _maxTime = 8.0;
  late AnimationController _animationController;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..addListener(() {
      setState(() {
        if(_animationController.value == 1.0) {
          // Get.back();
        }
      });
    });
    _animationController.forward();

  }

  @override
  Widget build(BuildContext context) {
    double _currentTime = _animationController.value * _maxTime;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          const SizedBox(height: 8,),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              thumbShape: SliderComponentShape.noThumb,
            ),
            child: Slider(
              activeColor: Colors.grey,
              inactiveColor: Colors.white,
              thumbColor: Colors.white,
              value: _currentTime,
              min: 0,
              max: _maxTime,
              onChanged: (value) {},
            ),
          ),

        ],
      )
    );
  }
  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }
}
