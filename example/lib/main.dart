/* This is free and unencumbered software released into the public domain. */

import 'dart:async' show Future;
import 'dart:io' show File;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_lua/flutter_lua.dart' show Lua, LuaThread;

void main() async {
  final thread = await LuaThread.spawn();
  print(thread);
  print(await thread.eval("return 6*7"));
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _luaVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String luaVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      luaVersion = await Lua.version;
    } on PlatformException {
      luaVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _luaVersion = luaVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Lua plugin'),
        ),
        body: Center(
          child: Text('Lua $_luaVersion\n'),
        ),
      ),
    );
  }
}
