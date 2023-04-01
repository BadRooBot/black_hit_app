import 'dart:developer';
import 'package:AliStore/Ads/AdManager.dart';
import 'package:AliStore/Ads/tapjoy.dart';
import 'package:AliStore/Shop/GameShop/allGames.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:AliStore/Dashbord/GroupInfo.dart';
import 'package:AliStore/Dashbord/Request.dart';
import 'package:AliStore/Dashbord/messageAcitvity.dart';
import 'package:AliStore/Dashbord/profile.dart';
import 'package:AliStore/Dashbord/search_screen.dart';
import 'package:AliStore/Shop/AddItemToShop.dart';
import 'package:AliStore/Shop/ShopItem.dart';
import 'package:AliStore/constants.dart';
import 'package:AliStore/i18n/languageList.dart';
import 'package:AliStore/main.dart';
import 'package:AliStore/post/post_card.dart';
import 'package:fwfh_cached_network_image/fwfh_cached_network_image.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:AliStore/resources/Localizations_constants.dart';
import 'package:AliStore/resources/MyWidgetFactory.dart';
import 'package:AliStore/resources/realtime_database_methods.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';

import '../alert.dart';
import '../post/follow_button.dart';
import '../resources/Delete_Button.dart';
import '../resources/firestore_methods.dart';
import 'AllUser.dart';

final scrollController=ScrollController();
final scrollControllerUser=ScrollController();
var myS=23.0;
var user = FirebaseAuth.instance.currentUser;
CollectionReference userin = FirebaseFirestore.instance.collection("users");
CollectionReference userinfoRef =
FirebaseFirestore.instance.collection("users");
List myListInfo = [];
List myListStorys = [];
List myListInfoForGroup = [];
List AllUsersListInfo = [];
List UserInfoList = [];
bool VIP=false;
bool VIP2=false;
String img='assets/back.jpg';
dynamic pageControle;
int selectedIndex = 0;
int limitPosts=3;
int limitGroup=7;
int limitLastChat=7;

dynamic lastPost="";

var YourNames="";var YourImageeee="";var GroupsName="";var GroupsImage="";var YourVIP="";var GroupsVIP="";
class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  _homeState createState() => _homeState();
}

class _homeState extends State<home> with SingleTickerProviderStateMixin{
 PageController _pageController=new PageController(initialPage: 0,viewportFraction: 1.0,keepPage: false);
 late TabController myControler ;
 bool isDone=false;
 bool IsFirstTime=false;
 bool _showBanner = false;

 GlobalKey TabBarKey=new GlobalKey();

 getMyData() async {
   if(UserInfoList.isEmpty){
     List _val=await realtimeDb().GetOneUserData(Id: "${FirebaseAuth.instance.currentUser!.uid}");
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
   if((UserInfoList[0]['name']=="OneLand User")||UserInfoList[0]['name']==null){
     Navigator.pushReplacementNamed(context, "getUserInfo");
   }
 }
 /*getAllUserInfo() async {
   myListInfo.clear();
   var inof = await userinfoRef.get();
   inof.docs.forEach((element) {
     setState(() {
      myListInfo.add(element.data());

     });
   });
 }*/


 getAllUser(bool IsFirstTime2) async {
   var  realDb  =new realtimeDb();

   int lu=2;
   if(myS>=550){
     lu=15;
   }else{
     lu=10;
   }
   var _val;
   if(IsFirstTime2) {
     _val=await realDb.GetAllUserData(Limite: lu);
     setState(() {
       AllUsersListInfo=_val;
     });
   /*  var inof2 = await userinfoRef.orderBy("uID").limit(lu).get();
     inof2.docs.forEach((element) {
       setState(() {
         AllUsersListInfo.add(element.data());
       });
     });
     */
   }else{
     _val=await realDb.GetAllUserData(Limite: lu);
     setState(() {
       AllUsersListInfo=_val;
     });
    /* var inof = await userinfoRef.orderBy("uID").startAt([AllUsersListInfo[AllUsersListInfo.length-1]["uID"]]).limit(lu).get();
     inof.docs.forEach((element) {
       setState(() {
         if(AllUsersListInfo[AllUsersListInfo.length-1]["uID"]!=element["uID"]){
         AllUsersListInfo.add(element.data());
         }
       });
     });*/
   }
 }
 setOnlin(int on)async{
   var  realDb  =new realtimeDb();

   await realDb.SetOnline(Online:on);
   /*if(FirebaseAuth.instance.currentUser!=null) {
     var isOnline = {"Online": "0"};
     await FirebaseFirestore.instance.collection("users").doc(
         FirebaseAuth.instance.currentUser!.uid).set(
         isOnline, SetOptions(merge: true));
   }*/
 }

 @override
 void initState() {
   lastPost="";
  // getAllUserInfo();

   IsFirstTime=true;
   UnityAds.init(
     gameId: AdManager.gameId,
     testMode: false,
     onComplete: () => print('Initialization Complete'),
     onFailed: (error, message) =>
         print('Initialization Failed: $error $message'),
   );
   myControler = new TabController(length: 3, vsync: this);
   getMyData();
   setOnlin(0);
  // getAllUser(true);

   CustomCacheManager();

   super.initState();
 }
 void onPageChanged(int page) {
   setState(() {
     selectedIndex = page;
     myControler.index=page;
     scrollController.addListener(() {
       if(scrollController.offset>=scrollController.position.maxScrollExtent){
         switch(selectedIndex){
           case 0:
             setState(() {
               limitLastChat+=5;
             });
             break;
           case 1:
          /*   setState(() {
               getAllUser(false);
             });*/
             setState(() {
               limitGroup+=5;
             });
             break;
           case 2:
            /* setState(() {
               limitGroup+=5;
             });*/
             setState(() {
               limitPosts=limitPosts+2;
             });
             break;
           case 3:
          /*   setState(() {
               limitPosts=limitPosts+2;
             });*/
             break;
         }

       }
     });
     /*scrollControllerUser.addListener(() {
       if(scrollControllerUser.offset>=scrollControllerUser.position.maxScrollExtent){
         getNameAndImage(FirebaseAuth.instance.currentUser!.uid);
         print("++++++++++++++++++2+++$selectedIndex");
         switch(selectedIndex){
           case 0:
             break;
           case 1:
             getAllUser(false);
             break;
           case 2:
             setState(() {
               limitGroup+=5;

             });
             break;
           case 3:
             setState(() {
               limitPosts=limitPosts+2;
             });
             break;
         }

       }
     });*/


   });
 }
 testDb()async{
   dynamic d=[];
   dynamic a=[];
//    a=await realtimeDb().AddCommentToBlog(BlogId: '00001',CommentText: 'CommentText',IsVIP: false,MyId: 65654,Name: 'Mesho',ProfileImage: 'dddddddd');
  //  a=await realtimeDb().GetCommentToBlog(BlogId:'00001' ,Limit: 2);
  //  a=await realtimeDb().CreateNewUser(Token: "tttttttttttttttttttttttt",Email: 'EEEEEEEEEEEEEEEEEEEEEEEEEE');
//await realtimeDb().Addfollows(Id: '8haZkSrgkQRl9LRMliMBTiL29P92',followers:  true);

  /* List dataUpdate =await realtimeDb().GetOneUserData(
       Id: FirebaseAuth.instance.currentUser!.uid);
   dataUpdate.forEach((element) {
     a=element;
   });
   setState(() {
   d=a;
});
  print('======================Data dsdsss  \n  ${d.toString()}');
  print('======================Data Update  \n  ${dataUpdate}');
*/


   a= await realtimeDb().SearchUsers(Name: 'Abo sherif');

   print('======================Data Update  \n  ${a}');
 }

 @override
  Widget build(BuildContext context) {
  setState(() {
    myS=MediaQuery.of(context).size.height;
  });

    getAllUser(false);
    String  Story=getTranslated(context,"Story");
    String  Group=getTranslated(context,"Group");
    String  _LastChat=getTranslated(context,"LastChat");
    String  _AllUsers=getTranslated(context,"AllUsers");
    return Scaffold(
      drawer: DrawerApp(context),
      appBar: AppBar(
        actions: [ Padding(
          padding: const EdgeInsets.all(10.0),
          child: InkWell(child: Icon(Icons.people_alt_outlined),onTap: (){
            Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AllUser(),
                ));

          },),
        ),
          Visibility(visible: false,
            child: InkWell(child: Icon(Icons.search),onTap: (){
              Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SearchScreen(),
                  ));
            },),
          )
        ],
      elevation: 0,
      bottom: TabBar(
        key: TabBarKey,labelPadding: EdgeInsets.symmetric(horizontal: 10),isScrollable: true,
        controller: myControler,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
            _pageController.jumpToPage(index);

          });
        },
        tabs: [
          Tab(
            child: Text("$_LastChat"),

          ),
       /*   Visibility(visible: false,
            child: Tab(
              child: Text("$_AllUsers"),

            ),
          ),*/
          Tab(
            child: Text("$Group"),

          ),
          Tab(
            child: Text("$Story"),
       
          ),
        ],
      ),
    ),
      body: Container(height: MediaQuery.of(context).size.height-80,
        child: PageView(
            onPageChanged: onPageChanged,
            controller: _pageController,
            children: [
              lastchat(context),AllGroups(context),AllPosts(context)  ,]),
      ),
      bottomNavigationBar: Container(height: 80,
        child: UnityBannerAd(
            placementId: AdManager.bannerAdPlacementId),
      ),
    );
  }

