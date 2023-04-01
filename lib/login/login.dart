import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:AliStore/alert.dart';
import 'package:AliStore/Dashbord/home.dart';
import 'package:AliStore/resources/Localizations_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../resources/API_BLACK_Hit.dart';


class NewLogin extends StatefulWidget {
  const NewLogin({Key? key}) : super(key: key);

  @override
  _NewLoginState createState() => _NewLoginState();
}

class _NewLoginState extends State<NewLogin> {
  var email;
  var passwor;
  GlobalKey<FormState> formstate = new GlobalKey<FormState>();
  
  getMyData() async {
    if(UserInfoList.isEmpty){
     // List _val=await realtimeDb().GetOneUserData(Id: "${FirebaseAuth.instance.currentUser!.uid}");
     var _val=await API().getOneUser(userId)
      setState(() {
        UserInfoList=_val;
      });
      /* var Usersinof =
     await userinfoRef.where("uID", isEqualTo: "${FirebaseAuth.instance.currentUser!.uid}").get();
     Usersinof.docs.forEach((element) {
       setState(() {
         UserInfoList.add(element.data());
       });
     });*/
    }
    if((UserInfoList[0]['username']=="OneLand User")||UserInfoList[0]['username']==null){
      Navigator.pushReplacementNamed(context, "getUserInfo");
    }
  }
  signIn() async {
    String PleaseWait = getTranslated(context,'Please-Wait');
    String emailnotfound = getTranslated(context,'emailnotfound');
    String Wrongpassword = getTranslated(context,'Wrongpassword');
    SharedPreferences _preferences =await SharedPreferences.getInstance();

    var formdata = formstate.currentState;
    if (formdata!.validate()) {
      formdata.save();
      try {
        showLoading(context,"$PleaseWait",true);
       var login= API.login(email, passwor);
        _preferences.setString('email', email);
        _preferences.setString('pas', passwor);
         _preferences.setString('id', login[]);
        return userCredential;
      }  catch (e) {
       
          Navigator.of(context).pop();
          showLoading(context,"$Wrongpassword", false);
        
      }
    } else {

    }
  }
  forgotPassword(context)async{
    final TextEditingController _usernameController = TextEditingController();
    String Typeyourname = getTranslated(context,'Type-Email');
    String Done = getTranslated(context,'Done');
    return showDialog(
        context: context,
        builder: (context) {
          return Container(
              alignment: Alignment.center,
              margin:EdgeInsets.symmetric(horizontal: 40) ,
              child:  Card(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                shadowColor: Colors.grey,
                child: Container(
                  height: 120,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment:MainAxisAlignment.center,children: [
                    TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        hintText: '$Typeyourname',
                        border: InputBorder.none,
                      ),
                    ),SizedBox(width: 25,),ElevatedButton(onPressed: () async{
                      try {
                        await FirebaseAuth.instance.sendPasswordResetEmail(
                            email: _usernameController.text);
                        Navigator.of(context).pop();
                        showSnackBar(context, "$Done");
                      }catch(e){
                        if(_usernameController.text.isEmpty){
                          showSnackBar(context, "plessae enter Your Email");
                        }else{
                          showSnackBar(context, "email address is not valid");
                        }
                      }
                    }, child: Text("$Done"))
                  ],),
                ),
              ));
        });
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
    String Forgotpassword =getTranslated(context, 'Forgot-password');
    String OrLoginwith =getTranslated(context, 'Or-Login-with');
    String donthaveaccount = getTranslated(context,'dont-have-account');

    return Scaffold(
      body: Container(
        child: ListView(children: [SizedBox(height: 80,),
          Container(alignment: Alignment.center
              ,child: Text("$login",style: TextStyle(fontSize: 24,fontWeight:FontWeight.bold,))),
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
                      if (val.length < 2) {
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
                )
                ,Container(alignment: Alignment.bottomLeft,

                    margin: EdgeInsets.only(top: 15,bottom: 35,right: 70,left: 70)
                    ,child: InkWell(child: Text("$Forgotpassword",style: TextStyle(color: Colors.grey,fontSize: 14),)
                      ,onTap: (){forgotPassword(context);},)),

                MaterialButton(onPressed: ()async{
                  var user = await signIn();
                  if (user != null) {
                    getMyData();
                    SharedPreferences _preferences =await SharedPreferences.getInstance();
                    _preferences.setBool("NewUSer",true);
                    Navigator.of(context)
                        .pushReplacementNamed("home");
                  }
                },
                  child: Text("Login",style: TextStyle(fontSize: 18,color: Colors.white,letterSpacing: 1,
                  ))
                  ,color:Colors.blueGrey,padding: EdgeInsets.symmetric(horizontal:120),
                  splashColor: Colors.green,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),height: 52,),
                SizedBox(height: 35,),
                Container(alignment: Alignment.center,
                    child: Text("$OrLoginwith",
                      style: TextStyle(fontSize: 12,color: Colors.grey),))
                ,SizedBox(height: 30,),
                Row(mainAxisAlignment:MainAxisAlignment.center,children: [],),
                SizedBox(height: 50,),
                Container(alignment: Alignment.center,

                    margin: EdgeInsets.only(top: 15,bottom: 35,)
                    ,child: InkWell(child: Text("$donthaveaccount",style: TextStyle(color: Colors.grey,fontSize: 14),)
                      ,onTap: (){
                        Navigator.pushReplacementNamed(context,"signup");
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
