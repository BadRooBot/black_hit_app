import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localization/localization.dart';
import 'package:AliStore/resources/Localizations_constants.dart';
import 'package:AliStore/resources/storage_methods.dart';
import 'package:path/path.dart';

import '../alert.dart';

class getUserInfo extends StatefulWidget {
  const getUserInfo({Key? key}) : super(key: key);

  @override
  _getUserInfoState createState() => _getUserInfoState();
}

class _getUserInfoState extends State<getUserInfo> {
  var email;
  var passwor;
  late File file;
  var imageurl;
  bool UpDone=false;


  GlobalKey<FormState> formstate = new GlobalKey<FormState>();
  DocumentReference userinfoRef =FirebaseFirestore.instance.collection("users").doc("${FirebaseAuth.instance.currentUser!.uid}") ;

  late Reference res;

  addInfo(context)async{
    String defaultstatus = getTranslated(context,'default-status');
    String loading = getTranslated(context,'loading');
    var formdata = formstate.currentState;
    if (formdata!.validate()) {
      formdata.save();

      showLoading(context,"$loading",true);
      imageurl="Text";
      //imageurl=await  StorageMethods().uploadImageGroupToStorage("ImageProfile", file, "${FirebaseAuth.instance.currentUser!.uid}");
      passwor.toString().isEmpty?passwor="$defaultstatus":passwor=passwor;
      await userinfoRef.set({
        "name": email,
        "status": passwor,
        "imageProFile": imageurl}
        ,SetOptions(merge: true),);
      Navigator.pushNamed(context,"home");
    }
  }


  @override
  Widget build(BuildContext context) {
    String PleaseWait = getTranslated(context,'Please-Wait');
    String Done = getTranslated(context,'Done');
    String Nameisrequired = getTranslated(context,'Name-is-required');
    String Typeyourname = getTranslated(context,'Type-your-name');
    String name = getTranslated(context,'name');
    String TypeStatus = getTranslated(context,'Type-your-Status');
    String Status =getTranslated(context, 'Status');
    String Create = getTranslated(context,'Create');
    String done=getTranslated(context,"Choose-picture");
    return Scaffold(
        body: Container(
            child: ListView(children: [
              //هنا بدايه الصوره
              Visibility(visible: false,
                child: Container(
                  width: 180,
                  height: 180,
                  margin: EdgeInsets.only(left: 85,right: 85,top: 25),
                  child: MaterialButton(onPressed: ()async{

                    var picked = await ImagePicker()
                        .getImage(source: ImageSource.gallery);
                    if (picked != null) {

                      setState(() {
                        done="$Done";
                      });
                      file=File(picked.path);
                      var nameImage=FirebaseAuth.instance.currentUser!.uid;

                      UpDone=true;

                    }
                  },splashColor: Colors.lightBlueAccent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(150)),
                    child: Container(
                      alignment: Alignment.center,
                      width: 190,
                      height: 200,
                      child:ClipOval(
                        child: Material(
                          color: Colors.black,
                          child: UpDone==true? InkWell(child:Image.file(file) ,onTap: (){}):Text('$done'),
                        ),
                      )
                    ),
                  ),
                ),
              ),//هنا نهايه الصوره
              Form( key: formstate,
                  child: Column(children: [
                    SizedBox(height: 30,),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: TextFormField(
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "$Nameisrequired";
                          }
                          return null;
                        },

                        onSaved: (val){
                          email=val;
                        },
                        decoration: InputDecoration(
                            hintText: "$Typeyourname",
                            label: Text("$name"),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(width: 1))),),
                    ),
                    SizedBox(height: 30,),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: TextFormField(
                        validator: (val) {
                          if (val!.isEmpty) {
                            return null;
                          }
                          return null;
                        },
                        onSaved: (val){
                          passwor=val;
                        },
                        decoration: InputDecoration(
                            hintText: "$TypeStatus",
                            label: Text("$Status"),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(width: 1))),),
                    ),
                    SizedBox(height: 35,),
                    MaterialButton(onPressed: ()async{
                      await addInfo(context);
                    },
                      child: Text("$Create",style: TextStyle(fontSize: 18,color: Colors.white,letterSpacing: 1.1

                      ))
                      ,color: Colors.black,padding: EdgeInsets.symmetric(horizontal:120),
                      splashColor: Colors.green,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),height: 52,),
                  ],
                  )

              ),]))
    );
  }
}
