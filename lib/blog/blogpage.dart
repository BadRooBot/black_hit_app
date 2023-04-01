import 'dart:io';

import 'package:AliStore/blog/blogView.dart';
import 'package:AliStore/post/follow_button.dart';
import 'package:AliStore/resources/Localizations_constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:AliStore/Dashbord/profile.dart';
import 'package:AliStore/Dashbord/search_screen.dart';
import 'package:AliStore/resources/MyWidgetFactory.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../Dashbord/home.dart';
import '../resources/realtime_database_methods.dart';

class blogpage extends StatefulWidget {
  const blogpage({Key? key}) : super(key: key);

  @override
  State<blogpage> createState() => _blogpageState();
}

class _blogpageState extends State<blogpage> {
  String img='assets/back.jpg';
  var AddNewBlog,Pin,blog,UnPin,Whatdoyouwanttodo,Delete;
  CollectionReference blogReference = FirebaseFirestore.instance.collection("BlogPosts");
  CollectionReference _reference = FirebaseFirestore.instance.collection("BlogLimit");
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool IsAddComments=false;
  bool IsAdmin=false;
  int CommentCounts=0;
  int BlogCount=0;
  int limitGet=10;
  List ImageBlogs=[];
  List DownloadList=[];
  var ItemsInfo;
  List allBlogs=[
    {'title':'سورس لعبة Volcano 3D ',
      'oldDate':'06-20-2022 04:52 PM ',
      'date':'1',
      'UserName':'CoderMazzikaHere',
      'UserImage':'',
      'VIP':false,
      'Status':true,''
      'blogImage0':'',
      'blogImage1':'',
      'ImageBlogCount':2,
      'bio':'انهردة جيبلكم سورس لعبة Volcano 3D تون تو دى Server Version 7111 السورس لحد تحــــديث النيجيا Archive Ninja 100% Archive Trojan 100% Epic Pirete 100% prefction system 100% Anima system 100% Shop _(Ainma-Rune-Gamrant-Momunt- نيجي باة للصور [عفواً لايمكن عرض الرابط إلا بعد الرد على الموضوع] [عفواً لايمكن عرض الرابط إلا بعد الرد على الموضوع] [عفواً لايمكن عرض الرابط إلا بعد الرد على الموضوع] [عفواً لايمكن عرض الرابط إلا بعد الرد على الموضوع] [عفواً لايمكن عرض الرابط إلا بعد الرد على الموضوع] دة اثبات من داخل الفي بي اس [عفواً لايمكن عرض الرابط إلا بعد الرد على الموضوع] نيجي باة للتحميل دة رابط تحميل السورس ومعاة القاعدة والاوتوباتش [عفواً لايمكن عرض الرابط إلا بعد الرد على الموضوع] ودة رابط تحميل الباتش [عفواً لايمكن عرض الرابط إلا بعد الرد على الموضوع] [3D].exe/file ودة موقع العبة علشان لو عاوز تجرب السورس [عفواً لايمكن عرض الرابط إلا بعد الرد على الموضوع]',
      'Key':'54dfsdf45',
      'UserID':''
    }
  ];

  getData() async{
    allBlogs.clear();
     ItemsInfo = await blogReference.orderBy("date",descending: true).limit(10).get();
    ItemsInfo.docs.forEach((element) {
      setState(() {
        allBlogs.add(element.data());

      });
    });
    UpdateData();
  }
  getData2(afterVale) async{
    var ss=allBlogs[afterVale-1]['date'];
    var ItemsI = await blogReference.limit(10).orderBy("date",descending: true).startAfter([ss]).get();
    ItemsI.docs.forEach((element) {
      setState(() {
        allBlogs.add(element.data());

      });
    });


  }

  UpdateData()async{
    //   ListlastChat.clear();
    for(int num=0;num<=allBlogs.length-1;num++){
      try{
        List dataForOneUserBlog= await realtimeDb().GetOneUserData(Id:  allBlogs[num]['UserID']);
        /* var nAndI = await _firestore.collection('users')
            .where('uID',
            isEqualTo: allBlogs[num]['UserID'])
            .get();*/
        dataForOneUserBlog.forEach((element) async {
          DocumentReference myStore = FirebaseFirestore
              .instance.collection('BlogPosts')
              .doc(allBlogs[num]['Key']);

          if (allBlogs[num]['UserID'] ==
              element['uID']) {

            if (allBlogs[num]['UserName'] !=
                element['name']) {
              await realtimeDb().UpdateOneUsetToBlog(BlogId:  allBlogs[num]['Key'], Name:  element['name']
                  , ProfileImage: element['imageProFile'], IsVIP: element['VIP'], WhatThisUpdate: 0);
            }
            if (allBlogs[num]['UserImage'] !=
                element['imageProFile']) {
              await realtimeDb().UpdateOneUsetToBlog(BlogId:  allBlogs[num]['Key'], Name:  element['name']
                  , ProfileImage: element['imageProFile'], IsVIP: element['VIP'], WhatThisUpdate: 1);
            }
            if (allBlogs[num]['VIP'] !=
                element['VIP']) {
              await realtimeDb().UpdateOneUsetToBlog(BlogId:  allBlogs[num]['Key'], Name:  element['name']
                  , ProfileImage: element['imageProFile'], IsVIP: element['VIP'], WhatThisUpdate:2);
            }

          }
        });


      }catch(d){ print('++++++++++++++++Enter Error  $d');}

    }
  }
  getAllBolgImage(x){
    ImageBlogs.clear();

      for(int y=0;y<allBlogs[x]['ImageBlogCount'];y++){
        setState(() {
          ImageBlogs.add(allBlogs[x]['blogImages'][y]);
        });

    }
  }
  getAllDownloadLink(d){
    DownloadList.clear();
    for(int y=1;y<=allBlogs[d]['DownloadLinkCount'];y++){
      setState(() {
        DownloadList.add(allBlogs[d]['DownloadLink$y']);
      });

    }
  }
  getLimit()async{/*
    var dataLimit=await _reference.get();
    dataLimit.docs.forEach((element) {
      setState(() {
        BlogCount= element['BlogLimit'];
      });
    });
*/
    var a=await realtimeDb().GetBlogsLimit();
    setState(() {
      BlogCount=a;
    });

  }

