import 'package:flutter/material.dart';
import 'mytasks.dart';
import 'focus.dart';

void main() {
  runApp(TaskProgressApp());
}

class TaskProgressApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
        primaryColor: Colors.purple[200],
      ),
      home: TaskProgressScreen(),
    );
  }
}

class TaskProgressScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[100],
      appBar: AppBar(
        backgroundColor: Colors.purple[300],
        leading: Icon(Icons.menu, color: Colors.white),
        actions: [Icon(Icons.account_circle, color: Colors.white)],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildHeader(),
            SizedBox(height: 10),
            _buildProgressBar(),
            SizedBox(height: 10),
            _buildStreakBadgeSection(),
            SizedBox(height: 10),
            _buildNavigationButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.purple[300],
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.auto_awesome, color: Colors.white, size: 30),
          SizedBox(width: 8),
          Text(
            "GOOD VIBES ONLY",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(width: 8),
          Icon(Icons.celebration, color: Colors.white, size: 30),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "TODAY'S PROGRESS",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        SizedBox(height: 5),
        LinearProgressIndicator(
          value: 0.4,
          backgroundColor: Colors.purple[200],
          color: Colors.purple[600],
          minHeight: 10,
        ),
        SizedBox(height: 5),
        Text("4 out of 10 tasks completed!", style: TextStyle(fontSize: 14)),
      ],
    );
  }

  Widget _buildStreakBadgeSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildStreakBox(),
        _buildBadgesBox(),
      ],
    );
  }

  Widget _buildStreakBox() {
    return Container(
      width: 140,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Icon(Icons.local_fire_department, color: Colors.purple[300], size: 40),
          SizedBox(height: 5),
          Text(
            "You're on a\n15-day streak!",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildBadgesBox() {
    return Container(
      width: 140,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.brown[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text("Your Badges", style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 5),
          Wrap(
            spacing: 8,
            children: List.generate(4, (index) => Icon(Icons.verified, color: Colors.green[700])),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons(BuildContext context) {
    return Column(
      children: [
        _buildActionButton("My Tasks", Icons.checklist, () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => MyTasksScreen()));
        }),
        SizedBox(height: 10),
        _buildActionButton("Focus Mode", Icons.timer, () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => FocusScreen()));
        }),
        SizedBox(height: 10),
        _buildActionButton("Dashboard", Icons.dashboard, () {}),
      ],
    );
  }

  Widget _buildActionButton(String text, IconData icon, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.purple[600],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        minimumSize: Size(double.infinity, 50),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white),
          SizedBox(width: 10),
          Text(text, style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
