// import 'dart:io';
// import 'dart:typed_data';
// import 'package:AliStore/Dashbord/home.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:AliStore/resources/Localizations.dart';
// import 'package:AliStore/resources/Localizations_constants.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:AliStore/resources/storage_methods.dart';
// import 'package:path/path.dart';

// import '../alert.dart';
// import '../resources/realtime_database_methods.dart';

// class AddNewBlog extends StatefulWidget {
//   const AddNewBlog({Key? key}) : super(key: key);

//   @override
//   State<AddNewBlog> createState() => _AddNewBlogState();
// }

// class _AddNewBlogState extends State<AddNewBlog> {
// //--web-renderer html
//   var title,price,passwor;
//   var email,ItemsProperties1,ItemsProperties2,ItemsProperties3,ItemsProperties4,ItemsProperties5,ItemsProperties6,ItemsProperties7,ItemsProperties8,ItemsProperties9,ItemsProperties10,ItemsProperties11;

//   var IsVip;
//   late BuildContext _context;
//   late File file=File.fromRawPath(Uint8List(56));
//   var imageurl;
//   int Pcount=0;
//   late String done,Done,loading,PleaseWait,AddNewItem,Nameisrequired,TypeItemname,Itemname,ItemsDecisrequired,TypeItemsDec
//   ,ItemsDec,Priceisrequired,TypeItemsPrice,ItemsPrice,TypeItemsProperties,ItemsProperties,AddItemToShop,Cancel,ChoosefromGallery,Takeaphoto;
//   int RadioVal=0;
//   PageController _pageController=new PageController(initialPage: 0,viewportFraction: 1.0,keepPage: false);
//   File NullFile=File.fromRawPath(Uint8List(0001));
//   void setLocaleTranslated(BuildContext context){
//     Cancel=getTranslated(context,"Cancel");
//     ChoosefromGallery=getTranslated(context,"ChoosefromGallery");
//     Takeaphoto=getTranslated(context,"Takeaphoto");

//     done='Add Image Url';
//     Done = DemoLocalizations.of(context).getTranslatedValue('Done');
//     loading =DemoLocalizations.of(context).getTranslatedValue( 'loading');
//     PleaseWait = DemoLocalizations.of(context).getTranslatedValue('Please-Wait');
//     AddNewItem = DemoLocalizations.of(context).getTranslatedValue('Add-New-Item');
//     Nameisrequired = DemoLocalizations.of(context).getTranslatedValue('Name-is-required');
//     TypeItemname =DemoLocalizations.of(context).getTranslatedValue( 'Type-Item-name');
//     Itemname =DemoLocalizations.of(context).getTranslatedValue( 'Item-name');
//     ItemsDecisrequired = DemoLocalizations.of(context).getTranslatedValue('ItemsDec-is-required');
//     TypeItemsDec = DemoLocalizations.of(context).getTranslatedValue('Type-Items-Dec');
//     ItemsDec = DemoLocalizations.of(context).getTranslatedValue('ItemsDec');
//     Priceisrequired =DemoLocalizations.of(context).getTranslatedValue( 'Price-is-required');
//     TypeItemsPrice = DemoLocalizations.of(context).getTranslatedValue('Type-Items-Price');
//     ItemsPrice = DemoLocalizations.of(context).getTranslatedValue('Items-Price');
//     TypeItemsProperties = DemoLocalizations.of(context).getTranslatedValue('Type-Items-Properties');
//     ItemsProperties = DemoLocalizations.of(context).getTranslatedValue('Items-Properties');
//     AddItemToShop = DemoLocalizations.of(context).getTranslatedValue('Add-Item-To-Shop');
//   }

//   GlobalKey<FormState> formstate = new GlobalKey<FormState>();

//   CollectionReference userinfoRef =FirebaseFirestore.instance.collection("BlogPosts") ;
//   CollectionReference _reference = FirebaseFirestore.instance.collection("BlogLimit");
//   int BlogLimit=0;
//   late Reference res;

//   List<dynamic> Filesss=[null];

