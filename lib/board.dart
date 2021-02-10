import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

var emptyDecoration = BoxDecoration(
  borderRadius: BorderRadius.circular(3.0),
  color: Color.fromRGBO(238, 228, 218, 0.35),
);

class Board extends StatelessWidget {
  final int rectLength = 4;
  List<Widget> getEmptyList() {
    List<Widget> result = [];
    for (var i = 0; i < rectLength; i++) {
      List<EmptyGrid> grids = [];
      for (var j = 0; j < rectLength; j++) {
        grids.add(EmptyGrid());
      }
      result.add(Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: grids,
      ));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: getEmptyList(),
    );
  }
}

class EmptyGrid extends StatelessWidget {
  final double size = 150.0.w;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: emptyDecoration,
    );
  }
}