@override
  void dispose() {
  scrollController.dispose();
  setOnlin(1);
  super.dispose();
  }


}
FirebaseFirestore _firestore = FirebaseFirestore.instance;



getLastChatGroups()async{
  if(myListInfoForGroup.isEmpty){
    var noname=   await FirebaseFirestore.instance.collection('Group').get();
     noname.docs.forEach((element) {
      myListInfoForGroup.add(element.data());
    });
  }

  /*lastchat(context){
    List ListlastChat=[];
    List GroupListlastChat=[];
    bool isDone=false;
    //  getLastChatGroups();
    return Container(
      child: StreamBuilder(stream: FirebaseFirestore.instance.collection('lastChat')
          .doc(FirebaseAuth.instance.currentUser!.uid).collection("allChat").orderBy("datePublished",descending: true).snapshots()
        ,builder: (context,AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot){
          ListlastChat.clear();
          if (!snapshot.hasData) {
            ListlastChat.clear();
            GroupListlastChat.clear();
            return const Center(
              child: CircularProgressIndicator(),
            );
          }else if(snapshot.connectionState!=ConnectionState.waiting){
            ListlastChat.clear();
            GroupListlastChat.clear();
            try {
              //read All message
              return ListView.builder(controller: scrollController,
                  physics: ScrollPhysics(parent: BouncingScrollPhysics()),
                  reverse: false,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {

                    if(snapshot.data!.docs.isNotEmpty) {

                      UpdateAllNames(index)async{
                        //   ListlastChat.clear();
                        for(int num=0;num<=snapshot.data!.docs.length-1;num++){
                          try{
                            if(snapshot.data!.docs[num]['isGroup']==false) {
                              var nAndI = await _firestore.collection('users')
                                  .where('uID',
                                  isEqualTo: snapshot.data!.docs[num]['uid'])
                                  .get();
                              nAndI.docs.forEach((element) async{
                                DocumentReference myStore = FirebaseFirestore
                                    .instance.collection('lastChat')
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .collection("allChat")
                                    .doc(snapshot.data!.docs[num]['uid']);
                                if (snapshot.data!.docs[num]['uid'] ==
                                    element.data()['uID']) {
                                  if (snapshot.data!.docs[num]['name'] !=
                                      element.data()['name']) {
                                    await  myStore.update(
                                        {'name': element.data()['name']});
                                  }
                                  if (snapshot.data!.docs[num]['profilePic'] !=
                                      element.data()['imageProFile']) {
                                    await myStore.update({
                                      'profilePic': element.data()['imageProFile']
                                    });
                                  }
                                  if (snapshot.data!.docs[num]['VIP'] !=
                                      element.data()['VIP']) {
                                    await myStore.update({'VIP': element.data()['VIP']});
                                  }
                                  if (snapshot.data!.docs[num]['Online'] !=
                                      element.data()['Online']) {
                                    await  myStore.update({'Online': element.data()['Online']});
                                  }
                                }
                              });
                              isDone=true;
                            }
                            else{

                              var nAndI = await _firestore.collection('Group')
                                  .where('GroupId',
                                  isEqualTo: snapshot.data!.docs[num]['uid'])
                                  .get();
                              nAndI.docs.forEach((element) async{
                                DocumentReference myStore = FirebaseFirestore
                                    .instance.collection('lastChat')
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .collection("allChat")
                                    .doc(snapshot.data!.docs[num]['uid']);
                                if (snapshot.data!.docs[num]['uid'] ==
                                    element.data()['GroupId']) {
                                  if (snapshot.data!.docs[num]['name'] !=
                                      element.data()['name']) {
                                    await myStore.update(
                                        {'name': element.data()['name']});
                                  }
                                  if (snapshot.data!.docs[num]['profilePic'] !=
                                      element.data()['profilePic']) {
                                    await  myStore.update({
                                      'profilePic': element.data()['profilePic']
                                    });
                                  }
                                  if (snapshot.data!.docs[num]['VIP'] !=
                                      element.data()['VIP']) {
                                    await myStore.update({'VIP': element.data()['VIP']});
                                  }
                                  if (snapshot.data!.docs[num]['Online'] !=
                                      element.data()['Online']) {
                                    await myStore.update({'Online': element.data()['Online']});
                                  }
                                }
                              });
                            }

                          }catch(d){ print('++++++++++++++++Enter Error  $d');}

                        }
                        isDone=true;
                      }

                      if(index==(snapshot.data?.docs.length)!-1){
                        UpdateAllNames(0);
                      }


                      mynames(x)async{
                        if(snapshot.data!.docs[x]['isGroup']==false){
                          print('=========================Enter ========================');
                          ListlastChat.add(snapshot.data!.docs[x]);
                          var getnamesss=await   _firestore.collection('users').where('uID',isEqualTo:snapshot.data!.docs[x]['uid'] ).get();
                          print('=========================After Get ========================');

                          getnamesss.docs.forEach((element) {

                            ListlastChat[x]['name']=  element['name'];
                            ListlastChat[x]['VIP']=element.data()['VIP'];
                            ListlastChat[x]['profilePic']=element.data()['imageProFile'];
                            ListlastChat[x]['Online']=element.data()['Online'];


                            print('=========================endData ${ListlastChat[x]}');
                            print('=========================end ========================');


                          });

                        }else{
                          GroupListlastChat.add(snapshot.data!.docs[x]);
                          var getnamesssGroup=await   _firestore.collection('users').where('uID',isEqualTo:snapshot.data!.docs[x]['uid'] ).get();
                          getnamesssGroup.docs.forEach((element) {
                            GroupListlastChat[x]['name']=element.data()['name'];
                            GroupListlastChat[x]['VIP']=element.data()['VIP'];
                            GroupListlastChat[x]['profilePic']=element.data()['profilePic'];
                            GroupListlastChat[x]['Online']=element.data()['Online'];

                          });
                        }
                      }
                      //  mynames(index);

                      UpdateAllNamesGroups(index)async{
                        //   ListlastChat.clear();
                        if(snapshot.data!.docs[index]["isGroup"] == true){
                          for(int num=0;num<=snapshot.data!.docs.length-1;num++){
                            GroupListlastChat.add(snapshot.data!.docs[index]);
                            var nAndI=await _firestore.collection('Group').where('GroupId',isEqualTo:snapshot.data!.docs[index]['uid'] ).get();
                            nAndI.docs.forEach((element) {
                              GroupListlastChat[index]['name'] =element['name'];
                              GroupListlastChat[index]['profilePic']=element['profilePic'];
                              GroupListlastChat[index]['VIP']=element['VIP'];
                              GroupListlastChat[index]['Online']=element['Online'];


                            });
                          }}
                      }
                      //UpdateAllNamesGroups(index);
                      GetAllname(index) {
                        var res="";
                        if (myListInfo.isNotEmpty) {
                          for (int num = 0; num < myListInfo.length ;  num++) {
                            if (myListInfo[num]["uID"]==snapshot.data!.docs[index]["uid"]){
                              return myListInfo[num]["name"];
                            }else{
                              res=" ";
                            }
                          }
                        }
                        return  res;
                      }
                      getGroupVIP(index) {
                        for (int x = 0; x < myListInfoForGroup.length; x++) {
                          if (myListInfoForGroup[x]["GroupId"] ==
                              snapshot.data!.docs[index]["uid"]) {
                            return myListInfoForGroup[x]["VIP"];
                          }
                        }
                        return false;
                      }
                      getVIP(index){
                        for(int x=0;x<myListInfo.length;x++){
                          if (myListInfo[x]["uID"]==snapshot.data!.docs[index]["uid"]){
                            return myListInfo[x]["VIP"];
                          }else if((x<myListInfo.length)){
                            return getGroupVIP(index);
                          }
                        }
                        return false;
                      }
                      GetAllnameGroup(index) {
                        for(int x=0;x<myListInfoForGroup.length;x++){
                          if (myListInfoForGroup[x]["GroupId"]==snapshot.data!.docs[index]["uid"]){
                            return myListInfoForGroup[x]["name"];
                          }
                        }
                        return "Bad ROoBot";
                      }
                      GetAllImage(index) {
                        for(int x=0;x<myListInfo.length;x++){
                          if (myListInfo[x]["uID"]==snapshot.data!.docs[index]["uid"]){
                            return myListInfo[x]["imageProFile"];

                          }
                        }return "Bad ROoBot";

                      }
                      GetAllImageGroup(index) {
                        for(int x=0;x<myListInfoForGroup.length;x++){
                          if (myListInfoForGroup[x]["GroupId"]==snapshot.data!.docs[index]["uid"]){
                            return myListInfoForGroup[x]["profilePic"].toString();
                          }
                        }return "Bad ROoBot";

                      }
                      //  bool onelineOrNot=true;//snapshot.data!.docs[index]["isGroup"]?ListlastChat[index]['Online']==0:GroupListlastChat[index]['Online']==0;
                      return isDone?SizedBox(width: MediaQuery.of(context).size.width-1.7,height: 90,
                        child: InkWell(onTap: () {
                          Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    message(
                                      Name:snapshot.data!.docs[index]["isGroup"] == true
                                          ?  snapshot.data!.docs[index]['name']
                                          : snapshot.data!.docs[index]['name'],
                                      Image: snapshot.data!.docs[index]["isGroup"] == true
                                          ?  snapshot.data!.docs[index]['profilePic']:
                                      snapshot.data!.docs[index]['profilePic'],
                                      Uid: "${snapshot.data!.docs[index]["uid"]}",
                                      isGroup: snapshot.data!.docs[index]["isGroup"],
                                      VIP: snapshot.data!.docs[index]["isGroup"]?snapshot.data!.docs[index]['VIP']:snapshot.data!.docs[index]['VIP'] ,

                                    ),
                              ));
                        },
                          splashColor: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(15),
                          child: Card(shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                            elevation: 0,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 20.0 * 0.75),
                              child: Row(
                                children: [
                                  Stack(
                                    children: [
                                      CircleAvatar(
                                          radius: 23,backgroundImage:AssetImage(img) ,
                                          child:
                                          snapshot.data!.docs[index]['VIP']==true?
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(25),
                                            child: Container(
                                              width: 46, height: 46,
                                              child: HtmlWidget(
                                                '<img width="46" height="46" src="${ snapshot.data!.docs[index]["isGroup"] == true
                                                    ? snapshot.data!.docs[index]['profilePic']
                                                    : snapshot.data!.docs[index]['profilePic']}" '
                                                    '/>',
                                                factoryBuilder: () => MyWidgetFactory(),
                                                enableCaching: true,
                                              ),
                                            ),
                                          ):
                                          Text("${ snapshot.data!.docs[index]["isGroup"] == true
                                              ? snapshot.data!.docs[index]['name'].toString().substring(0,1).toUpperCase()
                                              : snapshot.data!.docs[index]['name'].toString().substring(0,1).toUpperCase()
                                          }",style:
                                          TextStyle(fontSize: 24,fontWeight: FontWeight.bold),)

                                      ),
                                      *//* CircleAvatar(
                          radius: 24,
                          backgroundImage:  NetworkImage(
                           "${GetAllImage(index)==null?GetAllImageGroup(index):GetAllImage(index)}",
                          ),
                        ),*//*
                                      Visibility(visible:snapshot.data!.docs[index]['Online'] ==0,
                                        child: Positioned(
                                          right: 0,
                                          bottom: 0,
                                          child: Container(
                                            height: 16,
                                            width: 16,
                                            decoration: BoxDecoration(
                                              color: Color(0xFF00BF6D),
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color: Theme
                                                      .of(context)
                                                      .scaffoldBackgroundColor,
                                                  width: 3),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Container(
                                    height: 52,
                                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                    width: (MediaQuery
                                        .of(context)
                                        .size
                                        .width -1.7)/ 2.1,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${snapshot.data!.docs[index]["isGroup"] == true
                                              ? snapshot.data!.docs[index]['name']
                                              : snapshot.data!.docs[index]['name']}"
                                          ,textAlign:TextAlign.start
                                          , maxLines: 1,
                                          style:
                                          TextStyle(
                                              fontSize: 16, fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(height: 6,),

                                        Opacity(
                                          opacity: 0.64,
                                          child: Text('${snapshot.data!.docs[index]['text']}',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign:TextAlign.start

                                          ),
                                        ),

                                      ],
                                    ),
                                  ),
                                  Opacity(
                                    opacity: .67,
                                    child: Text(DateFormat.yMMMd().format(
                                      snapshot.data!.docs[index]['datePublished'].toDate(),
                                    ),textAlign:TextAlign.end
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ):index==0? Center(
                          child: LinearProgressIndicator()
                      ):Text('');
                    }else{
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  });
            }catch(e){
              print('============================================================Data $e');
              return Text('');
            }

          }
          else{
            return const Center(
              child: CircularProgressIndicator(),
            );
          }


        },),
    );

  }
*/

}

