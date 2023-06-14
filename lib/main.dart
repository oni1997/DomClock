import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(DomClockApp());
}

class DomClockApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dom Clock',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DomClockScreen(),
    );
  }
}

class DomClockScreen extends StatefulWidget {
  @override
  _DomClockScreenState createState() => _DomClockScreenState();
}

class _DomClockScreenState extends State<DomClockScreen> {
  Timer? _timer;
  String _currentTime = '';

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {
        _currentTime =
            '${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}:${DateTime.now().second.toString().padLeft(2, '0')}';
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dom Clock'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'The Time Now',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Text(
              _currentTime,
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