//   List imageUrls=[null];
//   addInfo(context)async{
//     var formdata = formstate.currentState;
//     if (formdata!.validate()) {
//       String postId =FirebaseFirestore.instance.collection("BlogPosts").doc().id;
//       formdata.save();
//       showLoading(context,"$loading",true);
//      // String ItemsKey=TimeOfDay.now().toString().replaceAll(":", " ").replaceAll("/", " ").replaceAll("\\", " ").replaceAll("-", " ").trim();
//       var Datetime=DateTime.now();
//       var UserImage=IsVip?UserInfoList[0]["imageProFile"]:'Text';
//       var UserName=UserInfoList.isEmpty?'bad':UserInfoList[0]["name"];
//       var UserID=FirebaseAuth.instance.currentUser!.uid;
//       int ImageblogCountsss=imageUrls.length>=12?11:imageUrls.length-1;
//       await userinfoRef.doc(postId).set({
//         "title":title,
//         "oldDate": Datetime,
//         "date": BlogLimit,
//         "oldIndex": BlogLimit,
//         "UserName":UserName,
//         "UserImage":UserImage,
//         "bio":passwor,
//         "Key": postId,
//         "UserID":UserID,
//         "blogImage0":imageUrls[0],
//         "VIP":IsVip,
//         "Status":false,
//         'ImageBlogCount':ImageblogCountsss,
//         "DownloadLinkCount":Pcount,
//         "DownloadLink1":ItemsProperties1,
//         "DownloadLink2":ItemsProperties2,
//         "DownloadLink3":ItemsProperties3,
//         "DownloadLink4":ItemsProperties4,
//         "DownloadLink5":ItemsProperties5,
//         "DownloadLink6":ItemsProperties6,
//         "DownloadLink7":ItemsProperties7,
//         "DownloadLink8":ItemsProperties8,
//         "DownloadLink9":ItemsProperties9,
//         "DownloadLink10":ItemsProperties10,
//         "DownloadLink11":ItemsProperties11,
//         'finalCommentCount':0

//       },SetOptions(merge:true),);

//       for(int d=1;d<imageUrls.length;d++) {
//         await userinfoRef.doc(postId).set({'blogImage${d}':imageUrls[d]},SetOptions(merge: true));
//       }
//       await  _reference.doc("BlogLimit").set({'BlogLimit': BlogLimit});

//       Navigator.pushNamed(context, "home");

//     }


//   }
//   CreateNewBlog(context)async{
//     var formdata = formstate.currentState;
//     if (formdata!.validate()) {
//       formdata.save();
//       showLoading(context,"$loading",true);
//      // String ItemsKey=TimeOfDay.now().toString().replaceAll(":", " ").replaceAll("/", " ").replaceAll("\\", " ").replaceAll("-", " ").trim();
//       var Datetime=DateTime.now().toString();
//       var UserImage=IsVip?UserInfoList[0]["imageProFile"]:'Text';
//       var UserName=UserInfoList.isEmpty?'bad':UserInfoList[0]["name"];
//       var UserID=FirebaseAuth.instance.currentUser!.uid;
//       int ImageblogCountsss=imageUrls.length>=12?11:imageUrls.length-1;
//       FirebaseApp secondaryApp = Firebase.app();
//       FirebaseDatabase db = FirebaseDatabase.instanceFor(app: secondaryApp,databaseURL: 'https://one-piece-b44fe-default-rtdb.firebaseio.com/');
//       var Tag=db.ref('Users').push().key;

//     await  db.ref('BlogPosts/').child('$Tag').set(
//           {
//             "title":title,
//             "oldDate": Datetime,
//             "date": BlogLimit,
//             "oldIndex": BlogLimit,
//             "UserName":UserName,
//             "UserImage":UserImage,
//             "bio":passwor,
//             "Key": '$Tag',
//             "UserID":UserID,
//             "VIP":IsVip,
//             "Status":false,
//             'ImageBlogCount':ImageblogCountsss,
//             "DownloadLinkCount":Pcount,
//             "DownloadLink1":ItemsProperties1,
//             "DownloadLink2":ItemsProperties2,
//             "DownloadLink3":ItemsProperties3,
//             "DownloadLink4":ItemsProperties4,
//             "DownloadLink5":ItemsProperties5,
//             "DownloadLink6":ItemsProperties6,
//             "DownloadLink7":ItemsProperties7,
//             "DownloadLink8":ItemsProperties8,
//             "DownloadLink9":ItemsProperties9,
//             "DownloadLink10":ItemsProperties10,
//             "DownloadLink11":ItemsProperties11,
//             'finalCommentCount':0,
//             'blogImages':imageUrls,
//             'AllCommentsIDs':['s','Sia']