lastchat(context){
  List ListlastChat=[];
  List GroupListlastChat=[];

  //  getLastChatGroups();
  try {
    return Container(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('lastChat')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection("allChat")
            .orderBy("datePublished", descending: true)
            .snapshots()
        ,
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          ListlastChat.clear();
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.connectionState != ConnectionState.waiting||snapshot.hasData) {
            ListlastChat.clear();
            GroupListlastChat.clear();
            try {
              //read All message
              return ListView.builder(controller: scrollController,
                  physics: ScrollPhysics(parent: BouncingScrollPhysics()),
                  reverse: false,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    if (snapshot.data!.docs.isNotEmpty) {
                      UpdateAllNames(index) async {
                        //   ListlastChat.clear();
                        for (int num = 0; num <= snapshot.data!.docs.length -
                            1; num++) {
                          try {
                            if (snapshot.data!.docs[num]['isGroup'] == false) {
                              /* var nAndI = await _firestore.collection('users')
                                .where('uID',
                                isEqualTo: snapshot.data!.docs[num]['uid'])
                                .get();*/

                              var dataUpdate =await realtimeDb().GetOneUserData(
                                  Id: snapshot.data!.docs[num]['uid']);
                              dataUpdate.forEach((element) async {
                                DocumentReference myStore = FirebaseFirestore
                                    .instance.collection('lastChat')
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .collection("allChat")
                                    .doc(snapshot.data!.docs[num]['uid']);

                                if (snapshot.data!.docs[num]['uid'] ==
                                    element['uID']) {
                                  if (snapshot.data!.docs[num]['name'] !=
                                      element['name']) {
                                    await myStore.update(
                                        {'name': element['name']});
                                  }
                                  if (snapshot.data!.docs[num]['profilePic'] !=
                                      element['imageProFile']) {
                                    await myStore.update({
                                      'profilePic': element['imageProFile']
                                    });
                                  }
                                  if (snapshot.data!.docs[num]['VIP'] !=
                                      element['VIP']) {
                                    await myStore.update(
                                        {'VIP': element['VIP']});
                                  }
                                  if (snapshot.data!.docs[num]['Online'] !=
                                      element['Online']) {
                                    await myStore.update(
                                        {'Online': element['Online']});
                                  }
                                }
                              });
                            }
                            else {
                              var nAndI = await _firestore.collection('Group')
                                  .where('GroupId',
                                  isEqualTo: snapshot.data!.docs[num]['uid'])
                                  .get();
                              nAndI.docs.forEach((element) async {
                                DocumentReference myStore = FirebaseFirestore
                                    .instance.collection('lastChat')
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .collection("allChat")
                                    .doc(snapshot.data!.docs[num]['uid']);
                                if (snapshot.data!.docs[num]['uid'] ==
                                    element.data()['GroupId']) {
                                  if (snapshot.data!.docs[num]['name'] !=
                                      element.data()['name']) {
                                    await myStore.update(
                                        {'name': element.data()['name']});
                                  }
                                  if (snapshot.data!.docs[num]['profilePic'] !=
                                      element.data()['profilePic']) {
                                    await myStore.update({
                                      'profilePic': element.data()['profilePic']
                                    });
                                  }
                                  if (snapshot.data!.docs[num]['VIP'] !=
                                      element.data()['VIP']) {
                                    await myStore.update(
                                        {'VIP': element.data()['VIP']});
                                  }
                                  if (snapshot.data!.docs[num]['Online'] !=
                                      element.data()['Online']) {
                                    await myStore.update(
                                        {'Online': element.data()['Online']});
                                  }
                                }
                              });
                            }
                          } catch (d) {
                            print('++++++++++++++++Enter Error  $d');
                          }
                        }
                      }
                      UpdateAllNames(index);


                      mynames(x) async {
                        if (snapshot.data!.docs[x]['isGroup'] == false) {
                          print(
                              '=========================Enter ========================');
                          ListlastChat.add(snapshot.data!.docs[x]);
                          var getnamesss = await _firestore.collection('users')
                              .where(
                              'uID', isEqualTo: snapshot.data!.docs[x]['uid'])
                              .get();
                          print(
                              '=========================After Get ========================');

                          getnamesss.docs.forEach((element) {
                            ListlastChat[x]['name'] = element['name'];
                            ListlastChat[x]['VIP'] = element.data()['VIP'];
                            ListlastChat[x]['profilePic'] =
                            element.data()['imageProFile'];
                            ListlastChat[x]['Online'] =
                            element.data()['Online'];


                            print(
                                '=========================endData ${ListlastChat[x]}');
                            print(
                                '=========================end ========================');
                          });
                        } else {
                          GroupListlastChat.add(snapshot.data!.docs[x]);
                          var getnamesssGroup = await _firestore.collection(
                              'users')
                              .where(
                              'uID', isEqualTo: snapshot.data!.docs[x]['uid'])
                              .get();
                          getnamesssGroup.docs.forEach((element) {
                            GroupListlastChat[x]['name'] =
                            element.data()['name'];
                            GroupListlastChat[x]['VIP'] = element.data()['VIP'];
                            GroupListlastChat[x]['profilePic'] =
                            element.data()['profilePic'];
                            GroupListlastChat[x]['Online'] =
                            element.data()['Online'];
                          });
                        }
                      }
                      //  mynames(index);

                      UpdateAllNamesGroups(index) async {
                        //   ListlastChat.clear();
                        if (snapshot.data!.docs[index]["isGroup"] == true) {
                          for (int num = 0; num <= snapshot.data!.docs.length -
                              1; num++) {
                            GroupListlastChat.add(snapshot.data!.docs[index]);
                            var nAndI = await _firestore.collection('Group')
                                .where('GroupId',
                                isEqualTo: snapshot.data!.docs[index]['uid'])
                                .get();
                            nAndI.docs.forEach((element) {
                              GroupListlastChat[index]['name'] =
                              element['name'];
                              GroupListlastChat[index]['profilePic'] =
                              element['profilePic'];
                              GroupListlastChat[index]['VIP'] = element['VIP'];
                              GroupListlastChat[index]['Online'] =
                              element['Online'];
                            });
                          }
                        }
                      }
                      //UpdateAllNamesGroups(index);
                      GetAllname(index) {
                        var res = "";
                        if (myListInfo.isNotEmpty) {
                          for (int num = 0; num < myListInfo.length; num++) {
                            if (myListInfo[num]["uID"] ==
                                snapshot.data!.docs[index]["uid"]) {
                              return myListInfo[num]["name"];
                            } else {
                              res = " ";
                            }
                          }
                        }
                        return res;
                      }
                      getGroupVIP(index) {
                        for (int x = 0; x < myListInfoForGroup.length; x++) {
                          if (myListInfoForGroup[x]["GroupId"] ==
                              snapshot.data!.docs[index]["uid"]) {
                            return myListInfoForGroup[x]["VIP"];
                          }
                        }
                        return false;
                      }
                      getVIP(index) {
                        for (int x = 0; x < myListInfo.length; x++) {
                          if (myListInfo[x]["uID"] == snapshot.data!
                              .docs[index]["uid"]) {
                            return myListInfo[x]["VIP"];
                          } else if ((x < myListInfo.length)) {
                            return getGroupVIP(index);
                          }
                        }
                        return false;
                      }
                      GetAllnameGroup(index) {
                        for (int x = 0; x < myListInfoForGroup.length; x++) {
                          if (myListInfoForGroup[x]["GroupId"] == snapshot.data!
                              .docs[index]["uid"]) {
                            return myListInfoForGroup[x]["name"];
                          }
                        }
                        return "Bad ROoBot";
                      }
                      GetAllImage(index) {
                        for (int x = 0; x < myListInfo.length; x++) {
                          if (myListInfo[x]["uID"] == snapshot.data!
                              .docs[index]["uid"]) {
                            return myListInfo[x]["imageProFile"];
                          }
                        }
                        return "Bad ROoBot";
                      }
                      GetAllImageGroup(index) {
                        for (int x = 0; x < myListInfoForGroup.length; x++) {
                          if (myListInfoForGroup[x]["GroupId"] == snapshot.data!
                              .docs[index]["uid"]) {
                            return myListInfoForGroup[x]["profilePic"]
                                .toString();
                          }
                        }
                        return "Bad ROoBot";
                      }
                      //  bool onelineOrNot=true;//snapshot.data!.docs[index]["isGroup"]?ListlastChat[index]['Online']==0:GroupListlastChat[index]['Online']==0;
                      return true ? SizedBox(width: MediaQuery
                          .of(context)
                          .size
                          .width - 1.7, height: 90,
                        child: InkWell(onLongPress: (){
                          DeleteView(LastMessageId: snapshot.data!.docs[index]['uid'], YourId:snapshot.data!.docs[index]['uid'], IsGroup: snapshot.data!.docs[index]['isGroup'], context: context);
                        },
                          onTap: () {
                          Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    message(
                                      Name: snapshot.data!
                                          .docs[index]["isGroup"] == true
                                          ? snapshot.data!.docs[index]['name']
                                          : snapshot.data!.docs[index]['name'],
                                      Image: snapshot.data!
                                          .docs[index]["isGroup"] == true
                                          ? snapshot.data!
                                          .docs[index]['profilePic'] :
                                      snapshot.data!.docs[index]['profilePic'],
                                      Uid: "${snapshot.data!
                                          .docs[index]["uid"]}",
                                      isGroup: snapshot.data!
                                          .docs[index]["isGroup"],
                                      VIP: snapshot.data!.docs[index]["isGroup"]
                                          ? snapshot.data!.docs[index]['VIP']
                                          : snapshot.data!.docs[index]['VIP'],

                                    ),
                              ));
                        },
                          splashColor: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(15),
                          child: Card(shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                            elevation: 0,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 20.0 * 0.75),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Stack(
                                    children: [
                                      CircleAvatar(
                                          radius: 23,
                                          backgroundImage: AssetImage(img),
                                          child:
                                          snapshot.data!.docs[index]['VIP'] ==
                                              true ?
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                                25),
                                            child: Container(
                                              width: 46, height: 46,
                                              child: HtmlWidget(
                                                '<img width="46" height="46" src="${ snapshot
                                                    .data!
                                                    .docs[index]["isGroup"] ==
                                                    true
                                                    ? snapshot.data!
                                                    .docs[index]['profilePic']
                                                    : snapshot.data!
                                                    .docs[index]['profilePic']}" '
                                                    '/>',
                                                factoryBuilder: () =>
                                                    MyWidgetFactory(),
                                                enableCaching: true,
                                              ),
                                            ),
                                          ) :
                                          Text("${ snapshot.data!
                                              .docs[index]["isGroup"] == true
                                              ? snapshot.data!
                                              .docs[index]['name']
                                              .toString()
                                              .substring(0, 1)
                                              .toUpperCase()
                                              : snapshot.data!
                                              .docs[index]['name']
                                              .toString()
                                              .substring(0, 1)
                                              .toUpperCase()
                                          }", style:
                                          TextStyle(fontSize: 24,
                                              fontWeight: FontWeight.bold),)

                                      ),
                                      /* CircleAvatar(
                          radius: 24,
                          backgroundImage:  NetworkImage(
                           "${GetAllImage(index)==null?GetAllImageGroup(index):GetAllImage(index)}",
                          ),
                        ),*/
                                      Visibility(visible: snapshot.data!
                                          .docs[index]['Online'] == 0,
                                        child: Positioned(
                                          right: 0,
                                          bottom: 0,
                                          child: Container(
                                            height: 16,
                                            width: 16,
                                            decoration: BoxDecoration(
                                              color: Color(0xFF00BF6D),
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                  color: Theme
                                                      .of(context)
                                                      .scaffoldBackgroundColor,
                                                  width: 3),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Flexible(flex: 4,
                                    child: Container(
                                      height: 52,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      width: (MediaQuery
                                          .of(context)
                                          .size
                                          .width - 1.7) / 2.1,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        children: [
                                          Text(
                                            "${snapshot.data!
                                                .docs[index]["isGroup"] == true
                                                ? snapshot.data!
                                                .docs[index]['name']
                                                : snapshot.data!
                                                .docs[index]['name']}"
                                            , textAlign: TextAlign.start
                                            , maxLines: 1,
                                            style:
                                            TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          SizedBox(height: 6,),

                                          Opacity(
                                            opacity: 0.64,
                                            child: Text('${snapshot.data!
                                                .docs[index]['text']}',
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                textAlign: TextAlign.start

                                            ),
                                          ),

                                        ],
                                      ),
                                    ),
                                  ),
                                  Flexible(flex: 1, child: SizedBox(width: 5,)),
                                  Flexible(flex: 1,
                                    child: Container(
                                      alignment: Alignment.centerRight,
                                      child: Opacity(
                                        opacity: .67,
                                        child: Text(DateFormat.yMMMd().format(
                                          snapshot.data!
                                              .docs[index]['datePublished']
                                              .toDate(),
                                        ), textAlign: TextAlign.end
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ) : index == 0 ? Center(
                          child: LinearProgressIndicator()
                      ) : Text('');
                    } else {
                      return const Center(
                        child:CircularProgressIndicator(),
                      );
                    }
                  });
            } catch (e) {
              print(
                  '============================================================Data $e');
              return Text('');
            }
          }
          else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },),
    );
  }catch(e){
    print('========================EEEror   $e');
  }
}


