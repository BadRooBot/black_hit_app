import 'package:AliStore/alert.dart';
import 'package:AliStore/resources/Localizations_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';


import 'package:shared_preferences/shared_preferences.dart';


class singup extends StatefulWidget {
  const singup({Key? key}) : super(key: key);

  @override
  _singupState createState() => _singupState();
}

class _singupState extends State<singup> {
  var email;
  var passwor;






  GlobalKey<FormState> formstate = new GlobalKey<FormState>();

  signUp() async {
    String PleaseWait = getTranslated(context,'Please-Wait');
    String Passwordistoweak =  getTranslated(context,'Password-is-to-weak');
    String Emailexists =  getTranslated(context,'Email-exists');
    var formdata = formstate.currentState;
    if (formdata!.validate()) {
      formdata.save();
      try {
        SharedPreferences _preferences =await SharedPreferences.getInstance();

        showLoading(context,"$PleaseWait",true);
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
            email: email, password: passwor);
        _preferences.setString('email', email);
        _preferences.setString('pas', passwor);
        return userCredential;

      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          Navigator.of(context).pop();
          showLoading(context,"$Passwordistoweak", false);
        } else if (e.code == 'email-already-in-use') {
          Navigator.of(context).pop();
          showLoading(context,"$Emailexists", false);
        }
      } catch (e) {
        print(e);
      }
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    String SingUp = getTranslated(context,'Sing-Up');
    String usernamebig = getTranslated(context,'username-big');
    String usernamesmall =getTranslated(context, 'username-small');
    String TypeEmail =getTranslated(context, 'Type-Email');
    String Email = getTranslated(context,'Email');
    String passwordsmall = getTranslated(context,'password-small');
    String passwordbig = getTranslated(context,'password-big');
    String TypePassword =getTranslated(context, 'Type-Password');
    String Password = getTranslated(context,'Password');
    String login =getTranslated(context, 'login');
    String Error = getTranslated(context, 'Error');
    String Create = getTranslated(context, 'Create');
    String OrSingUpwith =getTranslated(context,  'Or-Sing-Up-with');
    String haveaccount = getTranslated(context, 'have-account');

    return Scaffold(
      body: Container(
        child: ListView(children: [SizedBox(height: 80,),
          Container(alignment: Alignment.center
              ,child: Text("$SingUp",style: TextStyle(fontSize: 24,fontWeight:FontWeight.bold,))),
          Form( key: formstate,
              child: Column(children: [
                SizedBox(height: 30,),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: TextFormField(
                    validator: (val) {
                      if (val!.length > 100) {
                        return "$usernamebig";
                      }
                      if (val.length < 2) {
                        return "$usernamesmall";
                      }
                      return null;
                    },
                    onSaved: (val){
                      email=val;
                    },
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email_outlined),
                        hintText: "$TypeEmail",
                        label: Text("$Email"),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(width: 1))),),
                ),
                SizedBox(height: 30,),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: TextFormField(
                    validator: (val) {
                      if (val!.length > 100) {
                        return "$passwordbig";

                      }
                      if (val.length < 6) {
                        return "$passwordsmall";
                      }
                      return null;
                    },
                    onSaved: (val){
                      passwor=val;
                    },
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.password_sharp),
                        hintText: "$TypePassword",
                        label: Text("$Password"),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(width: 1))),),
                ),
                SizedBox(height: 35,),
                MaterialButton(onPressed: ()async{
                  UserCredential response = await signUp();
                  SharedPreferences _preferences =await SharedPreferences.getInstance();
                  _preferences.setBool("NewUSer",true);
                  if(response!=null){
                    FirebaseMessaging messaging = FirebaseMessaging.instance;

                    // use the returned token to send messages to users from your custom server
                    String? token = await messaging.getToken(
                      vapidKey: "${response.user!.uid}",
                    );
                    await FirebaseFirestore.instance.collection("users").doc("${response.user!.uid}").set({"email":"$email",
                      "points":0,"token":"${token}", "followers": [],"name":"OneLand User","imageProFile":"Text","Online":0,"status":"Have fun, life is short",
                    "following": [],"VIP":false,"request":[],"uID":"${ FirebaseAuth.instance.currentUser!.uid}"},SetOptions(merge: true)).whenComplete((){

                      Navigator.pushReplacementNamed(context, "getUserInfo");
                    });
                  }else{
                    Navigator.of(context).pop();
                    showLoading(context, "$Error", false);
                  }
                },
                  child: Text("$Create",style: TextStyle(fontSize: 18,color: Colors.white,letterSpacing: 1.1
                  ))
                  ,color: Colors.black,padding: EdgeInsets.symmetric(horizontal:120),
                  splashColor: Colors.green,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),height: 52,),
                SizedBox(height: 35,),
                Container(alignment: Alignment.center,
                    child: Text("$OrSingUpwith",
                      style: TextStyle(fontSize: 12,color: Colors.grey),))
                ,SizedBox(height: 30,),
                Row(mainAxisAlignment:MainAxisAlignment.center,children: [ Text("Late")],),
                SizedBox(height: 50,),
                Container(alignment: Alignment.center,

                    margin: EdgeInsets.only(top: 15,bottom: 35,right: 70,left: 70)
                    ,child: InkWell(child: Text("$haveaccount",style: TextStyle(color: Colors.grey,fontSize: 14),)
                      ,onTap: (){
                        Navigator.pushNamed(context,"login");
                      },))

              ],
              )
          )
        ],
        ),
      ),
    );
  }
}
