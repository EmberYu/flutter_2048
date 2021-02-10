import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_2048/titleBlock.dart';

const TextStyle titleTextStyle = TextStyle(
  color: Color(0xff776e65),
  fontSize: 27.0,
  fontWeight: FontWeight.w800,
);

class Pannel extends StatelessWidget {
  const Pannel({
    Key key,
    @required this.score,
    @required this.best,
  }) : super(key: key);

  final int score;
  final int best;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40.0),
      child: Column(
        children: <Widget>[
          SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('2048', style: titleTextStyle),
              Row(
                children: [
                  TitleBlock(name: 'Score', value: score),
                  SizedBox(width: 10.0),
                  TitleBlock(name: 'Best', value: max(score, best)),
                ],
              )
            ],
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: RaisedButton(
                onPressed: () => print('Restart Game'),
                color: Color(0xff8f7a66),
                child: Text(
                  'restart',
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
