import 'dart:core';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_screenutil/screenutil_init.dart';
import 'package:flutter_2048/swipeDector.dart';
import 'package:flutter_2048/gameConfig.dart' as Game;
import 'package:flutter_2048/pannel.dart';
import 'package:flutter_2048/board.dart';
import 'package:flutter_2048/grid.dart';
import 'package:flutter_2048/footer.dart';

enum SwipeDirection {
  right,
  left,
  up,
  down,
}
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

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<List<int>> matrix = [];

  int score = 0;
  int bestScore = 0;
  final int size = 4;

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    setState(() {
      matrix = [
        [0, 0, 0, 0],
        [0, 0, 0, 0],
        [0, 0, 0, 0],
        [0, 0, 0, 0],
      ];
      score = 0;
      generateGrid();
      // generateGrid();
    });
  }

  void swipeCell(SwipeDirection dir) {
    var newMatrix = copyMatrix();
    rotateMatrix(dir, newMatrix);
    if (canSwipe(newMatrix)) {
      swipe(newMatrix);
      unRotateMatrix(dir, newMatrix);
      setState(() {
        matrix = newMatrix;
        generateGrid();
      });
    }
  }

  rotateMatrix(dir, matrix) {
    if (dir == SwipeDirection.right) {
      return matrix;
    }
    if (dir == SwipeDirection.left) {
      for (var r = 0; r < size; r++) {
        matrix[r] = matrix[r].reversed.toList();
      }
    }
    if (dir == SwipeDirection.up) {
      // 旋转90度
      /*

      1, 2, 3      1, 4, 7       7, 4, 1
      4, 5, 6  ->  2, 5, 8   ->  8, 5, 2
      7, 8, 9      3, 6, 9       9, 6, 3
      
      */
      for (var r = 0; r < size - 1; r++) {
        for (var c = r + 1; c < size; c++) {
          var temp = matrix[r][c];
          matrix[r][c] = matrix[c][r];
          matrix[c][r] = temp;
        }
      }
      for (var c = 0; c < size / 2; c++) {
        for (var r = 0; r < size; r++) {
          var temp = matrix[r][c];
          matrix[r][c] = matrix[r][size - 1 - c];
          matrix[r][size - 1 - c] = temp;
        }
      }
    }
    if (dir == SwipeDirection.down) {
      // 旋转 -90度
      /*

       1, 2, 3      3, 2, 1       3, 6, 9
       4, 5, 6  ->  6, 5, 4   ->  2, 5, 8
       7, 8, 9      9, 8, 7       1, 4, 7

      */
      for (var r = 0; r < size; r++) {
        matrix[r] = matrix[r].reversed.toList();
      }
      for (var r = 0; r < size - 1; r++) {
        for (var c = r + 1; c < size; c++) {
          var temp = matrix[r][c];
          matrix[r][c] = matrix[c][r];
          matrix[c][r] = temp;
        }
      }
    }
  }

  unRotateMatrix(dir, matrix) {
    if (dir == SwipeDirection.right) {
      return matrix;
    }
    if (dir == SwipeDirection.left) {
      for (var r = 0; r < size; r++) {
        matrix[r] = matrix[r].reversed.toList();
      }
    }
    if (dir == SwipeDirection.up) {
      for (var r = 0; r < size; r++) {
        matrix[r] = matrix[r].reversed.toList();
      }
      for (var r = 0; r < size - 1; r++) {
        for (var c = r + 1; c < size; c++) {
          var temp = matrix[r][c];
          matrix[r][c] = matrix[c][r];
          matrix[c][r] = temp;
        }
      }
    }
    if (dir == SwipeDirection.down) {
      for (var r = 0; r < size - 1; r++) {
        for (var c = r + 1; c < size; c++) {
          var temp = matrix[r][c];
          matrix[r][c] = matrix[c][r];
          matrix[c][r] = temp;
        }
      }
      for (var c = 0; c < size / 2; c++) {
        for (var r = 0; r < size; r++) {
          var temp = matrix[r][c];
          matrix[r][c] = matrix[r][size - 1 - c];
          matrix[r][size - 1 - c] = temp;
        }
      }
    }
  }

  swipe(matrix) {
    // 向右滑动
    for (var r = 0; r < matrix.length; r++) {
      var row = matrix[r].where((e) => e != 0).toList();
      for (var i = row.length - 1; i > 0; i--) {
        if (row[i] == row[i - 1]) {
          row.removeAt(i);
          i--;
          row[i] = row[i] * 2;
          score += row[i];
        }
      }
      while (row.length < size) {
        row.insert(0, 0);
      }
      matrix[r] = row;
    }
    return matrix;
  }

  List<List<int>> copyMatrix() {
    List<List<int>> newMatrix = [];
    for (var r = 0; r < size; r++) {
      newMatrix.add([]);
      for (var c = 0; c < size; c++) {
        newMatrix[r].add(matrix[r][c]);
      }
    }
    return newMatrix;
  }

  bool canSwipe(matrix) {
    // 判断是否可以向右滑动
    for (var r = 0; r < matrix.length; r++) {
      var c = 0;
      while (true) {
        if (c == size - 1) {
          break;
        }
        var currScore = matrix[r][c];
        var nextScore = matrix[r][c + 1];
        c++;
        if (currScore == 0) {
          continue;
        }
        if (nextScore == 0) {
          // 中间有0，可以滑动
          return true;
        }
        if (currScore == nextScore) {
          // 值相等，可以滑动合并
          return true;
        }
      }
    }
    return false;
  }

  dynamic generateGrid() {
    List<List<int>> emptyStack = [];
    for (var r = 0; r < matrix.length; r++) {
      for (var c = 0; c < matrix[r].length; c++) {
        if (matrix[r][c] == 0) {
          emptyStack.add(
            [r, c],
          );
        }
      }
    }
    if (emptyStack.length == 0) {
      return null;
    }
    final targetIndex = Random().nextInt(emptyStack.length);
    final targetX = emptyStack[targetIndex][0];
    final targetY = emptyStack[targetIndex][1];
    final number = (Random().nextInt(2) + 1) * 2;
    setState(() {
      matrix[targetX][targetY] = number;
    });
  }

  List<Widget> get grids {
    List<Widget> grids = [Board()];
    for (var r = 0; r < matrix.length; r++) {
      for (var c = 0; c < matrix[r].length; c++) {
        var score = matrix[r][c];
        if (score > 0) {
          grids.add(Grid(
            x: r,
            y: c,
            score: score,
          ));
        }
      }
    }
    return grids;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
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
                      onRetry: () {
                        startGame();
                      }),
                  SwipeGestureRecognizer(
                    onSwipeDown: () {
                      swipeCell(SwipeDirection.down);
                    },
                    onSwipeUp: () {
                      swipeCell(SwipeDirection.up);
                    },
                    onSwipeLeft: () {
                      swipeCell(SwipeDirection.left);
                    },
                    onSwipeRight: () {
                      swipeCell(SwipeDirection.right);
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
                        children: [Board(), ...grids],
                      ),
                    ),
                  ),
                  Footer(),
                  Text(matrix[0].toString()),
                  Text(matrix[1].toString()),
                  Text(matrix[2].toString()),
                  Text(matrix[3].toString()),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
