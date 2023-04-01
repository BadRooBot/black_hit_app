import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:AliStore/resources/Localizations_constants.dart';
import 'package:AliStore/resources/firestore_methods.dart';

showLoading(context,txt,bool loading) {

  return showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: Container(
              alignment: Alignment.center,
              margin:EdgeInsets.symmetric(horizontal: 40) ,
              child:  Card(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                shadowColor: Colors.grey,
                child: Container(
                  height: 120,
                  alignment: Alignment.center,
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment:MainAxisAlignment.center,children: [Visibility(visible:txt==""?false:true ,
                        child: Expanded(child: Text("$txt"))),SizedBox(width: 25,),
                      loading?CircularProgressIndicator():Text("")],),
                  ),
                ),
              )),
        );
      });
}/*
AlertDialog(

title: Text("Please Wait"),
content: Container(
alignment: Alignment.center,
2@2.2
height: 50, child: Center(child: CircularProgressIndicator())),
);*/

showAddOrDelete(context,userName,groupName,uid,followId,requestID){
  String  areYouwontAdd=getTranslated(context,"areYouwontAdd");
  String  toGroup=getTranslated(context,"toGroup");
  String  Add=getTranslated(context,"Add");
  String  loading=getTranslated(context,"loading");
  String  Delete=getTranslated(context,"Delete");
  String  Cancel=getTranslated(context,"Cancel");

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return SimpleDialog(
        title:  Text("$areYouwontAdd"+ "${userName} "+"$toGroup"+" ${groupName}"),
        children: <Widget>[
          SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child:  Text('$Add'),
              onPressed: () async {
                Navigator.pop(context);
                showLoading(context, "$loading", true);

                FireStoreMethods().AddMaeber(uid, followId,context);
                FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection("request").doc(requestID).
                      delete();
                Navigator.pop(context);

              }),
          SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child:  Text('$Delete'),
              onPressed: () async {
                Navigator.of(context).pop();

                showLoading(context, "$loading", true);
                FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection("request").doc(requestID).
                delete();

                Navigator.of(context).pop();

              }),
          SimpleDialogOption(
            padding: const EdgeInsets.all(20),
            child:  Text("$Cancel"),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      );
    },
  );
}