//           }
//       );
// /*
//       for(int d=0;d<imageUrls.length;d++) {
//        // await userinfoRef.doc(postId).set({'blogImage${d}':imageUrls[d]},SetOptions(merge: true));
//         await db.ref('BlogPosts').child('$Tag').update({'blogImages':});
//       }*/
//      // await  _reference.doc("BlogLimit").set({'BlogLimit': BlogLimit});
//       await db.ref('BlogLimit').set({'BlogLimit': BlogLimit});
//       Navigator.pushNamed(context, "home");
//     }

//   }


// forTest()async{
//   String pId =FirebaseFirestore.instance.collection("users").doc().id;
//   await userinfoRef.doc(pId).set({'title':'Conquer$BlogLimit',
//     'oldDate':DateTime.now(),
//     'date':BlogLimit,
//     'oldIndex':BlogLimit,
//     'UserName':'BadRooBot',
//     'UserImage':'',
//     'VIP':false,
//     'Status':false,
//     'blogImage0':'https://th.bing.com/th/id/R.a55ca3837e6d2cc9326236a5290aad4b?rik=wbTsc6UmQkNvEg&riu=http%3a%2f%2fwallpapercave.com%2fwp%2fXlcgJdu.jpg&ehk=c07Xr2t1eCBSMBuIgszmjiSMrGUTuOBQFv2GBPhhRc4%3d&risl=&pid=ImgRaw&r=0',
//     'blogImage1':'https://th.bing.com/th/id/OIP.B2L2RWWS94l6o6QiH_hyqAHaEo?pid=ImgDet&w=2560&h=1600&rs=1',
//     'ImageBlogCount':2,
//     'bio':'انهردة جيبلكم سورس لعبة Volcano 3D تون تو دى Server Version 7111 السورس لحد تحــــديث النيجيا Archive Ninja 100% Archive Trojan 100% Epic Pirete 100% prefction system 100% Anima system 100% Shop _(Ainma-Rune-Gamrant-Momunt- نيجي باة للصور [عفواً لايمكن عرض الرابط إلا بعد الرد على الموضوع] [عفواً لايمكن عرض الرابط إلا بعد الرد على الموضوع] [عفواً لايمكن عرض الرابط إلا بعد الرد على الموضوع] [عفواً لايمكن عرض الرابط إلا بعد الرد على الموضوع] [عفواً لايمكن عرض الرابط إلا بعد الرد على الموضوع] دة اثبات من داخل الفي بي اس [عفواً لايمكن عرض الرابط إلا بعد الرد على الموضوع] نيجي باة للتحميل دة رابط تحميل السورس ومعاة القاعدة والاوتوباتش [عفواً لايمكن عرض الرابط إلا بعد الرد على الموضوع] ودة رابط تحميل الباتش [عفواً لايمكن عرض الرابط إلا بعد الرد على الموضوع] [3D].exe/file ودة موقع العبة علشان لو عاوز تجرب السورس [عفواً لايمكن عرض الرابط إلا بعد الرد على الموضوع]',
//     'Key':'$pId',
//     'UserID':'45454',
//     'DownloadLink1':'dsdsdd',
//     'DownloadLink2':'ddsds',
//     'DownloadLinkCount':2,
//     'finalCommentCount':0,

//   },SetOptions(merge: true));
//   await _reference.doc("BlogLimit").set({'BlogLimit': BlogLimit});

// }
// getLimit()async{
// /* var dataLimit=await _reference.get();
//  dataLimit.docs.forEach((element) {
//    setState(() {
//      BlogLimit= element['BlogLimit']+1;
//    });
//  });*/
//   var a=await realtimeDb().GetBlogsLimit();
//   setState(() {
//     BlogLimit=a+1;
//   });
// }
// @override
//   void initState() {
//   getLimit();
//   super.initState();
//   }
//   @override
//   Widget build(BuildContext context) {
//    var AddNewBlog=getTranslated(context,"AddNewBlog");
//    if(UserInfoList.isNotEmpty){
//      IsVip= UserInfoList[0]["VIP"];
//    }else{
//      IsVip=false;
//    }
//     setLocaleTranslated(context);
//     return Scaffold(
//       appBar: AppBar(actions: [Visibility(visible: false,
//         child: InkWell(child: Icon(Icons.account_tree_outlined),onTap: (){
//           getLimit();
//           forTest();
//         },),
//       )],
//           title: Text('$AddNewBlog')),
//       body:
//       Card(margin: EdgeInsets.all(5),shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//         child: ListView(children: [
//           Stack(alignment: Alignment.bottomCenter,children: [
//             Container(width: MediaQuery.of(context).size.width,height: MediaQuery.of(context).size.height*.30,child:ShowAllImage()),
//             Positioned(child:getAllInkWell(imageUrls.length-1,false,context),bottom:10)]),
//           //هنا نهايه الصوره
//           Form( key: formstate,
//               child: Column(children: [
//                 SizedBox(height: 30,),
//                 Container(
//                   padding: EdgeInsets.symmetric(horizontal: 40),
//                   child: TextFormField(
//                     validator: (val) {
//                       if (val!.isEmpty) {
//                         return "title is required";
//                       }
//                       return null;
//                     },

