// import 'package:AliStore/Dashbord/ImageView.dart';
// import 'package:AliStore/resources/realtime_database_methods.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:AliStore/Dashbord/home.dart';
// import 'package:AliStore/models/user.dart' as model;

// import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
// import 'package:intl/intl.dart';
// import 'package:AliStore/post/comments_screen.dart';
// import 'package:AliStore/post/like_animation.dart';
// import 'package:AliStore/resources/Localizations_constants.dart';
// import 'package:AliStore/resources/firestore_methods.dart';

// import '../resources/MyWidgetFactory.dart';


// class PostCard extends StatefulWidget {
//   final snap;
//   const PostCard({
//     Key? key,
//     required this.snap,
//   }) : super(key: key);

//   @override
//   State<PostCard> createState() => _PostCardState();
// }

// class _PostCardState extends State<PostCard> {
//   int commentLen = 0;
//   bool isLikeAnimating = false;
//   var PostUserName,PostUserImage;
//   FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   @override
//   void initState() {
//     GetingAllNames();
//     super.initState();
//     fetchCommentLen();
//   }

//   fetchCommentLen() async {
//     try {
//       QuerySnapshot snap = await FirebaseFirestore.instance
//           .collection('posts')
//           .doc(widget.snap['postId'])
//           .collection('comments')
//           .get();
//       commentLen = snap.docs.length;
//     } catch (err) {
//       showSnackBar(
//         context,
//         err.toString(),
//       );
//     }
//     setState(() {});
//   }

//   deletePost(String postId) async {
//     try {
//       await FireStoreMethods().deletePost(postId);
//     } catch (err) {
//       showSnackBar(
//         context,
//         err.toString(),
//       );
//     }
//   }
//   GetingAllNames()async{
//     //   ListlastChat.clear();
//     for(int num=0;num<=widget.snap.length-1;num++){
//       try{
// /*
//           var nAndI = await _firestore.collection('users')
//               .where('uID',
//               isEqualTo: widget.snap['uid'])
//               .get();*/
//         var nAndI=await realtimeDb().GetOneUserData(Id: widget.snap['uid']);
//           nAndI.forEach((element) async{
//             DocumentReference myStore = FirebaseFirestore
//                 .instance.collection('posts')
//                 .doc(widget.snap['postId']);
//             if (widget.snap['uid'] ==
//                 element['uID']) {
//               if (widget.snap['name'] !=
//                   element['name']) {
//                 await  myStore.update(
//                     {'name': element['name']});
//               }
//               if (widget.snap['profilePic'] !=
//                   element['imageProFile']) {
//                 await myStore.update({
//                   'profImage': element['imageProFile']
//                 });
//               }
//               if (widget.snap['VIP'] !=
//                   element['VIP']) {
//                 await myStore.update({'VIP': element['VIP']});
//               }
//             }
//           });
//       }catch(d){ print('++++++++++++++++Enter Error  $d');}

//     }

//   }

//   getPostUserName(){
//     for(int x=0;x<myListInfo.length;x++){
//       if(myListInfo[x]['uID']==widget.snap['uid']){
//         PostUserName=myListInfo[x]['name'];
//       }
//     }
//   }
//   getPostUserVIP(){
//     for(int x=0;x<myListInfo.length;x++){
//       if(myListInfo[x]['uID']==widget.snap['uid']){
//         return myListInfo[x]['VIP'];
//       }
//     }
//   }
//   getPostUserImage(){
//     for(int x=0;x<myListInfo.length;x++){
//       if(myListInfo[x]['uID']==widget.snap['uid']){
//         PostUserImage=myListInfo[x]['imageProFile'];
//       }
//     }
//   }



//   @override
//   Widget build(BuildContext context) {
//   String  Delete=getTranslated(context,"Delete");

//     //  final model.User user = Provider.of<UserProvider>(context).getUser;
//     final width = MediaQuery.of(context).size.width;
//    // getPostUserImage();
//   //  getPostUserName();


//     return Container(
//       // boundary needed for web
//       decoration: BoxDecoration(