AllGroups(context){
  return Scaffold(
    floatingActionButton: FloatingActionButton(child:Icon(Icons.add) ,backgroundColor: myAppBarColor,tooltip: 'Caret New Group',onPressed: (){
      Navigator.of(context).pushNamed("addNewGroup");
    }),
    body: Container(
      child:
        StreamBuilder(stream: FirebaseFirestore.instance.collection('Group').orderBy("name",descending: true).limit(limitGroup).snapshots()
          ,builder: (context,AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot){

            if (snapshot.hasData) {
               //read All message
             return ListView.builder(controller: scrollController,physics: ScrollPhysics(parent:BouncingScrollPhysics()),reverse: false,itemCount: snapshot.data!.docs.length,itemBuilder: (context,index){
              return Column(
                children: [
                  SizedBox(width: MediaQuery.of(context).size.width-1.7,height: 90,
                    child: InkWell(onTap: (){
                      List Stmember=snapshot.data!.docs[index]["member"];
                      if(Stmember.contains(FirebaseAuth.instance.currentUser!.uid)){
                        Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => message(
                                Name:"${snapshot.data!.docs[index]["name"]}",
                                Image: "${snapshot.data!.docs[index]["profilePic"]}",
                                Uid: "${snapshot.data!.docs[index]["GroupId"]}",
                                isGroup: true,VIP:snapshot.data!.docs[index]["VIP"] ,
                              ),
                            ));
                      }else{
                           Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => GroupInfo(
                                  uid:"${snapshot.data!.docs[index]["GroupId"]}",
                                ),
                              ));
                      }
                    },splashColor: Colors.blueAccent,borderRadius: BorderRadius.circular(15),
                      child: Card(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        elevation: 0,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal:  20.0, vertical:  20.0 * 0.75),
                          child: Row(mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Stack(
                                children: [

                               snapshot.data!.docs[index]["VIP"]?ClipRRect(borderRadius:  BorderRadius.circular(25),
                          child: Container(
                            width: 46,height: 46,
                            child: HtmlWidget(
                              '<img width="46" height="46" src="${snapshot.data!.docs[index]['profilePic']}" '
                                  '/>',
                              factoryBuilder: () => MyWidgetFactory(),enableCaching: true,
                            ),
                          ),
                        ):CircleAvatar(backgroundImage: AssetImage(img),
                          child: Text("${snapshot.data!.docs[index]["name"].toString().substring(0,1).toUpperCase()}",
                            style:
                          TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
                        ),
                                /*  CircleAvatar(
                                    radius: 24,
                                    backgroundImage:  NetworkImage(
                                      snapshot.data!.docs[index]['profilePic'],
                                    ),
                                  ),*/
                                  if (true)
                                    Positioned(
                                      right: 0,
                                      bottom: 0,
                                      child: Container(
                                        height: 16,
                                        width: 16,
                                        decoration: BoxDecoration(
                                          color: Color(0xFF00BF6D),
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: Theme.of(context).scaffoldBackgroundColor,
                                              width: 3),
                                        ),
                                      ),
                                    )
                                ],
                              ),
                              Container(
                                height: 58,
                                width: (MediaQuery
                                    .of(context)
                                    .size
                                    .width )/  1.8,
                                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children:  [
                                    Text(
                                      snapshot.data!.docs[index]['name'],
                                      style:
                                      TextStyle(fontSize: 16, fontWeight: FontWeight.w500),maxLines: 1,
                                    ),
                                    SizedBox(height: 6),
                                    Opacity(
                                      opacity: 0.64,
                                      child: Text(snapshot.data!.docs[index]['bio'],
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Opacity(
                                opacity: .67,
                                child: InkWell(splashColor: Colors.black,
                                    onTap: (){
                          Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => GroupInfo(
                                  uid:"${snapshot.data!.docs[index]["GroupId"]}",
                                ),
                              ));
                                    },
                                    child: Icon(Icons.info_outline_rounded, size: 32,)),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Divider(height: 2,color: Colors.blueGrey),
                ],
              );
            });
            }else{  return const Center(
              child: CircularProgressIndicator(),
            );}




          },),
    ),
  );
}

AllPosts(context){
  var width=MediaQuery.of(context).size.width;
 return StreamBuilder(
    stream: FirebaseFirestore.instance.collection('posts').orderBy("datePublished",descending: true).startAfter([lastPost]).limit(limitPosts).snapshots(includeMetadataChanges: true),
    builder: (context,
        AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {

     if (snapshot!=null&&snapshot.data!=null) {

       //myListStorys.clear();
       snapshot.data!.docs.forEach((element) {
         myListStorys.add(element);
       });
       return ListView.builder(physics: ScrollPhysics(parent:BouncingScrollPhysics()),controller: scrollController,addAutomaticKeepAlives: true,addSemanticIndexes: true,
         itemCount: snapshot.data?.docs.length,
         itemBuilder: (ctx, index) {

     return Container(
      margin: EdgeInsets.symmetric(
      horizontal: width > 600 ? width * 0.3 : 0,
      vertical: width > 600 ? 15 : 0,
      ),
      child: PostCard(
      snap: snapshot.data!.docs[index].data(),
      ),
      );
      });

      }else{
       return const Center(
         child: CircularProgressIndicator(),
       );

     }

    },
  );
}

DrawerApp(context) {

String  Home=getTranslated(context,"Home");
String  ProFile=getTranslated(context,"ProFile");
String  AddNewStory=getTranslated(context,"AddNewStory");
String  _Request=getTranslated(context,"Request");
String  Logout=getTranslated(context,"Logout");
String  _AddItemToShop=getTranslated(context,"AddItemToShop");
String  Shop=getTranslated(context,"Shop");
String  GetPoint=getTranslated(context,"GetPoint");
String  blog=getTranslated(context,"blog");

if(UserInfoList.isNotEmpty){
  if(UserInfoList[0]["VIP"]!=null)
  VIP=UserInfoList[0]["VIP"];
}
//List<DropdownMenuItem<String>> d=[ DropdownMenuItem(value: 1,child: Text('English')),DropdownMenuItem(value: 2,child:  Text('العربيه'))];
  void _onChangedLanguage(Language? lang) {
    Locale _temp;

    switch(lang?.languageCode){

      case ENGLSIH:
        _temp=Locale("en","");
        setLocale("en");
        break;
      case ARABIC:
        _temp=Locale("ar","");
        setLocale("ar");
        break;

      default:
        _temp=Locale("en","");
        setLocale("en");
        break;

    }
    MyApp.setLocale(context,_temp);

  }
var defName='badRoobot';
   return UserInfoList.isNotEmpty?
   Drawer(backgroundColor:Color(0xFF1C2931),
    child: ListView(
      children: [
        UserAccountsDrawerHeader(
          accountName:UserInfoList.isEmpty?Text(""):Text("${UserInfoList[0]["name"]}"),
          accountEmail:Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [UserInfoList.isEmpty?Text(""):
          Text("${UserInfoList[0]["email"]}"),
          DropdownButton(alignment: Alignment.center,
              underline:SizedBox(),
              icon:  Container(padding: EdgeInsets.symmetric(horizontal: 15),child: Icon(Icons.g_translate_outlined,color: Colors.white,)),dropdownColor: kPrimaryColor,
              items:Language.languageList().map<DropdownMenuItem<Language>>((lange) =>
                  DropdownMenuItem(value: lange,child: Text('${lange.name}',style: TextStyle(color: Colors.white),),)
              ).toList(),
              onChanged: (Language? d){
              _onChangedLanguage(d);
                },

            ),
           ], ),
          currentAccountPicture:    VIP?CircleAvatar(
            backgroundImage:UserInfoList.isEmpty?NetworkImage(""): NetworkImage(
                "${UserInfoList[0]["imageProFile"]}"),
            backgroundColor: Colors.black,
          ):CircleAvatar(backgroundImage: AssetImage(img),
            child: Text("${UserInfoList[0]["name"].toString().substring(0,1).toUpperCase()}",
              style:
              TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
          ),


        ),

        ListTile(
          title: Text("$Home",style:TextStyle(color: Colors.white) ,),
          onTap: () {
            Navigator.pushNamed(context, "home");
          },
        ),
        Visibility(visible: VIP,
          child: ListTile(
            title: Text("$Shop",style: TextStyle(color: Colors.white),),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ShopItem()
                  ));
            },
          ),
        ),
        Visibility(visible: VIP,
          child: ListTile(

            title: Text("$_AddItemToShop",style: TextStyle(color: Colors.white)),
            onTap: () {

              Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => AddItemToShop()
                  ));
            },
          ),
        ),
        ListTile(
          title: Text("$ProFile",style: TextStyle(color: Colors.white)),
          onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => profile(
                   uid: FirebaseAuth.instance.currentUser!.uid,VIP: VIP,
                  ),
                ));
          },
        ),
        ListTile(
          title: Text("$AddNewStory",style: TextStyle(color: Colors.white)),
          onTap: () {
            Navigator.pushNamed(context, "AddPostScreen");
          },
        ),
        ListTile(
          title: Text("$_Request",style: TextStyle(color: Colors.white)),
          onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => Request(),
                ));
          },
        ),
        Divider(height: 1.5,color: Colors.blueGrey),
        ListTile(
          title: Text("$Shop",style: TextStyle(color: Colors.white)),
          onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AllGames(),
                ));
          },
        ),
        ListTile(
          title: Text("$GetPoint",style: TextStyle(color: Colors.white)),
          onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => TapJoy(),
                ));
          },
        ),
        ListTile(
          title: Text("$blog",style: TextStyle(color: Colors.white)),
          onTap: () {

            Navigator.pushNamed(context, "blogpage");
          },
        ),

        Divider(height: 1.5,color: Colors.blueGrey),

        ListTile(
          title: Text("$Logout",style: TextStyle(color: Colors.white)),
          onTap: () {
            UserInfoList.clear();
            FirebaseAuth.instance.signOut().whenComplete(() =>  Navigator.pushNamed(context, "login"));
          },
        ),
        UnityBannerAd(
            placementId: AdManager.bannerAdPlacementId),
      ],
    ),
  ):
   Drawer(backgroundColor:Color(0xFF1C2931),
    child: ListView(
      children: [
        UserAccountsDrawerHeader(
          accountName:Text(''),
          accountEmail:Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [Text(''),
          DropdownButton(alignment: Alignment.center,
              underline:SizedBox(),
              icon:  Container(padding: EdgeInsets.symmetric(horizontal: 15),child: Icon(Icons.g_translate_outlined,color: Colors.white,)),dropdownColor: kPrimaryColor,
              items:Language.languageList().map<DropdownMenuItem<Language>>((lange) =>
                  DropdownMenuItem(value: lange,child: Text('${lange.name}',style: TextStyle(color: Colors.white),),)
              ).toList(),
              onChanged: (Language? d){
              _onChangedLanguage(d);
                },

            ),
           ], ),
          currentAccountPicture:    VIP?CircleAvatar(
            backgroundImage:NetworkImage(""),
            backgroundColor: Colors.black,
          ):CircleAvatar(backgroundImage: AssetImage(img),
            child: Text("${defName.toString().substring(0,1).toUpperCase()}",
              style:
              TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
          ),


        ),

        ListTile(
          title: Text("$Home",style:TextStyle(color: Colors.white) ,),
          onTap: () {
            Navigator.pushNamed(context, "home");
          },
        ),

        Visibility(visible: VIP,
          child: ListTile(
            title: Text("$Shop",style: TextStyle(color: Colors.white),),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ShopItem()
                  ));
            },
          ),
        ),
        Visibility(visible: VIP,
          child: ListTile(

            title: Text("$_AddItemToShop",style: TextStyle(color: Colors.white)),
            onTap: () {

              Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => AddItemToShop()
                  ));
            },
          ),
        ),

        ListTile(
          title: Text("$ProFile",style: TextStyle(color: Colors.white)),
          onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => profile(
                   uid: FirebaseAuth.instance.currentUser!.uid,VIP: VIP,
                  ),
                ));
          },
        ),

        ListTile(
          title: Text("$AddNewStory",style: TextStyle(color: Colors.white)),
          onTap: () {
            Navigator.pushNamed(context, "AddPostScreen");
          },
        ),
        ListTile(
          title: Text("$_Request",style: TextStyle(color: Colors.white)),
          onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => Request(),
                ));
          },
        ),
        Divider(height: 1.5,color: Colors.blueGrey),
        ListTile(
          title: Text("$Shop",style: TextStyle(color: Colors.white)),
          onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AllGames(),
                ));
          },
        ),
        ListTile(
          title: Text("$GetPoint",style: TextStyle(color: Colors.white)),
          onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => TapJoy(),
                ));
          },
        ),
        Divider(height: 1.5,color: Colors.blueGrey),
        ListTile(
          title: Text("$blog",style: TextStyle(color: Colors.white)),
          onTap: () {
            Navigator.pushNamed(context, "blogpage");
          },
        ),
        ListTile(
          title: Text("$Logout",style: TextStyle(color: Colors.white)),
          onTap: () {
            UserInfoList.clear();
            FirebaseAuth.instance.signOut().whenComplete(() =>  Navigator.pushNamed(context, "login"));
          },
        ),

        UnityBannerAd(
            placementId: AdManager.bannerAdPlacementId),
      ],
    ),
  );

}