//                     onSaved: (val){
//                       title=val;
//                     },
//                     decoration: InputDecoration(
//                         hintText: "title",
//                         label: Text("title"),
//                         border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(15),
//                             borderSide: BorderSide(width: 1))),),
//                 ),
//                 SizedBox(height: 15,),
//                 Container(
//                   padding: EdgeInsets.symmetric(horizontal: 40),
//                   child: TextFormField(maxLines: 10,minLines: 1,
//                     validator: (val) {
//                       if (val!.isEmpty) {
//                         return "Subject is required";
//                       }
//                       return null;
//                     },
//                     onSaved: (val){
//                       passwor=val;
//                     },
//                     decoration: InputDecoration(
//                         hintText: "Subject",
//                         label: Text("Subject"),
//                         border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(15),
//                             borderSide: BorderSide(width: 1))),),
//                 ),
//                 SizedBox(height: 15,),
//                 Visibility(visible: Pcount>=0,
//                   child: Container(
//                     padding: EdgeInsets.symmetric(horizontal: 40),
//                     child: TextFormField(
//                       validator: (val) {
//                         if (val!.isEmpty) {
//                           return null;
//                         }

//                         return null;
//                       }, onEditingComplete:(){
//                       setState(() {
//                         Pcount=1;
//                       });
//                     } ,
//                       onSaved: (val){
//                         setState(() {
//                           Pcount=1;
//                         });
//                         ItemsProperties1=val;
//                       },
//                       decoration: InputDecoration(
//                           hintText: "Download Link 1",
//                           label: Text("Download Link 1"),
//                           border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(15),
//                               borderSide: BorderSide(width: 1))),),
//                   ),
//                 ),
//                 Pcount>=1? SizedBox(height: 15,):SizedBox(height: 0,),
//                 Visibility(visible: Pcount>=1,
//                   child: Container(
//                     padding: EdgeInsets.symmetric(horizontal: 40),
//                     child: TextFormField(
//                       validator: (val) {
//                         if (val!.isEmpty) {
//                           return null;
//                         }

//                         return null;
//                       },
//                       onEditingComplete:(){
//                         setState(() {
//                           Pcount=2;
//                         });
//                         } ,

//                       onSaved: (val){
//                         setState(() {
//                           Pcount=2;
//                         });
//                         ItemsProperties2=val;
//                       },
//                       decoration: InputDecoration(
//                           hintText: "Download Link 2",
//                           label: Text("Download Link  2"),
//                           border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(15),
//                               borderSide: BorderSide(width: 1))),),
//                   ),
//                 ),
//                 Pcount>=2? SizedBox(height: 15,):SizedBox(height: 0,),
//                 Visibility(visible: Pcount>=2,
//                   child: Container(
//                     padding: EdgeInsets.symmetric(horizontal: 40),
//                     child: TextFormField(
//                       validator: (val) {
//                         if (val!.isEmpty) {
//                           return null;
//                         }

