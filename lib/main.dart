import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:musicplayer/MainPage.dart';
import 'package:musicplayer/homepage.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void initState() {
    requestPermission();
  }

  Future<void> requestPermission() async {
    Permission.audio.request();
    bool al;
    al = await Permission.audio.isGranted;
    if (al) {
      log("accepted");
    } else {
      await requestPermission();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainPage(),
    );
  }
}