 /* setCommentCount(sx)async{
    var pds=await _firestore.collection('BlogPosts').doc(allBlogs[sx]['Key']).get();
    setState(() {
      IsAddComments=pds.data()!['AllCommentsIDs'].contains(FirebaseAuth.instance.currentUser!.uid);
    //  CommentCounts=pds.data()!['AllCommentsIDs'].length;
      CommentCounts=pds.data()!['finalCommentCount'];
    });

  }*/


  getTranslatArOrEn(context){
    AddNewBlog=getTranslated(context,"AddNewBlog");
    Pin=getTranslated(context,"Pin");
    blog=getTranslated(context,"blog");
    UnPin=getTranslated(context,"UnPin");
    Whatdoyouwanttodo=getTranslated(context,"Whatdoyouwanttodo");
    Delete=getTranslated(context,"Delete");

  }

  getAdmin(){
    IsAdmin=UserInfoList[0]['Admin']??false;
  }
  GetAllBlogData(l)async{
    dynamic a=[];
    dynamic val=[];
    dynamic key=[];
    if(allBlogs.isNotEmpty){
      val=allBlogs[allBlogs.length-1]['date'];
    }
   a= await realtimeDb().GetAllBlog(Limit:l,Keys: '',Value: '');
   setState(() {
     allBlogs=a;

   });
    UpdateData();
  // print('=============================GetAllBlog ${allBlogs[0]['AllCommentsIDs'].contains(FirebaseAuth.instance.currentUser!.uid)}');
  }
  @override
  void initState() {
    //getData();
    GetAllBlogData(10);
    getLimit();
    getAdmin();

    sc.addListener(() {
      if(sc.offset>=sc.position.maxScrollExtent){
        if(BlogCount>allBlogs.length) {
          setState(() {
            //  ShowLoding=true;
          });
          if(BlogCount>=allBlogs.length) {
            GetAllBlogData(5);
            UpdateData();
          }
        }else{
          setState(() {
            // ShowLoding=false;
            //  StopGet=false;
          });
        }
      }
    });

    super.initState();
  }
  final sc=ScrollController();