//                         return null;
//                       }, onEditingComplete:(){
//                       setState(() {
//                         Pcount=3;
//                       });
//                     } ,
//                       onSaved: (val){
//                         setState(() {
//                           Pcount=3;
//                         });
//                         ItemsProperties3=val;
//                       },
//                       decoration: InputDecoration(
//                           hintText: "Download Link ",
//                           label: Text("Download Link 3"),
//                           border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(15),
//                               borderSide: BorderSide(width: 1))),),
//                   ),
//                 ),
//                 Pcount>=3? SizedBox(height: 15,):SizedBox(height: 0,),
//                 Visibility(visible: Pcount>=3,
//                   child: Container(
//                     padding: EdgeInsets.symmetric(horizontal: 40),
//                     child: TextFormField(
//                       validator: (val) {
//                         if (val!.isEmpty) {
//                           return null;
//                         }
//                         return null;
//                       }, onEditingComplete:(){
//                       setState(() {
//                         Pcount=4;
//                       });
//                     } ,
//                       onSaved: (val){
//                         setState(() {
//                           Pcount=4;
//                         });
//                         ItemsProperties4=val;
//                       },
//                       decoration: InputDecoration(
//                           hintText: "Download Link",
//                           label: Text("Download Link 4"),
//                           border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(15),
//                               borderSide: BorderSide(width: 1))),),
//                   ),
//                 ),
//                 Pcount>=4? SizedBox(height: 15,):SizedBox(height: 0,),
//                 Visibility(visible: Pcount>=4,
//                   child: Container(
//                     padding: EdgeInsets.symmetric(horizontal: 40),
//                     child: TextFormField(
//                       validator: (val) {
//                         if (val!.isEmpty) {
//                           return null;
//                         }
//                         return null;
//                       }, onEditingComplete:(){
//                       setState(() {
//                         Pcount=5;
//                       });
//                     } ,
//                       onSaved: (val){
//                         setState(() {
//                           Pcount=5;
//                         });
//                         ItemsProperties5=val;
//                       },
//                       decoration: InputDecoration(
//                           hintText: "Download Link",
//                           label: Text("Download Link 5"),
//                           border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(15),
//                               borderSide: BorderSide(width: 1))),),
//                   ),
//                 ),
//                 Pcount>=5? SizedBox(height: 15,):SizedBox(height: 0,),
//                 Visibility(visible: Pcount>=5,
//                   child: Container(
//                     padding: EdgeInsets.symmetric(horizontal: 40),
//                     child: TextFormField(
//                       validator: (val) {
//                         if (val!.isEmpty) {
//                           return null;
//                         }

//                         return null;
//                       }, onEditingComplete:(){
//                       setState(() {
//                         Pcount=6;
//                       });
//                     } ,
//                       onSaved: (val){
//                         setState(() {
//                           Pcount=6;
//                         });
//                         ItemsProperties6=val;
//                       },
//                       decoration: InputDecoration(
//                           hintText: "Download Link",
//                           label: Text("Download Link 6"),
//                           border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(15),
//                               borderSide: BorderSide(width: 1))),),
//                   ),
//                 ),
//                 Pcount>=6? SizedBox(height: 15,):SizedBox(height: 0,),
//                 Visibility(visible: Pcount>=6,
//                   child: Container(
//                     padding: EdgeInsets.symmetric(horizontal: 40),
//                     child: TextFormField(
//                       validator: (val) {
//                         if (val!.isEmpty) {
//                           return null;
//                         }
//                         return null;
//                       }, onEditingComplete:(){
//                       setState(() {
//                         Pcount=7;
//                       });
//                     } ,
//                       onSaved: (val){
//                         setState(() {
//                           Pcount=7;
//                         });
//                         ItemsProperties7=val;
//                       },
//                       decoration: InputDecoration(
//                           hintText: "Download Link",
//                           label: Text("Download Link 7"),
//                           border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(15),
//                               borderSide: BorderSide(width: 1))),),
//                   ),
//                 ),
//                 Pcount>=7? SizedBox(height: 15,):SizedBox(height: 0,),
//                 Visibility(visible: Pcount>=7,
//                   child: Container(
//                     padding: EdgeInsets.symmetric(horizontal: 40),
//                     child: TextFormField(
//                       validator: (val) {
//                         if (val!.isEmpty) {
//                           return null;
//                         }

//                         return null;
//                       },
//                       onEditingComplete:(){
//                         setState(() {
//                           Pcount=8;
//                         });
//                     } ,
//                       onSaved: (val){
//                         ItemsProperties8=val;
//                         setState(() {
//                           Pcount=8;
//                         });
//                       },
//                       decoration: InputDecoration(
//                           hintText: "Download Link",
//                           label: Text("Download Link 8"),
//                           border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(15),
//                               borderSide: BorderSide(width: 1))),),
//                   ),
//                 ),
//                 Pcount>=8? SizedBox(height: 15,):SizedBox(height: 0,),
//                 Visibility(visible: Pcount>=8,
//                   child: Container(
//                     padding: EdgeInsets.symmetric(horizontal: 40),
//                     child: TextFormField(
//                       validator: (val) {
//                         if (val!.isEmpty) {
//                           return null;
//                         }

