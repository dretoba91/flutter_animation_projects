import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MultipleAnimation extends StatefulWidget {
  const MultipleAnimation({super.key});

  @override
  State<MultipleAnimation> createState() => _MultipleAnimationState();
}

class _MultipleAnimationState extends State<MultipleAnimation>
    with SingleTickerProviderStateMixin {
  double _progress = 0.0;
  bool _isAnimating = false;
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;
  late Animation<double> _linearProgressAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 20,
      ),
    );

    // for circular color animation
    final colors = [
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.yellow,
      Colors.purple,
    ];

    _colorAnimation = TweenSequence<Color?>([
      for (final color in colors)
        TweenSequenceItem(
          tween: ColorTween(
              begin: color,
              end: colors[(colors.indexOf(color) + 1) % colors.length]),
          weight: 1,
        )
    ]).animate(_controller)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          Future.delayed(const Duration(seconds: 2), () {
            _controller.reset();
          });
          //
          // _controller.forward();
        }
      });

    // for linear prgress indicator animation

    _linearProgressAnimation =
        Tween<double>(begin: 0, end: 100).animate(_controller)
          ..addListener(() {
            setState(() {});
          })
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              setState(() {
                _isAnimating = false;
              });
            }
          });
  }

  // void _toggleAnimation() {
  //   setState(() {
  //     _isAnimating = !_isAnimating;
  //     if (_isAnimating) {
  //       _controller.forward();
  //     } else {
  //       _controller.stop();
  //     }
  //   });
  // }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Multiple Animations',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w600,
            // color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Padding(
                padding: const EdgeInsets.only(
                    top: 20, right: 30, left: 30, bottom: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _colorAnimation.value,
                      ),
                    ),
                    LinearProgressIndicator(
                      value: _linearProgressAnimation.value / 100,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _linearProgressAnimation.value >= 100
                            ? Colors.green
                            : Colors.blue,
                      ),
                      backgroundColor: Colors.grey[300],
                      minHeight: 20,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _linearProgressAnimation.isCompleted &&
                              _linearProgressAnimation.value == 100
                          ? 'Done'
                          : '${_linearProgressAnimation.value.toInt()}%',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        _controller.forward();
                      },
                      child: const Text(
                        // _isAnimating ? 'Animating...' : 'Start Animation',
                        'Animate',
                      ),
                    )
                  ],
                ),
              );
            }),
      ),
    );
  }
}
