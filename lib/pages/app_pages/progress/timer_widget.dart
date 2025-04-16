import 'dart:async';
import 'package:flutter/material.dart';

class TimerWidget extends StatefulWidget {
  final double fontSize;
  const TimerWidget({super.key, required this.fontSize});
  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  late Timer _timer;
  int _elapsedMilliseconds = 0;
  String _timeString = '';

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 10), (Timer t) {
      _updateTime();
    });
  }

  void _updateTime() {
    setState(() {
      _elapsedMilliseconds += 10;
      _timeString = _formatDuration(_elapsedMilliseconds);
    });
  }

  String _formatDuration(int milliseconds) {
    int days = (milliseconds / 86400000).floor();
    int hours = ((milliseconds % 86400000) / 3600000).floor();
    int minutes = ((milliseconds % 3600000) / 60000).floor();
    int seconds = ((milliseconds % 60000) / 1000).floor();
    int milli = milliseconds % 1000;

    String formattedTime = '';

    if (days > 0) {
      formattedTime += '${_twoDigits(days)}:';
    }

    if (hours > 0 || days > 0) {
      formattedTime += '${_twoDigits(hours)}:';
    }

    if (minutes > 0 || hours > 0 || days > 0) {
      formattedTime += '${_twoDigits(minutes)}:';
    }

    formattedTime += '${_twoDigits(seconds)}.${_twoDigitsMilli(milli)}';

    return formattedTime;
  }

  String _twoDigits(int n) {
    return n.toString().padLeft(2, '0');
  }

  String _twoDigitsMilli(int n) {
    return n.toString().padLeft(2, '0').substring(0, 2);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
          _timeString,
          style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        );
  }
}
