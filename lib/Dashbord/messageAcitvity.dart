import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:AliStore/Dashbord/home.dart';
import 'package:AliStore/alert.dart';
import 'package:AliStore/constants.dart';
import 'package:AliStore/resources/Localizations_constants.dart';
import 'package:AliStore/resources/firestore_methods.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:timeago/src/timeago.dart';

import '../resources/Delete_Button.dart';
import '../resources/realtime_database_methods.dart';
List allMessages = [];

class message extends StatefulWidget  {
  final Name,Image,Uid,isGroup,VIP;


  const message({Key? key,required this.Name,required this.Image,required this.Uid,required this.isGroup,required this.VIP} ) : super(key: key);


  @override
  _messageState createState() => _messageState();
}
class _messageState extends State<message> {
  final TextEditingController messageEditingController =
  TextEditingController();
  final scrollController=ScrollController();
  var lastMessage="";
  var firstMessage="";
  dynamic messageTime='';
  int dataLength=15;
  String LangCod='';
  int Length=0;
  List userInfoMessage=[{}];
  List AllId=[];
  bool Update=false;
  bool IsFirst=false;
  bool IsFirstTime=true;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;



  getLang()async{
    SharedPreferences _preferences =await SharedPreferences.getInstance();
    setState(() {
      LangCod=_preferences.getString(LangaugeKey)??'en';

    });
  }
  void sendMessage(yourName,yourProfilePic) async {
    try {
      String res = await FireStoreMethods().sendMessage(
          FirebaseAuth.instance.currentUser!.uid,
          messageEditingController.text,
          '${widget.Uid}' ,
          "${UserInfoList[0]["name"]}",
          "${UserInfoList[0]["imageProFile"]}",
          yourName,yourProfilePic,widget.isGroup
      );

      if (res != 'success') {
        showLoading(context, res,false);
      }
      setState(() {
        messageEditingController.text = "";
      });
    } catch (err) {
      showLoading(context, err,false);
    }
  }

  IsLoadMore(bool Load){
    var Source;
    if(Load){
     setState(() {
       Source=   widget.isGroup?FirebaseFirestore.instance
           .collection('chatList')
           .doc(widget.Uid)
           .collection(widget.Uid).orderBy("datePublished",descending: true).startAfter(["$lastMessage"]).limit(dataLength)
           .snapshots()
           :FirebaseFirestore.instance
           .collection('chatList')
           .doc(FirebaseAuth.instance.currentUser!.uid)
           .collection(widget.Uid).orderBy("datePublished",descending: true).startAfter(["$lastMessage"]).limit(dataLength)
           .snapshots();
     });
    }else{
     setState(() {
       Source=  widget.isGroup?FirebaseFirestore.instance
           .collection('chatList')
           .doc(widget.Uid)
           .collection(widget.Uid).orderBy("datePublished",descending: true).startAt(["$firstMessage"]).limit(dataLength)
           .snapshots()
           :FirebaseFirestore.instance
           .collection('chatList')
           .doc(FirebaseAuth.instance.currentUser!.uid)
           .collection(widget.Uid).orderBy("datePublished",descending: true).startAt([""]).limit(dataLength)
           .snapshots();
     });
    }
    return  Source;
  }
  GetsUpdateAllNames(NotEx)async{
    //   ListlastChat.clear();

    for(int num=0;num<=AllId.length-1;num++){
      try{
        if(NotEx){
          print('++++++++++++++++Enter 1');
          if(widget.isGroup) {
            /*var nAndI = await _firestore.collection('users')
                .where('uID',
                isEqualTo: AllId[num])
                .get();*/
            List nAndI =await realtimeDb().GetOneUserData(
                Id: AllId[num]);
            print('++++++++++++++++Enter snap done');
            nAndI.forEach((element) async {
              //name  //imageProFile //profilePic  //VIP
              setState(() {
                userInfoMessage.add(element);
                print('++++++++++++++++Enter add done   ${element['name']}');
                print('++++++++++++++++Enter length done   ${userInfoMessage.length}');

              });
            });
          }
        }else{
          if(widget.isGroup) {
           /* var nAndI = await _firestore.collection('users')
                .where('uID',
                isEqualTo: AllId[num])
                .get(GetOptions(source:Source.cache));*/
            List nAndI =await realtimeDb().GetOneUserData(
                Id: AllId[num]);
            nAndI.forEach((element) async {
              //name  //imageProFile //profilePic  //VIP
              setState(() {
                userInfoMessage.add(element);
              });
            });
          }
        }
      }catch(d){ print('++++++++++++++++Enter Error  $d');}
    }
    Update=true;
  }

