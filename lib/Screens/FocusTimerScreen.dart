import 'package:flutter/material.dart';
import 'dart:async';
import 'package:adhdapp/Screens/TimerAnimationScreen.dart'; // Ensure this path is correct

class FocusTimerScreen extends StatefulWidget {
  @override
  _FocusTimerScreenState createState() => _FocusTimerScreenState();
}

class _FocusTimerScreenState extends State<FocusTimerScreen> {
  static const int _defaultFocusDuration =
      25; // Default focus duration in minutes

  Timer? _timer;
  int _focusDuration = _defaultFocusDuration;
  int _remainingSeconds = _defaultFocusDuration * 60;
  bool _isRunning = false;

  void _startTimer() {
    if (_isRunning) return;

    setState(() {
      _isRunning = true;
      _remainingSeconds = _focusDuration * 60;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TimerAnimationScreen(
          duration: _remainingSeconds,
          onStop: _stopTimer,
        ),
      ),
    );

    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (_remainingSeconds <= 0) {
        setState(() {
          _isRunning = false;
        });
        timer.cancel();
        return;
      }
      setState(() {
        _remainingSeconds--;
      });
    });
  }

  void _stopTimer() {
    if (!_isRunning) return;

    _timer?.cancel();
    setState(() {
      _isRunning = false;
    });
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
      _remainingSeconds = _focusDuration * 60;
    });
  }

  String _formatDuration(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secondsRemaining = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secondsRemaining';
  }

  void _showDurationPicker() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 350,
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(width: 40), // Placeholder for spacing
                    Text(
                      'Select Focus Duration',
                      style: TextStyle(fontSize: 24),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Done',
                        style: TextStyle(fontSize: 18, color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListWheelScrollView(
                  itemExtent: 50,
                  children: List.generate(60, (index) {
                    return Center(
                      child: Text(
                        '${index + 1} min',
                        style: TextStyle(fontSize: 30),
                      ),
                    );
                  }),
                  onSelectedItemChanged: (index) {
                    setState(() {
                      _focusDuration = index + 1;
                      if (!_isRunning) {
                        _remainingSeconds = _focusDuration * 60;
                      }
                    });
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _showDurationPicker,
              child: Column(
                children: [
                  Text(
                    'Focus Time',
                    style: TextStyle(fontSize: 24),
                  ),
                  SizedBox(height: 10),
                  Text('Tap the timer below to change',
                      style: TextStyle(fontSize: 16, color: Colors.grey)),
                  SizedBox(height: 20),
                  Text(
                    _formatDuration(_remainingSeconds),
                    style: TextStyle(fontSize: 48),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _startTimer,
                  child: Text('Start'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _stopTimer,
                  child: Text('Stop'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _resetTimer,
                  child: Text('Reset'),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text('Focus Duration: $_focusDuration min'),
          ],
        ),
      ),
    );
  }
}
