import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_2048/titleBlock.dart';
import 'package:flutter_2048/gameConfig.dart' as Game;

const TextStyle titleTextStyle = TextStyle(
  color: Color(0xff776e65),
  fontSize: 27.0,
  fontWeight: FontWeight.w800,
);

const TextStyle winTextStyle = TextStyle(
  color: Colors.green,
  fontSize: 20.0,
  fontWeight: FontWeight.w800,
);

const TextStyle looseTextStyle = TextStyle(
  color: Colors.red,
  fontSize: 20.0,
  fontWeight: FontWeight.w800,
);

class Pannel extends StatelessWidget {
  const Pannel({
    Key key,
    @required this.score,
    @required this.best,
    this.isGameEnd = false,
    this.onRetry,
  }) : super(key: key);

  final int score;
  final int best;
  final bool isGameEnd;
  final Function onRetry;

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: EdgeInsets.symmetric(vertical: 10.0),
                child: RaisedButton(
                  onPressed: () => onRetry(),
                  color: Color(0xff8f7a66),
                  child: Text(
                    'start',
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  ),
                ),
              ),
              Container(
                  child: isGameEnd
                      ? Text('Oooops!!', style: looseTextStyle)
                      : score >= Game.goal
                          ? Text('Congratulations!!', style: winTextStyle)
                          : Text('')),
            ],
          ),
        ],
      ),
    );
  }
}
