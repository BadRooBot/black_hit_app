import 'package:flutter/material.dart';

class test_file extends StatefulWidget {
  const test_file({Key? key}) : super(key: key);

  @override
  State<test_file> createState() => _test_fileState();
}

dynamic id = ""; //  flutter run --no-sound-null-safety

class _test_fileState extends State<test_file> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final arg = ModalRoute.of(context)!.settings.arguments as Map;

    id = arg['id'];
    return Scaffold(
      appBar: AppBar(
        title: const Text("BadRooBoT"),
      ),
      body: id != null
          ? Text("$id")
          : const Center(
              child: Text(
                'Error: Invalid ID',
                style: TextStyle(fontSize: 20.0),
              ),
            ),
    );
  }
}
