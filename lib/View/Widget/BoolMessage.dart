import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BoolMessage extends StatelessWidget{
  final RxBool bool;
  final String text;
  final Color? color;
  final IconData? icon;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;

  const BoolMessage({
    Key? key,
    required this.bool,
    required this.text,
    this.color,
    this.icon,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisAlignment = MainAxisAlignment.start
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(()=> bool.isTrue
      ? Column(
        children: [
          Row(
            crossAxisAlignment : crossAxisAlignment,
            mainAxisAlignment : mainAxisAlignment,
            children: [
              Icon(icon ?? Icons.warning_amber_rounded, color: color ?? Colors.red, size: 13,),
              Text(
                  text,
                  style: TextStyle(

                    fontSize: 15,
                    color: color ?? Colors.red,
                  )),
            ],
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 3,)),
        ],
      ) : Container());
  }

}
