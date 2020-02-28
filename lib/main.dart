import 'package:flutter/material.dart';
import 'view/login.dart';
import 'view/index.dart';
import 'bloc/count_provider.dart';
import 'view/example.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>{
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      child: MaterialApp(
        title: '掌上工地(flutter版)',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.white,
        ),
        home: MyHomePage(title: '掌上工地(flutter版)'),
        routes: {
          'homeRoute': (BuildContext context) => index(),
          'loginRoute': (BuildContext context) => MyHomePage()
        },
      ),
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child:
              login()), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}