//                         return null;
//                       }, onEditingComplete:(){
//                       setState(() {
//                         Pcount=9;
//                       });
//                     } ,
//                       onSaved: (val){
//                         setState(() {
//                           Pcount=9;
//                         });
//                         ItemsProperties9=val;
//                       },
//                       decoration: InputDecoration(
//                           hintText: "Download Link",
//                           label: Text("Download Link 9"),
//                           border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(15),
//                               borderSide: BorderSide(width: 1))),),
//                   ),
//                 ),
//                 Pcount>=9? SizedBox(height: 15,):SizedBox(height: 0,),
//                 Visibility(visible: Pcount>=9,
//                   child: Container(
//                     padding: EdgeInsets.symmetric(horizontal: 40),
//                     child: TextFormField(
//                       validator: (val) {
//                         if (val!.isEmpty) {
//                           return null;
//                         }
//                         return null;
//                       }, onEditingComplete:(){
//                       setState(() {
//                         Pcount=10;
//                       });
//                     } ,
//                       onSaved: (val){
//                         ItemsProperties10=val;
//                         setState(() {
//                           Pcount=10;
//                         });
//                       },
//                       decoration: InputDecoration(
//                           hintText: "Download Link",
//                           label: Text("Download Link 10"),
//                           border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(15),
//                               borderSide: BorderSide(width: 1))),),
//                   ),
//                 ),
//                 Pcount>=10? SizedBox(height: 15,):SizedBox(height: 0,),
//                 Visibility(visible: Pcount>=10,
//                   child: Container(
//                     padding: EdgeInsets.symmetric(horizontal: 40),
//                     child: TextFormField(
//                       validator: (val) {
//                         if (val!.isEmpty) {
//                           return null;
//                         }
//                         return null;
//                       }, onEditingComplete:(){
//                       setState(() {
//                         Pcount=11;
//                       });
//                     } ,
//                       onSaved: (val){
//                         setState(() {
//                           Pcount=11;
//                         });
//                         ItemsProperties11=val;
//                       },
//                       decoration: InputDecoration(
//                           hintText: "Download Link",
//                           label: Text("Download Link 11"),
//                           border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(15),
//                               borderSide: BorderSide(width: 1))),),
//                   ),
//                 ),
//                Pcount>=11? SizedBox(height: 15,):SizedBox(height: 10,),

//                 MaterialButton(onPressed: ()async{
//                 //  await addInfo(context);
//                   await CreateNewBlog(context);
//                 },
//                   child: Text("$AddNewBlog",style: TextStyle(fontSize: 18,color: Colors.white,letterSpacing: 1.1

//                   ))
//                   ,color: Colors.black,padding: EdgeInsets.symmetric(horizontal:120),
//                   splashColor: Colors.green,
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),height: 52,),
//               ],
//               )

//           ),
//         ],),
//       ),
//     );
//   }
//   void onPageChanged(int page) {
//     setState(() {
//       RadioVal = page;

//     });
//   }
//   getAllInkWell(int Count,bool PageChanged,context){
//     if(PageChanged){
//       setState(() {
//         RadioVal=0;

