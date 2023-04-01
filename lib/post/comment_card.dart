// import 'package:AliStore/resources/MyWidgetFactory.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

// import '../resources/realtime_database_methods.dart';
// class CommentCard extends StatelessWidget {
//   final snap;
//   final postId;
//   final bool IsCommentBlog;
//   const CommentCard({Key? key, required this.snap,required this.postId,required this.IsCommentBlog}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     String img='assets/back.jpg';
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
//       child: Row(
//         children: [
//           snap["VIP"]?ClipRRect(borderRadius:  BorderRadius.circular(25),
//             child: Container(
//               width: 40,height: 40,
//               child: HtmlWidget(
//                 '<img width="40" height="40" src="${snap["profilePic"]}" '
//                     '/>',
//                 factoryBuilder: () => MyWidgetFactory(),enableCaching: true,
//               ),
//             ),
//           ):CircleAvatar(backgroundImage: AssetImage(img),
//             child: Text("${snap["name"].toString().substring(0,1).toUpperCase()}",
//               style:
//               TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
//           ),


//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.only(left: 16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Row(children: [
//                     Text(
//                         '${snap['name']}  ',
//                         style: const TextStyle(fontWeight: FontWeight.bold,)
//                     ),
//                     Expanded(
//                       child: SelectableText(
//                         ' ${snap['text']}',
//                       ),
//                     ),],),

//                   Padding(
//                     padding: const EdgeInsets.only(top: 4),
//                     child: Text(
//                       DateFormat.yMMMd().format(IsCommentBlog?
//     DateTime.parse(snap['datePublished']):snap['datePublished'].toDate(),
//                       ),
//                       style: const TextStyle(
//                           fontSize: 12, fontWeight: FontWeight.w400,),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ),
//           Visibility(visible:snap['uid']==FirebaseAuth.instance.currentUser!.uid ,
//             child: Container(
//               padding: const EdgeInsets.all(8),
//               child:  InkWell(onTap: ()async{
//                 FirebaseFirestore _st=FirebaseFirestore.instance;
//                 if(IsCommentBlog){
//                   await realtimeDb().DeleteCommentBlog(BlogId: postId,CommentId:snap['commentId'] );
//                 }else{
//                   await  _st.collection('posts').doc(postId).collection('comments').doc(snap['commentId']).delete();
//                 }
//               },
//                 child: Icon(
//                   Icons.delete_forever_outlined,color: Colors.indigoAccent,
//                   size: 18,
//                 ),
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }
