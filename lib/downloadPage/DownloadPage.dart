import 'package:AliStore/post/follow_button.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

//import 'dart:html' as html;

class DownloadPage extends StatefulWidget {
  const DownloadPage({Key? key}) : super(key: key);

  @override
  State<DownloadPage> createState() => _DownloadPageState();
}

final Uri _url = Uri.parse('http://bestegytech.blogspot.com/');

class _DownloadPageState extends State<DownloadPage> {
  void _launchUrl() async {
    if (!await launchUrl(_url)) throw 'Could not launch $_url';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('Download'),),
      body: SafeArea(top: true,
          child: Center(child: Column(children: [
            Image.asset('assets/myIC.png'),
            FollowButton(
              splashColor: Colors.blue,
              text: 'DownloadNow',
              textColor: Colors.white,
              backgroundColor: Colors.blueGrey,
              function: () {
                // html.window.open("http://bestegytech.blogspot.com/", '');
                _launchUrl();
              },)
          ],),)),
    );
  }

}