  GetAllIds()async{
    Update=false;
  var _getAllIds=await  _firestore
        .collection('chatList')
        .doc(widget.Uid).get();

  setState(() {
    AllId=_getAllIds.data()!['membersID'];
  });
    GetsUpdateAllNames(false);
  }

  @override
  void initState() {
    IsFirstTime=true;

    GetAllIds();
    getLang();
 //   GetsUpdateAllNames(true);
    lastMessage="";
    IsFirst=false;
    firstMessage='';
    if(widget.isGroup==false){
      Update=true;
    }
    scrollController.addListener(() {
      if(scrollController.offset>=scrollController.position.maxScrollExtent){
        setState(() {
            dataLength+=5;
            IsFirst=true;
        });
      }else{
        setState(() {
          IsFirst=false;
          dataLength+=5;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String  TaypYourMessage=getTranslated(context,"TaypYourMessage");
    String  OK=getTranslated(context,"OK");

setState(() {
  LangCod =OK=='OK'?'en':'ar';

});
    ImageCache();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.Name.toString()),leading: Container(width: 28,height: 28,padding: EdgeInsets.all(8),
        child:widget.VIP? CircleAvatar(
          backgroundImage: NetworkImage(widget.Image),
          radius: 18,
        ):
        CircleAvatar(backgroundImage: AssetImage(img),
          child: Text("${widget.Name.toString().substring(0,1).toUpperCase()}",
            style:
            TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
        ),
      ),),
      //send message
      body: Column(
        children: [
        Update?  Container(
              child: StreamBuilder(
                stream: IsLoadMore(IsFirst)
                ,builder: (context,AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot){
                if (snapshot.connectionState == ConnectionState.waiting&&snapshot==null) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }else if(snapshot!=null&&snapshot.data!=null){

                    GetAllImage(index) {
                      if (userInfoMessage.isNotEmpty) {
                        for (int xx = 0; xx < userInfoMessage.length; xx++) {
                          if (userInfoMessage[xx]["uID"] == snapshot.data!.docs[index]["uid"]) {
                            YourImageeee = userInfoMessage[xx]["imageProFile"];
                            return YourImageeee;
                          }
                        }
                      } else
                        return 'https://img-prod-cms-rt-microsoft-com.akamaized.net/cms/api/am/imageFileData/RE4wyTI?ver=c51c';
                    }
                    GetAllname(index) {
                      if (userInfoMessage.isNotEmpty) {
                        for (int xx = 0; xx < userInfoMessage.length; xx++) {
                          if (userInfoMessage[xx]["uID"] == snapshot.data!.docs[index]["uid"]) {
                            return YourNames = userInfoMessage[xx]["name"];
                          }
                        }
                      } else {
                        GetsUpdateAllNames(true);
                        return " ";
                      }
                    }
                    getGroupVIP(index){
                      for(int end=0;end<userInfoMessage.length;end++){
                        if (userInfoMessage[end]["GroupId"] ==
                            snapshot.data!.docs[index]["uid"]) {
                          return  userInfoMessage[end]["VIP"];
                        }else {
                          return false;
                        }
                      }
                    }
                    getVIP(index){
                      if (userInfoMessage.isNotEmpty) {

                          for (int xx = 0; xx < userInfoMessage.length; xx++) {
                            if (userInfoMessage[xx]["uID"] == snapshot.data!
                                .docs[index]["uid"]) {
                              return userInfoMessage[xx]["VIP"];
                            }
                            else {
                              return getGroupVIP(index);
                            }
                          }

                      } else {
                        return   false;
                      }

                    }
                    return Update? Container(
                      height: MediaQuery.of(context).size.height-145,
                      child: ListView.builder(controller:scrollController,
                        padding: EdgeInsets.symmetric(horizontal: 5),physics: ScrollPhysics(parent:BouncingScrollPhysics()),reverse: true,itemCount: snapshot.data?.docs.length,itemBuilder: (context,index){
                   /*         if (snapshot.hasData && index == 0) {
                            print('++++++++++++++++Enter FirstTime hasData');

                            GetsUpdateAllNames(false);
                            IsFirstTime = false;
                            Update = true;
                          }*/

                          if(snapshot.data?.docs[index]['senderId']==FirebaseAuth.instance.currentUser!.uid){
                            return myMessage(snapshot,index,context);
                          }else {
                            return widget.isGroup ? yourMessage(
                                snapshot, index, GetAllImage(index),
                                GetAllname(index), getVIP(index),
                                userInfoMessage)
                                : yourMessage(
                                snapshot, index, widget.Image, widget.Name,
                                widget.VIP, userInfoMessage);
                          }
                        }, ),
                    ):Center(
                      child: CircularProgressIndicator(),
                    );
                  }else{
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                //read All message
              },)
          ):LinearProgressIndicator(),
        ],
      ),
      bottomSheet:  Container(color:myAppBarColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(margin: EdgeInsets.only(left: 5),
                width: (MediaQuery.of(context).size.width)/1.3,
                height: 55,
                child: TextField(style:TextStyle(color: Colors.white) ,
                  controller: messageEditingController,
                  decoration: InputDecoration(
                    hintText: '$TaypYourMessage',
                    hintStyle: TextStyle(color: Colors.white54),
                    border: InputBorder.none,
                  ),
                ),
              ),
              InkWell(
                onTap: () => sendMessage("${widget.Name}","${widget.Image}"),
                child: Container(
                  padding:
                  const EdgeInsets.all(8),
                  child: InkWell(splashColor: Colors.blue,child: const Icon(Icons.send_outlined)) ,//Text('Send', style: TextStyle(color: Colors.lightBlue),)
                ),
              )
            ]),
      ) ,

    );
  }

  String getTimeAgo(int time) {
    //86,400,000
    final int SECOND_MILLIS = 1000;
    final int  MINUTE_MILLIS = 60 * SECOND_MILLIS;
    final int HOUR_MILLIS = 60 * MINUTE_MILLIS;
    final int DAY_MILLIS = 24 * HOUR_MILLIS;
    print('============================Time 1t:  $time');
    if (time <1000000000000) {
      time *= 1000;
    }

    var now =Timestamp.now().millisecondsSinceEpoch; //DateTime.now().millisecond;
    print('============================Time time:  $time');
    print('============================Time now:   $now');
    if (time > now || time <= 0) {
      return 'Error';
    }
    var  diff;// = now - time;
    print('============================Time diff:   $diff');
    diff =DateTime.now().subtract(Duration(milliseconds: time));
    double finls=0;
    if (diff < MINUTE_MILLIS) {
      return "just now";
    } else if (diff < 2 * MINUTE_MILLIS) {
      return "a minute ago";
    } else if (diff < 50 * MINUTE_MILLIS) {
      finls=(diff / MINUTE_MILLIS) ;

      return '${
      (finls
      )}' + " minutes ago";
    } else if (diff < 60 * MINUTE_MILLIS) {
      return "an hour ago";
    } else if (diff < 24 * HOUR_MILLIS) {
      finls=(diff / HOUR_MILLIS) ;
      return '${
          (finls
          )}'+ " hours ago";
    } else if (diff < 48 * HOUR_MILLIS) {

      return "yesterday";
    } else {
      finls=(diff / DAY_MILLIS);

      return '${
          ( finls
          )}' + " days ago";
    }
  }
  DeleteView({required MessageID,required YourId,required IsGroup,required context,required  SenderID})async{
    var Whatdoyouwanttodo=getTranslated(context,"Whatdoyouwanttodo");
    var DeleteOneMessageForMe=getTranslated(context,"DeleteOneMessageForMe");
    var DeleteOneMessageForAll=getTranslated(context,"DeleteOneMessageForAll");
    var Cancel=getTranslated(context,"Cancel");
    var OK=getTranslated(context,"OK");
    var ConfirmOneMessageDataForMe=getTranslated(context,"ConfirmOneMessageDataForMe");
    var ConfirmOneMessageDataForMeAndYou=getTranslated(context,"ConfirmOneMessageDataForMeAndYou");

    var showMessage='';
    try {
      return   showDialog(context: context,
          builder: (context) {
            return Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 40),
                child: Card(shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                    child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10, vertical: 20),
                        child: Column(
                            mainAxisSize: MainAxisSize.min, children: [
                          Text("$Whatdoyouwanttodo"),
                          Divider(),
                          SizedBox(height: 30,),
                          Visibility(visible: IsGroup==false,
                            child: DeleteButton(
                              text: '$DeleteOneMessageForMe',
                              backgroundColor: Colors.white,
                              textColor: Colors.black,
                              splashColor: Colors.teal,
                              Myheight: 35,
                              Mywidth: 260,
                              function: () async {
                                Navigator.of(context).pop();
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return SimpleDialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius
                                                .circular(15)),
                                        children: <Widget>[
                                          SimpleDialogOption(
                                              padding: const EdgeInsets.all(20),
                                              child: Text(
                                                  '$ConfirmOneMessageDataForMe'),
                                              ),
                                          SimpleDialogOption(
                                              padding: const EdgeInsets.all(20),
                                              child: Text('$OK'),
                                              onPressed: () async {

                                                showMessage =
                                                await FireStoreMethods()
                                                    .deleteOneMessage(
                                                    MessageID: '$MessageID',
                                                    YourId: '$YourId',
                                                    DeleteOptions: 0,IsGroup: IsGroup);
                                                Navigator.pop(context);
                                                showSnackBar(
                                                    context, showMessage);
                                              }),
                                          SimpleDialogOption(
                                            padding: const EdgeInsets.all(20),
                                            child: Text("$Cancel"),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          )
                                        ],
                                      );
                                    });
                              },
                            ),
                          ),
                          SizedBox(height: 30,),
                          Visibility(visible: SenderID ==
                              FirebaseAuth.instance.currentUser!.uid,
                            child: DeleteButton(
                              text: '$DeleteOneMessageForAll',
                              backgroundColor: Colors.indigo,
                              textColor: Colors.white,
                              splashColor: Colors.blue,
                              Myheight: 35,
                              Mywidth: 260,
                              function: () async {
                                Navigator.of(context).pop();
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return SimpleDialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                15)),
                                        children: <Widget>[
                                          SimpleDialogOption(
                                              padding: const EdgeInsets.all(20),
                                              child: Text(
                                                  '$ConfirmOneMessageDataForMeAndYou'),
                                           ),
                                          SimpleDialogOption(
                                              padding: const EdgeInsets.all(20),
                                              child: Text('$OK'),
                                              onPressed: () async {

                                                showMessage =
                                                await FireStoreMethods()
                                                    .deleteOneMessage(
                                                    MessageID: '$MessageID',
                                                    YourId:IsGroup?widget.Uid: '$YourId',
                                                    DeleteOptions: 1,IsGroup: IsGroup);
                                                Navigator.pop(context);
                                                showSnackBar(
                                                    context, showMessage);
                                              }),
                                          SimpleDialogOption(
                                            padding: const EdgeInsets.all(20),
                                            child: Text("$Cancel"),
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                          )
                                        ],
                                      );
                                    });
                              },
                            ),
                          ),
                          SizedBox(height: 30,),
                        ]))));
          });
    }catch(e){
      print('==========================================error Delete $e');
    }
  }


  yourMessage(snapshot,index,ImageProfile,YourName,bool VIPs,List listNM){
    timeago.setLocaleMessages('ar', timeago.ArMessages());
    bool myOrNot=LangCod.contains('ar')?false:true;
    var lastIsMe=0.0;
    var lastIsMe2=15.0;
    var Allme=0.0;
    var Allme2=0.0;
  /*  DateTime dateTime;
    dateTime.add().millisecond;*/
    if(index!=snapshot.data?.docs.length-1){

     //getTimeAgo(Timestamp.fromDate().millisecondsSinceEpoch);
     // messageTime=DateTime.tryParse(snapshot.data!.docs[index]['datePublished'].toString())!.millisecond-DateTime.tryParse(snapshot.data!.docs[index+1]['datePublished'].toString())!.millisecond;
      lastIsMe=snapshot.data?.docs[index+1]['senderId']==snapshot.data?.docs[index]['senderId']?15.0:0.0;
      lastIsMe2=15.0;
    }
    if(snapshot.data?.docs.length==0||snapshot.data?.docs.length==1){
      lastIsMe2=15.0;

    }
    Allme=myOrNot?lastIsMe:lastIsMe2;
    Allme2=myOrNot?lastIsMe2:lastIsMe;
   bool iSendLastMessage=lastIsMe==0.0?true:false;

    return GestureDetector(onLongPress: (){
      if(snapshot.data?.docs[index]['isGroup']){
        if(snapshot.data?.docs[index]['senderId'] ==
            FirebaseAuth.instance.currentUser!.uid){
          DeleteView(MessageID: snapshot.data?.docs[index]['messageKey'], YourId:  snapshot.data?.docs[index]['uid'], IsGroup: snapshot.data?.docs[index]['isGroup'], context: context,SenderID:snapshot.data?.docs[index]['senderId'] );
        }
      }
    },
      child: Stack(
        alignment: myOrNot?Alignment.center:Alignment.center,
        children: [
          Container(margin: EdgeInsets.symmetric(horizontal: 18,vertical: 8),
            padding: EdgeInsets.only(left: 14,right: 14,top: 10,bottom: 10),
            child: Align(
              alignment: (myOrNot?Alignment.topLeft:Alignment.topRight),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft:Radius.circular(15),topRight:Radius.circular(15),bottomLeft: Radius.circular(Allme),bottomRight:   Radius.circular(Allme2)),
                  color:Colors.indigo,//myAppBarColor ()
                ),
                padding: EdgeInsets.all(16),
                child: Text('${snapshot.data!.docs[index]['text']}', style: TextStyle(fontSize: 15),),
              ),
            ),
          ),
          Visibility(visible:myOrNot ,
            child: Visibility(visible:snapshot.data?.docs[index]['isGroup'] ,
                child:Positioned(
    bottom: 11,
    left: 4,
    child:ShowIcon(index,ImageProfile,YourName,VIPs)) ),
          ),
          Visibility(visible:myOrNot ==false,
            child: Visibility(visible:snapshot.data?.docs[index]['isGroup'] ,
                child:Positioned(
                    bottom: 11,
                    right: 4,

                    child:ShowIcon(index,ImageProfile,YourName,VIPs)) ),
          ),
          Visibility(visible:myOrNot ,
            child: Visibility(visible:snapshot.data?.docs[index]['isGroup'] ,
                child:Positioned(
                    top: 11,
                    left: 24,
                    child:Visibility(visible: iSendLastMessage,child: Opacity(opacity:.50,child: Text('$YourName',style:TextStyle(fontSize: 12))))) ),
          ),
          Visibility(visible:myOrNot ==false,
            child: Visibility(visible:snapshot.data?.docs[index]['isGroup'] ,
                child:Positioned(
                    top: 7,
                    right: 24,
                    child:Visibility(visible: iSendLastMessage,child: Opacity(opacity:.60,child: Text('$YourName')))) ),
          ),


          Visibility(
            visible:iSendLastMessage ,
            child: Positioned(
                bottom: -3,
                child:Opacity(opacity: .15,child: Text( '${ timeago.format(snapshot.data!.docs[index]['datePublished'].toDate(),locale:LangCod.contains('ar')?'ar':'en' )}')))
          )

        ],
      ),
    );
  }

  myMessage(snapshot,index,context){
    bool myOrNot=LangCod.contains('ar')?false:true;
    var lastIsMe=0.0;
    var lastIsMe2=0.0;
    var Allme=0.0;
    var Allme2=0.0;
    if(index!=snapshot.data?.docs.length-1){
      lastIsMe=snapshot.data?.docs[index+1]['senderId']==snapshot.data?.docs[index]['senderId']?15.0:0.0;
      lastIsMe2=15.0;
    }
    if(index==snapshot.data?.docs.length-1){
      lastIsMe2=myOrNot?15.0:0.0;
      lastIsMe=myOrNot?0.0:15.0;

    }
    Allme=myOrNot?lastIsMe:lastIsMe2;
    Allme2=myOrNot?lastIsMe2:lastIsMe;
    bool iSendLastMessage=lastIsMe==0.0?true:false;

    return GestureDetector(onLongPress: (){
      DeleteView(MessageID: snapshot.data?.docs[index]['messageKey'], YourId:  snapshot.data?.docs[index]['uid'], IsGroup: snapshot.data?.docs[index]['isGroup'], context: context,SenderID:snapshot.data?.docs[index]['senderId'] );
    },
      child:  Stack(
        alignment: myOrNot?Alignment.center:Alignment.center,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 18,vertical: 8),
            padding: EdgeInsets.only(left: 14,right: 14,top: 10,bottom: 10),
            child: Align(
              alignment: (myOrNot?Alignment.topRight:Alignment.topLeft),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft:Radius.circular(15),topRight:Radius.circular(15),bottomLeft: Radius.circular(Allme2),bottomRight:   Radius.circular(Allme)),
                  color: (Colors.blueGrey),
                ),
                padding: EdgeInsets.all(16),
                child: SelectableText(snapshot.data!.docs[index]['text'], style: TextStyle(fontSize: 15),),
              ),
            ),
          ),
          Visibility(
            visible:iSendLastMessage ,
            child: Positioned(
                bottom: -3,
                child:Opacity(opacity: .15,child: Text( '${ timeago.format(snapshot.data!.docs[index]['datePublished'].toDate(),locale:LangCod)}')))


          )
        ],
      ),
    );



    /*
  return InkWell(
    onTap: (){},
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(width: MediaQuery.of(context).size.width/2,
              child: SelectableText(snapshot.data!.docs[index]['text'],minLines: 2,style: TextStyle(decorationColor: Colors.indigoAccent,),)),

          snapshot.data!.docs[index]['VIP']?CircleAvatar(
            backgroundImage: NetworkImage(
              snapshot.data!.docs[index]['imageProFile'],
            ),
            radius: 16,
          ):
          CircleAvatar(backgroundImage: AssetImage(img),
            child: Text("${snapshot.data!.docs[index]['name'].toString().substring(0,1).toUpperCase()}",
              style:
              TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
          ),





        ],
      ),
    ),
  );*/

    /* Container(
          child:
          ListTile(
            subtitle:Opacity(opacity:.60 ,
            child: Text(
              DateFormat.yMMMd().format(
                snapshot.data!.docs[index]['datePublished'].toDate(),
              ),
              style: const TextStyle(
                fontSize: 12, fontWeight: FontWeight.w400,),
            ),
          ) ,
            leading: snapshot.data!.docs[index]['VIP']?CircleAvatar(
              backgroundImage: NetworkImage(
                snapshot.data!.docs[index]['imageProFile'],
              ),
              radius: 16,
            ):CircleAvatar(backgroundImage: AssetImage(img),
              child: Text("${snapshot.data!.docs[index]['name'].toString().substring(0,1).toUpperCase()}",
                style:
                TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
            ),
            title: Text(
              snapshot.data!.docs[index]['text'],
            ),
          ),
        )*/
  }

}

