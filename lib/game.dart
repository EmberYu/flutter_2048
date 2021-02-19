import 'dart:core';
import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_2048/swipeDector.dart';
import 'package:flutter_2048/gameConfig.dart' as Game;
import 'package:flutter_2048/pannel.dart';
import 'package:flutter_2048/board.dart';
import 'package:flutter_2048/grid.dart';
import 'package:flutter_2048/footer.dart';

class Cell {
  static int _incrementKey = 0;
  Cell(this.score) {
    this.increKey = _incrementKey++;
  }
  int score;
  int increKey;
}

class MergedCell {
  int x;
  int y;
  int score;
  int increKey;
  MergedCell(this.score, {this.x, this.y, this.increKey});
}

enum SwipeDirection {
  right,
  left,
  up,
  down,
}

class MyGame extends StatefulWidget {
  MyGame({Key key}) : super(key: key);

  @override
  _MyGameState createState() => _MyGameState();
}

class _MyGameState extends State<MyGame> {
  List<List<Cell>> matrix = [];
  List<MergedCell> mergedCells = [];

  int score = 0;
  int bestScore = 0;
  bool gameEnd = false;
  bool isSuccess = false;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final int size = 4;

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    setState(() {
      gameEnd = false;
      isSuccess = false;
      matrix = [
        [Cell(0), Cell(0), Cell(0), Cell(0)],
        [Cell(0), Cell(0), Cell(0), Cell(0)],
        [Cell(0), Cell(0), Cell(0), Cell(0)],
        [Cell(0), Cell(0), Cell(0), Cell(0)],
      ];
      score = 0;
      insertGrid();
      insertGrid();
      _prefs.then((prefs) {
        setState(() {
          bestScore = prefs.getInt('best') ?? 0;
        });
      });
    });
  }

  void swipeCell(SwipeDirection dir) {
    if (gameEnd || isSuccess) {
      return;
    }
    var newMatrix = copyMatrix();
    rotateMatrix(dir, newMatrix);
    if (canSwipe(newMatrix)) {
      swipe(newMatrix);
      unRotateMatrix(dir, newMatrix);
      setState(() {
        matrix = newMatrix;
        insertGrid();
        if (isGameEnd()) {
          setState(() {
            gameEnd = true;
          });
        }
      });
    }
    if (score >= bestScore) {
      _prefs.then((prefs) {
        prefs.setInt('best', score);
      });
    }
  }

  bool isGameEnd() {
    bool canPointMergeRecursion(int x, int y) {
      var currPoint = matrix[x][y].score;
      var rightPoint = (y < size - 1) ? matrix[x][y + 1].score : null;
      var bottomPoint = (x < size - 1) ? matrix[x + 1][y].score : null;
      if (currPoint == 0) {
        return true;
      }
      if (currPoint == rightPoint || currPoint == bottomPoint) {
        return true;
      }
      if (rightPoint == null && bottomPoint == null) {
        return false;
      }
      if (rightPoint == null && bottomPoint != null) {
        return canPointMergeRecursion(x + 1, y);
      }
      if (rightPoint != null && bottomPoint == null) {
        return canPointMergeRecursion(x, y + 1);
      }
      return canPointMergeRecursion(x + 1, y) ||
          canPointMergeRecursion(x, y + 1);
    }

    return !canPointMergeRecursion(0, 0);
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
    // 要把mergedCell的位置转置到正确位置
    if (dir == SwipeDirection.right) {
      return matrix;
    }
    if (dir == SwipeDirection.left) {
      for (var r = 0; r < size; r++) {
        matrix[r] = matrix[r].reversed.toList();
      }

      for (var index = 0; index < mergedCells.length; index++) {
        var mergedCell = mergedCells[index];
        mergedCell.y = size - 1 - mergedCell.y;
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

      for (var index = 0; index < mergedCells.length; index++) {
        var mergedCell = mergedCells[index];
        var temp = mergedCell.x;
        mergedCell.y = size - 1 - mergedCell.y;
        mergedCell.x = mergedCell.y;
        mergedCell.y = temp;
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

      for (var index = 0; index < mergedCells.length; index++) {
        var mergedCell = mergedCells[index];
        var temp = mergedCell.x;
        mergedCell.x = mergedCell.y;
        mergedCell.y = temp;
        mergedCell.y = size - 1 - mergedCell.y;
      }
    }
  }

  swipe(matrix) {
    // 向右滑动
    for (var r = 0; r < size; r++) {
      for (var c = size - 1; c > 0; c--) {
        var currCell = matrix[r][c];
        for (var index = c - 1; index >= 0; index--) {
          var prevCell = matrix[r][index];
          if (currCell.score == 0 && prevCell.score != 0) {
            matrix[r][index] = currCell;
            matrix[r][c] = prevCell;
            c++;
            break;
          }

          if (currCell.score != 0) {
            if (prevCell.score == 0) {
              continue;
            }
            if (currCell.score == prevCell.score) {
              setState(() {
                score += currCell.score;
                if (score >= Game.goal) {
                  isSuccess = true;
                }
              });
              mergedCells.add(MergedCell(
                currCell.score,
                x: r,
                y: c,
                increKey: currCell.increKey,
              ));
              mergedCells.add(MergedCell(
                matrix[r][index].score,
                x: r,
                y: c,
                increKey: matrix[r][index].increKey,
              ));
              matrix[r][c] = Cell(currCell.score * 2);
              matrix[r][index] = Cell(0);
            }
            break;
          }
        }
      }
    }
    return matrix;
  }

  List<List<Cell>> copyMatrix() {
    List<List<Cell>> newMatrix = [];
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
        var currScore = matrix[r][c].score;
        var nextScore = matrix[r][c + 1].score;
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

  dynamic insertGrid() {
    List<List<int>> emptyStack = [];
    for (var r = 0; r < matrix.length; r++) {
      for (var c = 0; c < matrix[r].length; c++) {
        if (matrix[r][c].score == 0) {
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
      matrix[targetX][targetY] = Cell(number);
    });
  }

  List<Grid> get grids {
    List<Grid> grids = [];
    for (var r = 0; r < mergedCells.length; r++) {
      var mergedCell = mergedCells[r];
      grids.add(Grid(
        key: Key(mergedCell.increKey.toString()),
        x: mergedCell.x,
        y: mergedCell.y,
        score: mergedCell.score,
      ));
    }

    for (var r = 0; r < matrix.length; r++) {
      for (var c = 0; c < matrix[r].length; c++) {
        var cell = matrix[r][c];
        var score = cell.score;
        if (score > 0) {
          grids.add(Grid(
            key: Key(cell.increKey.toString()),
            x: r,
            y: c,
            score: score,
          ));
        }
      }
    }

    setState(() {
      this.mergedCells = [];
    });
    return grids;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
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
                    isGameEnd: gameEnd,
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
                // Text(matrix[0].map((cell) => cell.score).toString()),
                // Text(matrix[1].map((cell) => cell.score).toString()),
                // Text(matrix[2].map((cell) => cell.score).toString()),
                // Text(matrix[3].map((cell) => cell.score).toString()),
              ],
            ),
          ),
        )
      ],
    );
  }
}
