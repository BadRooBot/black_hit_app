import 'package:flutter/material.dart';

class ErrorPage extends StatefulWidget {
  const ErrorPage({Key? key}) : super(key: key);

  @override
  State<ErrorPage> createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: InkWell(
      child: Text("Go to test page"),
      onTap: () {
        Navigator.pushNamed(
          context,
          '/test',
          arguments: {'id': "32bd3df2-48d0-43b8-8d01-a1b47c37b29f"},
        );
      },
    ));
  }
}