ShowIcon(index,ImageProfile,YourName,bool IsVip){

  return  IsVip?   CircleAvatar(
    backgroundImage: NetworkImage(
      "${ImageProfile}",
    ),
    radius: 12,
  ):CircleAvatar(backgroundImage: AssetImage(img),radius: 12,
    child: Text("${YourName.toString().substring(0,1).toUpperCase()}",
      style:
      TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
  );
}


noSender(snapshot,index,ImageProfile,YourName,bool VIPs){

  return Card(
    color:myAppBarColor,
    margin: EdgeInsets.all(5),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft:Radius.circular(15),topRight:Radius.circular(15),bottomRight: Radius.circular(15))),
    elevation: 0,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        children: [
          VIPs?  CircleAvatar(
            backgroundImage: NetworkImage(
              ImageProfile,
            ),
            radius: 18,
          ):CircleAvatar(backgroundImage: AssetImage(img),
            child: Text("${YourName.toString().substring(0,1).toUpperCase()}",
              style:
              TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SelectableText(
                   ' ${snapshot.data!.docs[index]['text']}',
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 7),
                    child: Text(
                      DateFormat.yMMMd().format(
                        snapshot.data!.docs[index]['datePublished'].toDate(),
                      ),
                      style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w400,),
                    ),
                  )
                ],
              ),
            ),
          ),

        ],
      ),
    ),
  );
}