//       ),
//       padding: const EdgeInsets.symmetric(
//         vertical: 10,
//       ),
//       child: Card(elevation: 1.5,shape:RoundedRectangleBorder(borderRadius:BorderRadius.circular(5)) ,
//         child: Column(
//           children: [
//             // HEADER SECTION OF THE POST
//             Container(
//               padding: const EdgeInsets.symmetric(
//                 vertical: 4,
//                 horizontal: 16,
//               ).copyWith(right: 0),
//               child: Row(
//                 children: <Widget>[
//                   widget.snap['VIP']?ClipRRect(borderRadius:  BorderRadius.circular(16),
//                     child: HtmlWidget(
//                       '<img width="32" height="32" src="${widget.snap['profImage']}" '
//                           '/>',
//                       factoryBuilder: () => MyWidgetFactory(),enableCaching: true,
//                     ),
//                   ):CircleAvatar(backgroundImage: AssetImage(img),
//                     child: Text("${widget.snap['name'].toString().substring(0,1).toUpperCase()}",
//                       style:
//                       TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
//                   ),
//                   Expanded(
//                     child: Padding(
//                       padding: const EdgeInsets.only(
//                         left: 8,
//                       ),
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: <Widget>[
//                           Text(
//                             widget.snap['name'],
//                             style: const TextStyle(
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   widget.snap['uid'].toString() == FirebaseAuth.instance.currentUser!.uid
//                       ? IconButton(
//                           onPressed: () {
//                             showDialog(
//                               useRootNavigator: false,
//                               context: context,
//                               builder: (context) {
//                                 return Dialog(
//                                   child: ListView(
//                                       padding:  EdgeInsets.symmetric(
//                                           vertical: 16),
//                                       shrinkWrap: true,
//                                       children: [
//                                         '$Delete',
//                                       ]
//                                           .map(
//                                             (e) => InkWell(
//                                                 child: Container(
//                                                   padding:
//                                                       const EdgeInsets.symmetric(
//                                                           vertical: 12,
//                                                           horizontal: 16),
//                                                   child: Text("$e"),
//                                                 ),
//                                                 onTap: () {
//                                                   deletePost(
//                                                     widget.snap['postId']
//                                                         .toString(),
//                                                   );
//                                                   // remove the dialog box
//                                                   Navigator.of(context).pop();
//                                                 }),
//                                           )
//                                           .toList()),
//                                 );
//                               },
//                             );
//                           },
//                           icon: const Icon(Icons.more_vert),
//                         )
//                       : Container(),
//                 ],
//               ),
//             ),
//             Container(padding: EdgeInsets.all(8),
//               child: Row(mainAxisAlignment: MainAxisAlignment.start,
//                 children: [Expanded(child: SelectableText(' ${widget.snap['description']}'))],),
//             ),
//             // IMAGE SECTION OF THE POST
//             GestureDetector(
//               onTap: (){
//                 if( widget.snap['postUrl']!="Text") {
//                   Navigator.of(context).push(
//                       MaterialPageRoute(
//                         builder: (context) =>
//                             ImageViewS(imageUrl: widget.snap['postUrl']),
//                       ));
//                 }
//               },
//               onDoubleTap: () {
//                 FireStoreMethods().likePost(
//                   widget.snap['postId'].toString(),
//                   FirebaseAuth.instance.currentUser!.uid,
//                   widget.snap['likes'],
//                 );
//                 setState(() {
//                   isLikeAnimating = true;
//                 });
//               },
//               child: Stack(
//                 alignment: Alignment.center,
//                 children: [
//                   Visibility(visible: widget.snap['postUrl'].toString()=="Text"?false:true,
//                     child: SizedBox(
//                       height:MediaQuery.of(context).size.height*.30,//MediaQuery.of(context).size.width>=502?MediaQuery.of(context).size.height/2.5: MediaQuery.of(context).size.height * 0.45,
//                       width:  MediaQuery.of(context).size.width,// widget.snap['postUrl'].toString()
//                       child: HtmlWidget(
//                         // MediaQuery.of(context).size.width
//                         '<img width="${ MediaQuery.of(context).size.width>=600?MediaQuery.of(context).size.width*1.15:MediaQuery.of(context).size.width*7}" height="${MediaQuery.of(context).size.width>=600?MediaQuery.of(context).size.height*.90:MediaQuery.of(context).size.height*2}" src="${widget.snap['postUrl'].toString()}" '
//                             '/>',
//                         factoryBuilder: () => MyWidgetFactory(),enableCaching: true,
//                       ),
//                     ),
//                   ),
//                   AnimatedOpacity(
//                     duration: const Duration(milliseconds: 200),
//                     opacity: isLikeAnimating ? 1 : 0,
//                     child: LikeAnimation(
//                       isAnimating: isLikeAnimating,
//                       child: const Icon(
//                         Icons.whatshot_outlined,
//                         color:Colors.blueGrey,
//                         size: 100,
//                       ),
//                       duration: const Duration(
//                         milliseconds: 400,
//                       ),
//                       onEnd: () {
//                         setState(() {
//                           isLikeAnimating = false;
//                         });
//                       },
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             // LIKE, COMMENT SECTION OF THE POST
//             Row(
//               children: <Widget>[
//                 LikeAnimation(
//                   isAnimating: widget.snap['likes'].contains(FirebaseAuth.instance.currentUser!.uid),
//                   smallLike: true,
//                   child: IconButton(
//                     icon: widget.snap['likes'].contains(FirebaseAuth.instance.currentUser!.uid)
//                         ? const Icon(
//                       Icons.whatshot_outlined,
//                             color: Colors.red,
//                           )
//                         : const Icon(
//                       Icons.whatshot_outlined,
//                           ),
//                     onPressed: () => FireStoreMethods().likePost(
//                       widget.snap['postId'].toString(),
//                       FirebaseAuth.instance.currentUser!.uid,
//                       widget.snap['likes'],
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   icon: const Icon(
//                     Icons.comment_outlined,
//                   ),
//                   onPressed: () => Navigator.of(context).push(
//                     MaterialPageRoute(
//                       builder: (context) => CommentsScreen(
//                         postId: widget.snap['postId'].toString(),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Visibility(visible: false,
//                   child: IconButton(
//                       icon: const Icon(
//                         Icons.send,
//                       ),
//                       onPressed: () {}),
//                 ),
//                 Expanded(
//                     child: Align(
//                   alignment: Alignment.bottomRight,
//                   child: Text(
//     DateFormat.yMMMd()
//           .format(widget.snap['datePublished'].toDate()),
//     style:  TextStyle(

//     ),
//     ),
//                 ))
//               ],
//             ),
//             //DESCRIPTION AND NUMBER OF COMMENTS
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   DefaultTextStyle(
//                       style: Theme.of(context)
//                           .textTheme
//                           .subtitle2!
//                           .copyWith(fontWeight: FontWeight.w800),
//                       child: Text(
//                         '${widget.snap['likes'].length} likes',
//                         style: Theme.of(context).textTheme.bodyText2,
//                       )),

//                   Container(
//                     padding: const EdgeInsets.symmetric(vertical: 4),
//                   ),
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

// /*  Container(
//                   width: double.infinity,
//                   padding: const EdgeInsets.only(
//                     top: 8,
//                   ),
//                   child: RichText(
//                       text: TextSpan(
//                       children: [

//                         TextSpan(
//                           text: ' ${widget.snap['description']}',
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),*/
