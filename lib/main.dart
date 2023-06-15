import 'dart:async';
import 'package:flutter/material.dart';


void main() {
  runApp(DomClockApp());
}

class DomClockApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
  String _alarmTime = '';
  int _selectedIndex = 0;

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
        DateTime now = DateTime.now();
        _currentTime =
            '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';

        if (_alarmTime.isNotEmpty && _alarmTime == _currentTime) {
          _showAlarmDialog();
          _stopTimer();
        }
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> _showAlarmDialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alarm'),
          content: Text('Time to wake up!'),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _setAlarmTime() async {
    TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (selectedTime != null) {
      setState(() {
        _alarmTime =
            '${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}:00';
      });
    }
  }

  void _cancelAlarm() {
    setState(() {
      _alarmTime = '';
    });
  }

  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildClockScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Current Time',
            style: TextStyle(fontSize: 24),
          ),
          SizedBox(height: 20),
          Text(
            _currentTime,
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildAlarmScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Alarm',
            style: TextStyle(fontSize: 24),
          ),
          SizedBox(height: 20),
          Text(
            _alarmTime.isNotEmpty ? '$_alarmTime' : 'No alarm set',
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 40),
          TextButton(
            child: Text(
              _alarmTime.isNotEmpty ? 'Cancel Alarm' : 'Set Alarm',
              style: TextStyle(fontSize: 18),
            ),
            onPressed: () {
              if (_alarmTime.isNotEmpty) {
                _cancelAlarm();
              } else {
                _setAlarmTime();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTimerScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Timer',
            style: TextStyle(fontSize: 24),
          ),
          SizedBox(height: 20),
          Text(
            'Work in progress',
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _screens = [
      _buildClockScreen(),
      _buildAlarmScreen(),
      _buildTimerScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Dom Clock'),
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onNavItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            label: 'Clock',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.alarm),
            label: 'Alarm',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timer),
            label: 'Timer',
          ),
        ],
      ),
    );
  }
}