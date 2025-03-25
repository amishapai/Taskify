import 'package:flutter/material.dart';

class FocusScreen extends StatefulWidget {
  @override
  _FocusScreenState createState() => _FocusScreenState();
}

class _FocusScreenState extends State<FocusScreen> {
  int focusTime = 25; // Default focus time in minutes
  bool isRunning = false;
  int secondsRemaining = 25 * 60;
  late Stopwatch stopwatch;

  @override
  void initState() {
    super.initState();
    stopwatch = Stopwatch();
  }

  void startFocusSession() {
    setState(() {
      isRunning = true;
      stopwatch.start();
    });
  }

  void stopFocusSession() {
    setState(() {
      isRunning = false;
      stopwatch.stop();
    });
  }

  void resetFocusSession() {
    setState(() {
      isRunning = false;
      stopwatch.reset();
      secondsRemaining = focusTime * 60;
    });
  }

  String getFormattedTime() {
    int minutes = secondsRemaining ~/ 60;
    int seconds = secondsRemaining % 60;
    return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[100],
      appBar: AppBar(
        backgroundColor: Colors.purple[300],
        title: Text("Focus Mode"),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.timer, size: 100, color: Colors.purple[700]),
          SizedBox(height: 20),
          Text(
            "Stay Focused!",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            getFormattedTime(),
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.purple[900]),
          ),
          SizedBox(height: 20),
          _buildFocusControls(),
        ],
      ),
    );
  }

  Widget _buildFocusControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildActionButton("Start", Icons.play_arrow, startFocusSession, isRunning),
        SizedBox(width: 10),
        _buildActionButton("Stop", Icons.pause, stopFocusSession, !isRunning),
        SizedBox(width: 10),
        _buildActionButton("Reset", Icons.refresh, resetFocusSession, false),
      ],
    );
  }

  Widget _buildActionButton(String text, IconData icon, VoidCallback onPressed, bool disable) {
    return ElevatedButton(
      onPressed: disable ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: disable ? Colors.grey : Colors.purple[600],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        minimumSize: Size(100, 50),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white),
          SizedBox(width: 5),
          Text(text, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