  PinBlog(keys,index)async{

    return showDialog( context: context,
        builder: (context) {

          Pin=getTranslated(context,"Pin");
          UnPin=getTranslated(context,"UnPin");
          Whatdoyouwanttodo=getTranslated(context,"Whatdoyouwanttodo");
          Delete=getTranslated(context,"Delete");
          String PinAndUnPin=allBlogs[index]['Status']?'$UnPin':'$Pin';
          bool SetPinAndUnPin=allBlogs[index]['Status']?false:true;
          int newIndexBlog=allBlogs[index]['Status']?allBlogs[index]['oldIndex']:9000065;
      return Container(width: MediaQuery.of(context).size.width-10,
        height: 150,
        alignment: Alignment.center,
        margin:EdgeInsets.symmetric(horizontal: 40) ,
        child: Card(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Container(width: MediaQuery.of(context).size.width-10,
          height: 150,
          child: Column(mainAxisAlignment:MainAxisAlignment.spaceAround ,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('$Whatdoyouwanttodo'),
              Divider(),
              Row(crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                Flexible(flex:1,child:FollowButton(splashColor: Colors.lightBlueAccent,text: '$PinAndUnPin',textColor: Colors.white,backgroundColor: Colors.blueGrey,function: () async{
                  await blogReference.doc(keys).set({'Status':SetPinAndUnPin,'date':newIndexBlog},SetOptions(merge: true));
                  setState(() {
                    allBlogs[index]['Status']=SetPinAndUnPin;
                    allBlogs[index]['date']=newIndexBlog;
                  });
                  Navigator.pop(context);
                },) ),Flexible(flex:1,child: Text('')),
                Flexible(flex:1,child:FollowButton(splashColor: Colors.lightBlueAccent,text: '$Delete',textColor: Colors.white,backgroundColor: Colors.blueGrey,function: () async{
                  await blogReference.doc(keys).delete();
                  Navigator.pop(context);

                },) ),

              ],),
            ],
          ),
        ),),
      );
        });

  }
  @override
  Widget build(BuildContext context) {
  //  getTranslatArOrEn(context);
    blog=getTranslated(context,"blog");
    AddNewBlog=getTranslated(context,"AddNewBlog");

    return Scaffold(
      appBar: AppBar(leading:
      InkWell(onTap: (){ Navigator.of(context).pushNamed('home');},child: Icon(Icons.arrow_back_ios)),
          title:Text('$blog'),
          actions: [Visibility(visible: false,
            child: InkWell(child: Icon(Icons.search),onTap: (){
        Navigator.of(context).pushNamed('blogSearch');
      },),
          )]),
      body: ListView.builder(controller:sc,itemCount: allBlogs.length,itemBuilder: (context, i) {

        try {
          return SizedBox(width: MediaQuery
              .of(context)
              .size
              .width , height: 90,
            child: InkWell(onLongPress: (){
              if(IsAdmin) {
                PinBlog(allBlogs[i]['Key'], i);
              }
            },onTap: () {
             /* allBlogs[i]['AllCommentsIDs'].forEach((element) {
              IsAddComments= element.contains(FirebaseAuth.instance.currentUser!.uid)??false;
              });*/
              IsAddComments=true;
              getAllBolgImage(i);
              getAllDownloadLink(i);
              Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => blogView(title:allBlogs[i]["title"],blogBio: allBlogs[i]["bio"], blogKey:  allBlogs[i]["Key"], VIP:  allBlogs[i]["VIP"], UserName:  allBlogs[i]["UserName"], UserImage:  allBlogs[i]["UserImage"]
                        ,blogImages: ImageBlogs,blogDownloadLink: DownloadList,IsAddComments: IsAddComments,blogImagesCount: allBlogs[i] ['ImageBlogCount']),
                  ));
            },
              splashColor: Colors.blueAccent,
              borderRadius: BorderRadius.circular(15),
              child: Card(shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 20.0 * 0.75),
                  child: Row(
                    children: [
                      Stack(
                        children: [
                          allBlogs[i]["VIP"] ? ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: Container(
                              width: 46, height: 46,
                              child: HtmlWidget(
                                '<img width="46" height="46" src="${allBlogs[i]["UserImage"]}" '
                                    '/>',
                                factoryBuilder: () => MyWidgetFactory(),
                                enableCaching: true,
                              ),
                            ),
                          ) : CircleAvatar(backgroundImage: AssetImage(img),
                            child: Text(
                              "${allBlogs[i]["UserName"].toString().substring(
                                  0, 1).toUpperCase()}",
                              style:
                              TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),),
                          ),
                          /* CircleAvatar(
                          radius: 24,
                          backgroundImage: NetworkImage(
                              "${myListInfo[i]["imageProFile"]}"),
                        ),*/
                          //chat.isActive
              allBlogs[i]['Status']? Positioned(
                              right: 0,
                              bottom: 0,
                              child: Container(
                                height: 16,
                                width: 16,
                         child: Icon(Icons.push_pin_outlined,color: Colors.blue,size: 17,),
                              ),
                            )
                      :Positioned(
                          right: 0,
                          bottom: 0,
                      child: Container(
                        height: 16,
                        width: 16,
                ),
              )
                        ],
                      ),
                      Expanded(flex: 3,
                        child: Container(
                          height: 52,
                          width: (MediaQuery
                              .of(context)
                              .size
                              .width) ,
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${allBlogs[i]["title"]}", maxLines: 1,
                                style:
                                TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                              SizedBox(height: 2),
                              Opacity(
                                opacity: 0.60,
                                child: Text(
                                  "By: ${allBlogs[i]["UserName"]}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Flexible(flex: 1,
                        child: Container(alignment:Alignment.center ,
                          child: Opacity(opacity: 0.60,
                          child: Text(DateFormat.yMd()
                              .format(DateTime.parse(allBlogs[i]['oldDate']))),),
                        ),
                      ),


                    ],
                  ),
                ),
              ),
            ),
          );
        }catch(e){
          return Text("");
        }
      }),
      floatingActionButton: FloatingActionButton(child:Icon(Icons.add) ,backgroundColor: Colors.blueGrey,tooltip: '$AddNewBlog',onPressed: (){
        Navigator.of(context).pushNamed("AddNewBlog");
      })

    ) ;
  }


}
//https://nessour.org/

//flutter run -d edge --web-renderer html --no-sound-null-safety
/* Flexible(flex: 2,child: Container(alignment: Alignment.centerRight,padding: EdgeInsets.only(left: 4,right: 4),
                        child: Column(children: [
                          Opacity(opacity: 0.60,
                            child: Text('Coments'),),
                          Opacity(opacity: 0.60,
                            child: Text('${allBlogs[i]['AllCommentsIDs'].length??0}'),),
                        ],),
                      ),)*/