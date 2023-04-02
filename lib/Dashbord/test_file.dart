import 'package:AliStore/resources/API_Black_Hit.dart';
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
    getdds();
  }

  getdds() async {
    var dd = await API().getOneUser("9c53b61f-7324-400b-8b19-26e976df8286");

    setState(() {
      id = dd;
      print("DDD $dd");
      print("id $id");
    });
  }

  @override
  Widget build(BuildContext context) {
    // final arg = ModalRoute.of(context)!.settings.arguments as Map;

    // id = arg['id'];
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