yesSender(snapshot,index){
  return Card(
    color:Colors.blueGrey,
    margin: EdgeInsets.all(5),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft:Radius.circular(15),topRight:Radius.circular(15),bottomLeft: Radius.circular(15))),
    elevation: 0,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                    child:     SelectableText(
                      ' ${snapshot.data!.docs[index]['text']}',
                    )
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 7),
                    child:
                    Opacity(opacity:.60 ,
                      child: Text(
                        DateFormat.yMMMd().format(
                          snapshot.data!.docs[index]['datePublished'].toDate(),
                        ),
                        style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w400,),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          UserInfoList[0]["VIP"]?   CircleAvatar(
            backgroundImage: NetworkImage(
             "${UserInfoList[UserInfoList.length - 1]["imageProFile"]}",
            ),
            radius: 18,
          ):CircleAvatar(backgroundImage: AssetImage(img),
            child: Text("${UserInfoList[0]["name"].toString().substring(0,1).toUpperCase()}",
              style:
              TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
          ),
        ],
      ),
    ),
  );
}


/*
     Container(color:myAppBarColor,alignment:Alignment.bottomCenter ,margin: EdgeInsets.only(top: 8),
            child: Row(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width-100,
                    height: 55,
                    child: TextField(
                      controller: messageEditingController,
                      decoration: InputDecoration(
                        hintText: 'Tayp Your Message',
                        hintStyle: TextStyle(color: Colors.white54),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () => sendMessage("${widget.Name}","${widget.Image}"),
                    child: Container(
                      padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                      child: const Text('Send', style: TextStyle(color: Colors.blue),),
                    ),
                  )
                ]),
          )
    bottomSheet: BottomSheet(onClosing: (){dispose();}, builder: (context){
      return Container(
        color: Colors.blueAccent,
        child:Row(
          children: [Text("data"),
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 8),
              child: TextField(
                controller: messageEditingController,
                decoration: InputDecoration(
                  hintText: 'Tayp Your Message',
                  border: InputBorder.none,
                ),
              ),
            ),
            InkWell(
              onTap: () => sendMessage("${widget.Name}","${widget.Image}"),
              child: Container(
                padding:
                const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                child: const Text(
                  'Send',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            )
          ],
        ) ,
      );
    }),*/