//       });
//     }
//     Color? clr1=Theme.of(context).appBarTheme.backgroundColor;
//     Color? clr2=Colors.teal;
//     return Row(mainAxisAlignment: MainAxisAlignment.spaceAround,crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Visibility(visible: Count>=0,
//           child: InkWell(child: RadioVal==0?Icon(Icons.adjust_outlined,color: clr1,size: 17,):Icon(Icons.circle_outlined,color:clr2,size: 17),onTap: (){
//             setState(() {
//               RadioVal=0;
//               _pageController.animateToPage(RadioVal, duration: Duration(milliseconds: 350), curve: Curves.decelerate);
//             });
//           },splashColor: Colors.blue,),
//         ),
//         Visibility(visible: Count>=1,
//           child: InkWell(child: RadioVal==1?Icon(Icons.adjust_outlined,color: clr1,size: 17,):Icon(Icons.circle_outlined,color:clr2,size: 17),onTap: (){
//             setState(() {
//               RadioVal=1;
//               _pageController.animateToPage(RadioVal, duration: Duration(milliseconds: 350), curve: Curves.decelerate);
//             });
//           },splashColor: Colors.blue,),
//         ),
//         Visibility(visible: Count>=2,
//           child: InkWell(child:RadioVal==2?Icon(Icons.adjust_outlined,color: clr1,size: 17,):Icon(Icons.circle_outlined,color:clr2,size: 17),onTap: (){
//             setState(() {
//               RadioVal=2;
//               _pageController.animateToPage(RadioVal, duration: Duration(milliseconds: 350), curve: Curves.decelerate);
//             });
//           },splashColor: Colors.blue,),
//         ),
//         Visibility(visible: Count>=3,
//           child: InkWell(child: RadioVal==3?Icon(Icons.adjust_outlined,color:clr1,size: 17,):Icon(Icons.circle_outlined,color:clr2,size: 17),onTap: (){
//             setState(() {
//               RadioVal=3;
//               _pageController.animateToPage(RadioVal, duration: Duration(milliseconds: 350), curve: Curves.decelerate);
//             });
//           },splashColor: Colors.blue,),
//         ),     Visibility(visible: Count>=4,
//           child: InkWell(child:RadioVal==4?Icon(Icons.adjust_outlined,color:clr1,size: 17,):Icon(Icons.circle_outlined,color:clr2,size: 17),onTap: (){
//             setState(() {
//               RadioVal=4;
//               _pageController.animateToPage(RadioVal, duration: Duration(milliseconds: 350), curve: Curves.decelerate);
//             });
//           },splashColor: Colors.blue,),
//         ),     Visibility(visible: Count>=5,
//           child: InkWell(child: RadioVal==5?Icon(Icons.adjust_outlined,color:clr1,size: 17,):Icon(Icons.circle_outlined,color:clr2,size: 17),onTap: (){
//             setState(() {
//               RadioVal=5;
//               _pageController.animateToPage(RadioVal, duration: Duration(milliseconds: 350), curve: Curves.decelerate);
//             });
//           },splashColor: Colors.blue,),
//         ),     Visibility(visible: Count>=6,
//           child: InkWell(child: RadioVal==6?Icon(Icons.adjust_outlined,color:clr1,size: 17,):Icon(Icons.circle_outlined,color:clr2,size: 17),onTap: (){
//             setState(() {
//               RadioVal=6;
//               _pageController.animateToPage(RadioVal, duration: Duration(milliseconds: 350), curve: Curves.decelerate);
//             });
//           },splashColor: Colors.blue,),
//         ),     Visibility(visible: Count>=7,
//           child: InkWell(child: RadioVal==7?Icon(Icons.adjust_outlined,color: clr1,size: 17,):Icon(Icons.circle_outlined,color:clr2,size: 17),onTap: (){
//             setState(() {
//               RadioVal=7;
//               _pageController.animateToPage(RadioVal, duration: Duration(milliseconds: 350), curve: Curves.decelerate);
//             });
//           },splashColor: Colors.blue,),
//         ),     Visibility(visible: Count>=8,
//           child: InkWell(child: RadioVal==8?Icon(Icons.adjust_outlined,color: clr1,size: 17,):Icon(Icons.circle_outlined,color:clr2,size: 17),onTap: (){
//             setState(() {
//               RadioVal=8;
//               _pageController.animateToPage(RadioVal, duration: Duration(milliseconds: 350), curve: Curves.decelerate);
//             });
//           },splashColor: Colors.blue,),
//         ),     Visibility(visible: Count>=9,
//           child: InkWell(child: RadioVal==9?Icon(Icons.adjust_outlined,color: clr1,size: 17,):Icon(Icons.circle_outlined,color:clr2,size: 17),onTap: (){
//             setState(() {
//               RadioVal=9;
//               _pageController.animateToPage(RadioVal, duration: Duration(milliseconds: 350), curve: Curves.decelerate);
//             });
//           },splashColor: Colors.blue,),
//         ),
//       ],
//     );
//   }
//   _selectImage(BuildContext parentContext,index)  {
//     final TextEditingController _ImageUrlController = TextEditingController();
//     late File Files;
//     return showDialog(
//         context: parentContext,
//         builder: (BuildContext context) {
//           return
//            false? SimpleDialog(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//             children: <Widget>[
//               SimpleDialogOption(
//                   padding: const EdgeInsets.all(20),
//                   child: Text('$Takeaphoto'),
//                   onPressed: () async {

