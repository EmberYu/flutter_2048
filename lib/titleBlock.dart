import 'package:flutter/material.dart';

const TextStyle titleBlockName = TextStyle(color: Color(0xffeee4da));
const TextStyle titleBlockValue = TextStyle(
  color: Color(0xffffffff),
  fontSize: 27.0,
  fontWeight: FontWeight.w800,
);

class TitleBlock extends StatelessWidget {
  const TitleBlock({
    Key key,
    this.name,
    this.value,
  }) : super(key: key);

  final String name;
  final int value;
  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: 60.0),
      child: Container(
        height: 55.0,
        decoration: BoxDecoration(
          color: Color(0xffbbada0),
          borderRadius: BorderRadius.circular(3.0),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 10.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(name, style: titleBlockName),
              Text(value.toString(), style: titleBlockValue),
            ],
          ),
        ),
      ),
    );
  }
}
