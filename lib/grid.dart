import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_2048/gameConfig.dart' as Game;

class Grid extends StatefulWidget {
  Grid({
    Key key,
    this.x,
    this.y,
    this.score,
  }) : super(key: key);

  final int x;
  final int y;
  final int score;
  @override
  _GridState createState() => _GridState();
}

class _GridState extends State<Grid> with SingleTickerProviderStateMixin {
  final double margin = 20.0.w;
  final double size = 150.0.w;

  Animation<double> _scaleTween;
  AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleTween = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: controller, curve: Curves.elasticInOut)
          ..addListener(() {
            setState(() {});
          }));
    Future.delayed(Duration(milliseconds: 50), () {
      controller.forward();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: Duration(milliseconds: 100),
      curve: Curves.easeIn,
      top: margin + (margin + size) * widget.x,
      left: margin + (margin + size) * widget.y,
      child: Transform.scale(
        scale: _scaleTween.value,
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
      ),
    );
  }
}
