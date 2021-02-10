import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_screenutil/screenutil_init.dart';
import 'package:flutter_2048/swipeDector.dart';
import 'package:flutter_2048/gameConfig.dart' as Game;
import 'package:flutter_2048/pannel.dart';
import 'package:flutter_2048/board.dart';
import 'package:flutter_2048/grid.dart';
import 'package:flutter_2048/footer.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(750, 1334),
      allowFontScaling: false,
      builder: () => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'flutter_2048',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(title: '2048'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<List<int>> matrix = [
    [0, 0, 0, 0],
    [0, 0, 0, 0],
    [0, 2, 0, 0],
    [0, 0, 0, 0],
  ];

  int score = 0;
  int bestScore = 0;

  void swipe(String dir) {}

  List<Widget> drawGrid() {
    List<Widget> grids = [Board()];
    for (var col = 0; col < matrix.length; col++) {
      for (var row = 0; row < matrix[col].length; row++) {
        var score = matrix[row][col];
        if (score > 0) {
          grids.add(Grid(
            x: col,
            y: row,
            score: score,
          ));
        }
      }
    }
    return grids;
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Column(
        // Column is also a layout widget. It takes a list of children and
        // arranges them vertically. By default, it sizes itself to fit its
        // children horizontally, and tries to be as tall as its parent.
        //
        // Invoke "debug painting" (press "p" in the console, choose the
        // "Toggle Debug Paint" action from the Flutter Inspector in Android
        // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
        // to see the wireframe for each widget.
        //
        // Column has various properties to control how it sizes itself and
        // how it positions its children. Here we use mainAxisAlignment to
        // center the children vertically; the main axis here is the vertical
        // axis because Columns are vertical (the cross axis would be
        // horizontal).
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: Container(
              color: Game.backgroundColor,
              child: Column(
                children: <Widget>[
                  Pannel(
                    score: score,
                    best: bestScore,
                  ),
                  SwipeGestureRecognizer(
                    onSwipeDown: () {
                      print('Swipe Down');
                    },
                    onSwipeUp: () {
                      print('Swipe Up');
                    },
                    onSwipeLeft: () {
                      print('Swipe Left');
                    },
                    onSwipeRight: () {
                      print('Swipe Right');
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 10.0),
                      width: 700.0.w,
                      height: 700.0.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6.0),
                        color: Color(0xffbbada0),
                      ),
                      child: Stack(
                        children: drawGrid(),
                      ),
                    ),
                  ),
                  Footer(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
