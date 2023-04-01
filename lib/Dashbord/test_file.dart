import 'package:flutter/material.dart';

class test_file extends StatefulWidget {
  const test_file({Key? key}) : super(key: key);

  @override
  State<test_file> createState() => _test_fileState();
}

class _test_fileState extends State<test_file> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text("BadRooBoT"),),
      body: Text("body"),
    );
  }
}
