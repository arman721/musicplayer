import 'package:flutter/material.dart';
import 'package:musicplayer/OnlinePage.dart';
import 'package:musicplayer/homepage.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int indexnumber = 0;
  void _BottomNavigationBar(int index) {
    setState(() {
      indexnumber = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    
    List<Widget> pages = [HomePage(), OnlinePage()];
    return MaterialApp(home: Scaffold(body: pages[indexnumber],
    bottomNavigationBar: BottomNavigationBar(currentIndex: indexnumber,
      onTap:_BottomNavigationBar,
    
      items: [
      BottomNavigationBarItem(icon: Icon(Icons.device_hub),label: "Local Storage"),
      BottomNavigationBarItem(icon: Icon(Icons.online_prediction),label: "Online")
    ]),
    
    ));
  }
}
