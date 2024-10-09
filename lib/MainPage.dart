import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:musicplayer/OnlinePage.dart';
import 'package:musicplayer/homepage.dart';
import 'package:permission_handler/permission_handler.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
    requestPermission();
  }

  Future<void> requestPermission() async {
    await Permission.audio.request();
    bool isGranted = await Permission.audio.isGranted;

    if (isGranted) {
      log("Audio permission granted");
    } else {
      log("Audio permission denied, requesting again...");
      await requestPermission();
    }
  }

  int indexnumber = 0;

  void _BottomNavigationBar(int index) {
    setState(() {
      indexnumber = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [HomePage(), OnlinePage()];
    return Scaffold(
      body: pages[indexnumber],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: indexnumber,
        onTap: _BottomNavigationBar,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.device_hub), label: "Local Storage"),
          BottomNavigationBarItem(
              icon: Icon(Icons.online_prediction), label: "Online"),
        ],
      ),
    );
  }
}
