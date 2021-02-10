import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_2048/gameConfig.dart' as Game;

class Grid extends StatefulWidget {
  Grid({
    this.score,
    @required this.x,
    @required this.y,
  });
  final int score;
  final int x;
  final int y;

  @override
  _GridState createState() => _GridState();
}

class _GridState extends State<Grid> {
  final double margin = 20.0.w;
  final double size = 150.0.w;

  int x;
  int y;
  @override
  void initState() {
    x = widget.x;
    y = widget.y;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: Duration(milliseconds: 300),
      top: margin + (margin + size) * y,
      left: margin + (margin + size) * x,
      child: Container(
        width: size,
        height: size,
        decoration: Game.boxStyleMap[widget.score] ?? Game.boxStyleMap[2],
        child: Center(
          child: Text(
            widget.score.toString(),
            style: Game.textStyleMap[widget.score] ?? Game.textStyleMap[2],
          ),
        ),
      ),
    );
  }
}
