import 'package:flutter/material.dart';

class DeleteButton extends StatelessWidget {
  final Function()? function;
  final Color? backgroundColor;
  final Color splashColor;
  final String text;
  final Color textColor;
  final Mywidth;
  final Myheight;
  const DeleteButton({
    Key? key,
    required this.backgroundColor,
    required this.splashColor,
    required this.text,
    required this.textColor,
    required this.function,
    required this.Mywidth,
    required this.Myheight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      /*
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(
          color: borderColor,
        ),
        borderRadius: BorderRadius.circular(5),
      ),*/
      child: MaterialButton(splashColor: splashColor,
        shape: RoundedRectangleBorder(borderRadius:  BorderRadius.circular(5),side: BorderSide(color: Colors.black,width: 1.5,style: BorderStyle.solid) ),
        color: backgroundColor,
        onPressed: function ,
        child: Container(
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          width: Mywidth,//250
          height: Myheight,//34
        ),
      ),
    );
  }
}
