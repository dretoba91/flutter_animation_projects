import 'dart:developer';

import 'package:flutter/material.dart';

class BouncingBallAnimation extends StatefulWidget {
  const BouncingBallAnimation({super.key});

  @override
  State<BouncingBallAnimation> createState() => _BouncingBallAnimationState();
}

class _BouncingBallAnimationState extends State<BouncingBallAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> positionAnimation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 2,
      ),
    );

    positionAnimation = Tween<double>(begin: 0, end: 300).animate(controller)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      });

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Bouncing Ball Animation',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w600,
            // color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                'assets/images/bb_court.jpg',
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: AnimatedBuilder(
                animation: controller,
                builder: (context, child) {
                  return Container(
                    width: 100,
                    height: 100,
                    transform: Matrix4.translationValues(
                      0,
                      positionAnimation.value,
                      0,
                    ),
                    child: Image.asset(
                      'assets/images/bb.png',
                    ),
                  );
                }),
          ),
        ),
      ),
    );
  }
}