//                       var picked = await ImagePicker()
//                           .getImage(source: ImageSource.camera);
//                       if (picked != null) {

//                         setState(() {
//                           Files = File(picked.path);
//                           Filesss.insert(index,Files);

//                         });

//                         var nameImage = basename(picked.path);
//                         res = FirebaseStorage.instance.ref("ShopItems").child(
//                             "$nameImage");
//                         Navigator.pop(parentContext);
//                       }




//                   }),
//               SimpleDialogOption(
//                   padding: const EdgeInsets.all(20),
//                   child: Text('$ChoosefromGallery'),
//                   onPressed: () async {
//                     var picked = await ImagePicker()
//                         .getImage(source: ImageSource.gallery);
//                     if (picked != null) {
//                       setState(() {
//                         Files = File(picked.path);
//                         Filesss.insert(index,Files);
//                       });

//                       var nameImage = basename(picked.path);
//                       res = FirebaseStorage.instance.ref("ShopItems").child(
//                           "$nameImage");
//                       Navigator.pop(parentContext);
//                     }
//                   }),
//               SimpleDialogOption(
//                 padding: const EdgeInsets.all(20),
//                 child: Text("$Cancel"),
//                 onPressed: () {
//                   Navigator.pop(parentContext);
//                 },
//               )
//             ],

//           ):
//            SimpleDialog(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//              children: <Widget>[
//                SimpleDialogOption(
//                    padding: const EdgeInsets.all(20),
//                    child:  TextField(
//                      controller: _ImageUrlController,
//                      decoration: InputDecoration(
//                        hintText: 'Image Url',
//                        border: InputBorder.none,
//                      ),
//                    ),
//                  ),
//                SimpleDialogOption(
//                    padding: const EdgeInsets.all(20),
//                    child: Text('OK'),
//                    onPressed: () async {
//                     setState(() {
//                       imageUrls.insert(index,_ImageUrlController.text);
//                     });
//                      Navigator.pop(parentContext);

//                    }),
//                SimpleDialogOption(
//                  padding: const EdgeInsets.all(20),
//                  child: Text("$Cancel"),
//                  onPressed: () {
//                    Navigator.pop(parentContext);
//                  },
//                )
//              ],

//            )
//           ;
//         });
//   }

//   ShowAllImage(){
//     return
//       PageView.builder(itemBuilder:  (context, index){
//         double myWidth=180;
//         double myleft=85;
//         imageUrls[index]==null?myWidth=180:myWidth=MediaQuery.of(context).size.width;
//         imageUrls[index]==null?myleft=85:myleft=5;
//         if(true){//index==0
//           return Center(
//               child: Container( decoration: BoxDecoration(color:Colors.blueGrey,borderRadius: BorderRadiusDirectional.all(Radius.circular(180))),
//                 width: myWidth,
//                 height: myWidth,
//                 margin: EdgeInsets.only(left: myleft,right: myleft,top: 25),
//                 child: InkWell(focusColor: Colors.black,borderRadius: BorderRadius.circular(180),splashColor: Colors.blue,child:imageUrls[index]==null?Center(child: Text('$done  ${index+1}',style:TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.white),)):Image(image: NetworkImage(imageUrls[index]),fit: BoxFit.fill)
//                     ,  onTap: ()async{
//                       _selectImage(context,index);
//                     }),
//               ));

//         }
//         else{
//           return Center(
//             child: Container( decoration: BoxDecoration(color:Colors.blueGrey,borderRadius: BorderRadiusDirectional.all(Radius.circular(180))),
//               width: myWidth,
//               height:myWidth,
//               margin:EdgeInsets.only(left: myleft,right: myleft,top: 25),
//               child: InkWell(focusColor: Colors.black,borderRadius: BorderRadius.circular(180),splashColor: Colors.blue,child:imageUrls[index]==null?Center(child: Text('$done'+' ${index+1}',style:TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.white),)):Image(image: FileImage(imageUrls[index]),fit: BoxFit.fill,width: MediaQuery.of(context).size.width)
//                   ,  onTap: (){
//                     _selectImage(context,index);


//                   }),
//             ),
//           );

//         }


//       },itemCount:imageUrls.length<11?imageUrls.length:10,controller:_pageController, onPageChanged: onPageChanged,);
//   }
// }