getMyInfo() async {


  if(UserInfoList.isEmpty){
  /*  var Usersinof =
    await userinfoRef.where("uID", isEqualTo: "${FirebaseAuth.instance.currentUser!.uid}").get();
    Usersinof.docs.forEach((element) {

        UserInfoList.add(element.data());

    });*/
    UserInfoList= await realtimeDb().GetOneUserData(Id: "${FirebaseAuth.instance.currentUser!.uid}");

  }else{

    UserInfoList==await realtimeDb().GetOneUserData(Id: "${FirebaseAuth.instance.currentUser!.uid}");

  }
}

DeleteView({required LastMessageId,required YourId,required IsGroup,required context})async{
  var Whatdoyouwanttodo=getTranslated(context,"Whatdoyouwanttodo");
  var DeleteListForMe=getTranslated(context,"DeleteListForMe");
  var DeleteDataForMe=getTranslated(context,"DeleteDataForMe");
  var DeleteDataForMeAndYou=getTranslated(context,"DeleteDataForMeAndYou");
  var DeleteDataAndListForMeAndYou=getTranslated(context,"DeleteDataAndListForMeAndYou");
  var Cancel=getTranslated(context,"Cancel");
  var OK=getTranslated(context,"OK");
  var ConfirmListForMe=getTranslated(context,"ConfirmListForMe");
  var ConfirmDataForMe=getTranslated(context,"ConfirmDataForMe");
  var ConfirmDataForMeAndYou=getTranslated(context,"ConfirmDataForMeAndYou");
  var ConfirmDataAndListForMeAndYou=getTranslated(context,"ConfirmDataAndListForMeAndYou");

  var showMessage='';
  return  showDialog( context: context,
      builder: (context)
      {
        return Container(
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(horizontal: 40),
            child: Card(shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Text("$Whatdoyouwanttodo"),
                      Divider(),
                      SizedBox(height: 30,),
                      DeleteButton(
                        text: '$DeleteListForMe',
                        backgroundColor: Colors.white,
                        textColor: Colors.black,
                        splashColor: Colors.teal,
                        Myheight: 35,Mywidth: 260,
                        function: () async {
                          Navigator.of(context).pop();
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return   SimpleDialog(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                  children: <Widget>[
                                    SimpleDialogOption(
                                        padding: const EdgeInsets.all(20),
                                        child: Text('$ConfirmListForMe'),
                                        ),
                                    SimpleDialogOption(
                                        padding: const EdgeInsets.all(20),
                                        child: Text('$OK'),
                                        onPressed: () async {
                                          showMessage=await FireStoreMethods().deleteLastChatAndChatList(
                                              LastMessageId: '$LastMessageId', YourId: '$YourId', DeleteOptions:2);
                                          Navigator.pop(context);
                                          showSnackBar(context,showMessage);
                                        }),
                                    SimpleDialogOption(
                                      padding: const EdgeInsets.all(20),
                                      child: Text("$Cancel"),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                    )
                                  ],
                                )
                                ;
                              });
                        },
                      ),
                      SizedBox(height: 30,),
                      Visibility(visible: IsGroup==false,
                        child: DeleteButton(
                          text: '$DeleteDataForMe',
                          backgroundColor: Colors.white,
                          textColor: Colors.black,
                          splashColor: Colors.teal,
                          Myheight: 35,Mywidth: 260,
                          function: () async {
                            Navigator.of(context).pop();
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return SimpleDialog(shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius
                                          .circular(15)),
                                    children: <Widget>[
                                      SimpleDialogOption(
                                          padding: const EdgeInsets.all(20),
                                          child: Text('$ConfirmDataForMe'),
                                         ),
                                      SimpleDialogOption(
                                          padding: const EdgeInsets.all(20),
                                          child: Text('$OK'),
                                          onPressed: () async {
                                            showMessage = await FireStoreMethods()
                                                .deleteLastChatAndChatList(
                                                LastMessageId: '$LastMessageId',
                                                YourId: '$YourId',
                                                DeleteOptions: 0);
                                            Navigator.pop(context);
                                            showSnackBar(context, showMessage);
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
                      Visibility(visible: IsGroup==false,child: SizedBox(height: 30,)),
                      Visibility(visible: IsGroup==false,
                        child: DeleteButton(
                          text: '$DeleteDataForMeAndYou',
                          backgroundColor: Colors.indigo,
                          textColor: Colors.white,
                          splashColor: Colors.blue,
                          Myheight: 35,Mywidth: 260,
                          function: () async { Navigator.of(context).pop();
                          showDialog(
                              context: context,
                              builder: (BuildContext context)
                              {
                                return SimpleDialog(shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                  children: <Widget>[
                                    SimpleDialogOption(
                                        padding: const EdgeInsets.all(20),
                                        child: Text('$ConfirmDataForMeAndYou'),
                                        ),
                                    SimpleDialogOption(
                                        padding: const EdgeInsets.all(20),
                                        child: Text('$OK'),
                                        onPressed: () async {

                                          showMessage = await FireStoreMethods()
                                              .deleteLastChatAndChatList(
                                              LastMessageId: '$LastMessageId',
                                              YourId: '$YourId',
                                              DeleteOptions: 1);
                                          Navigator.pop(context);
                                          showSnackBar(context, showMessage);
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
                      Visibility(visible: IsGroup==false,child: SizedBox(height: 30,)),
                      Visibility(visible: IsGroup==false,
                        child: DeleteButton(
                          text: '$DeleteDataAndListForMeAndYou',
                          backgroundColor: Colors.indigo,
                          textColor: Colors.white,
                          splashColor: Colors.blue,
                          Myheight: 35,Mywidth: 260,
                          function: () async {
                            Navigator.of(context).pop();
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return   SimpleDialog(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                    children: <Widget>[
                                      SimpleDialogOption(
                                          padding: const EdgeInsets.all(20),
                                          child: Text('$ConfirmDataAndListForMeAndYou'),
                                      ),
                                      SimpleDialogOption(
                                          padding: const EdgeInsets.all(20),
                                          child: Text('$OK'),
                                          onPressed: () async {

                                            showMessage=await FireStoreMethods().deleteLastChatAndChatList(
                                                LastMessageId: '$LastMessageId', YourId: '$YourId', DeleteOptions:3);
                                            Navigator.pop(context);
                                            showSnackBar(context,showMessage);
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
                      Visibility(visible: IsGroup==false,child: SizedBox(height: 30,)),
                    ]))));
      });

}





/*
 myListInfo[i]["VIP"]?ClipRRect(borderRadius:  BorderRadius.circular(25),
                          child: Container(
                            width: 46,height: 46,
                            child: HtmlWidget(
                              '<img width="46" height="46" src="${myListInfo[i]["imageProFile"]}" '
                                  '/>',
                              factoryBuilder: () => MyWidgetFactory(),enableCaching: true,
                            ),
                          ),
                        ):CircleAvatar(backgroundImage: AssetImage(img),
                          child: Text("${myListInfo[i]["name"].toString().substring(0,1).toUpperCase()}",
                            style:
                          TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
                        ),
                        */
