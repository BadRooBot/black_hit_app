import 'dart:io';

import 'package:flutter/material.dart';

import 'resources/MyWidgetFactory.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
class ProfileWidget extends StatelessWidget {
  final String imagePath,name;
  final bool isEdit,VIP;
  final VoidCallback onClicked;

  const ProfileWidget({
    Key? key,
    required this.imagePath,
    required this.name,
    required this.VIP,
    this.isEdit = false,
    required this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return Center(
      child: Stack(
        children: [
          buildImage(),
             isEdit ? Positioned(
            bottom: 0,
            right: 4,
            child: buildEditIcon(color),
          ):Text("")
    ],
      ),
    );
  }

  Widget buildImage() {
    String img='assets/back.jpg';
    final image = HtmlWidget(
      '<img width="128" height="128" src="${imagePath}" '
          '/>',
      factoryBuilder: () => MyWidgetFactory(),enableCaching: true,
    );
    final text=SizedBox(child: CircleAvatar(backgroundImage: AssetImage(img),
      child: Text("${name.toString().substring(0,1).toUpperCase()}",
        style:
        TextStyle(fontSize: 38,fontWeight: FontWeight.bold),),
    ),height: 105,width: 105,);
    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child:  InkWell(child:VIP?image:text ,onTap: onClicked),
      ),
    );
  }

  Widget buildEditIcon(Color color) => buildCircle(
        color: Colors.white,
        all: 3,
        child: buildCircle(
          color: color,
          all: 8,
          child: Icon(
             Icons.edit,
            color: Colors.white,
            size: 20,
          ),
        ),
      );

  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );
}
