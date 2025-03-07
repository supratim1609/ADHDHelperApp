import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class TimerAnimationScreen extends StatefulWidget {
  final int duration;
  final VoidCallback onStop;

  TimerAnimationScreen({required this.duration, required this.onStop});

  @override
  _TimerAnimationScreenState createState() => _TimerAnimationScreenState();
}

class _TimerAnimationScreenState extends State<TimerAnimationScreen>
    with SingleTickerProviderStateMixin {
  late Timer _timer;
  late int _remainingSeconds;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = widget.duration;
    _controller = AnimationController(
      duration: Duration(seconds: widget.duration),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));

    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (_remainingSeconds <= 0) {
        timer.cancel();
        _controller.stop();
        widget.onStop(); // Call the callback when the timer ends
        Navigator.pop(context); // Go back to the previous screen
      } else {
        setState(() {
          _remainingSeconds--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _controller.dispose();
    super.dispose();
  }

  String _formatDuration(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secondsRemaining = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secondsRemaining';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return CustomPaint(
                  size: Size(250, 250),
                  painter: ProgressPainter(
                    progress: _animation.value,
                    color: Colors.green,
                    backgroundColor: Colors.blueGrey[900]!,
                  ),
                );
              },
            ),
            Center(
              child: Text(
                _formatDuration(_remainingSeconds),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Positioned(
              bottom: 40,
              child: ElevatedButton(
                onPressed: () {
                  _timer.cancel();
                  _controller.stop();
                  widget.onStop();
                  Navigator.pop(context);
                },
                child: Text('Stop'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProgressPainter extends CustomPainter {
  final double progress;
  final Color color;
  final Color backgroundColor;

  ProgressPainter({
    required this.progress,
    required this.color,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paintBackground = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20.0
      ..strokeCap = StrokeCap.round;

    final Paint paintProgress = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20.0
      ..strokeCap = StrokeCap.round;

    final double radius = size.width / 2;
    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);

    canvas.drawArc(rect, -pi / 2, 2 * pi, false, paintBackground);
    canvas.drawArc(rect, -pi / 2, 2 * pi * progress, false, paintProgress);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
