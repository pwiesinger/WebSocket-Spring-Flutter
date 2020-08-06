import 'package:flutter/material.dart';
import 'dart:io';

import 'package:socket_demo/StompSocket.dart';
import 'package:socket_demo/UserModel.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Socket Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Socket Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  StompSocket stompSocket;

  List<UserModel> users = [];

  @override
  void initState() {
    super.initState();
    setupStomp();
  }

  void setupStomp() {
    stompSocket = StompSocket('/listeners/users', updateFromSocket);
    stompSocket.connect();
  }

  void updateFromSocket(Map<String, dynamic> json) {
    setState(() {
      users.add(UserModel.fromJson(json));
    });
  }

  @override
  void dispose() {
    super.dispose();
    stompSocket.disconnect();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView.separated(
          itemBuilder: (context, index) => ListTile(title: Text(users[index].toString()), subtitle: Text(DateTime.now().toIso8601String()),),
          separatorBuilder: (context, index) => Divider(),
          itemCount: users.length
      )
    );
  }
}
