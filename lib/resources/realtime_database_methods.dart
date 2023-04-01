// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';

// class realtimeDb {
//   //FirebaseApp secondaryApp = Firebase.app('DEFAULT');

// //   FirebaseDatabase.instance.setPersistenceEnabled(true);
//   //FirebaseDatabase db = FirebaseDatabase.instance;


//   Future<String>  CreateNewUser({required String Email,required String Token})async{
//     FirebaseApp secondaryApp = Firebase.app();
// //   FirebaseDatabase.instance.setPersistenceEnabled(true);
//     FirebaseDatabase db = FirebaseDatabase.instanceFor(app: secondaryApp,databaseURL: 'https://one-piece-b44fe-default-rtdb.firebaseio.com/');
//     var Tag=db.ref('Users').push().key;
//     try {
//       db.ref('Users/').child('${FirebaseAuth.instance.currentUser!.uid}').set({"email":"$Email",
//         "points":0,"token":"$Token", "followers": [],"name":"OneLand User","imageProFile":"Text","Online":0,"status":"Have fun, life is short",
//         "following": [],"VIP":false,"request":[],"uID":"${ FirebaseAuth.instance.currentUser!.uid}"
//       });
//     }catch(e){return 'Error, try again.later';}
//     return 'Done';
//   }

//   Future<String>  UpdateNewUser({required String Name,required String Status,required String ImageProFile})async{
//     FirebaseApp secondaryApp = Firebase.app();
// //   FirebaseDatabase.instance.setPersistenceEnabled(true);
//     FirebaseDatabase db = FirebaseDatabase.instanceFor(app: secondaryApp,databaseURL: 'https://one-piece-b44fe-default-rtdb.firebaseio.com/');
//     var Tag=db.ref('Users').push().key;
//     try {
//       db.ref('Users/').child('${FirebaseAuth.instance.currentUser!.uid}').update({
//         "name": '$Name',
//         "status": '$Status',
//         "imageProFile": '$ImageProFile'});
//     }catch(e){return 'Error, try again.later';}
//     return 'Done';
//   }

//   GetAllUserData({required int Limite})async{await Firebase.initializeApp();
//   FirebaseApp secondaryApp = Firebase.app();

//   FirebaseDatabase db = FirebaseDatabase.instanceFor(app: secondaryApp,databaseURL: 'https://one-piece-b44fe-default-rtdb.firebaseio.com/');

//   var Tag=db.ref('Users').push().key;
//   List user=[{}];
//   // user.clear();
//   int i=0;
//   try {
//     await db
//         .ref('Users/')
//         .limitToLast(Limite)
//         .once()
//         .then((event) {
//       //user.clear();
//       for (final child in event.snapshot.children) {
//         // Handle the post.FAbhSsa4M3ZAVrK1KfksFxIAEzW2
//         var val = child.value as Map<String, dynamic>;
//         var tag = child.key;
//         //{tag:val}
//         user.add( val);
//         i += 1;
//       }
//     });
//     return user;
//   }catch(e){
//     return user;
//   }

//   }

//   GetOneUserData({required Id})async{await Firebase.initializeApp();
//   FirebaseApp secondaryApp = Firebase.app();

//   FirebaseDatabase db = FirebaseDatabase.instanceFor(app: secondaryApp,databaseURL: 'https://one-piece-b44fe-default-rtdb.firebaseio.com/');

//   var Tag=db.ref('Users').push().key;
//   List user=[{}];
//   int i=0;
//   try {
//     user.clear();
//     await db
//         .ref('Users/$Id')
//         .once()
//         .then((event) {
//       var val = event.snapshot.value as Map<String, dynamic>;
//       user.add( val);
//     });
//     return user;
//   }catch(e){
//     return user;
//   }

//   }

//   SetOnline({required int Online})async{
//     FirebaseApp secondaryApp = Firebase.app();

//     FirebaseDatabase db = FirebaseDatabase.instanceFor(app: secondaryApp,databaseURL: 'https://one-piece-b44fe-default-rtdb.firebaseio.com/');

//     var Tag=db.ref('Users').push().key;
//     var Id=FirebaseAuth.instance.currentUser!.uid;
//     await db
//         .ref('Users/$Id').update({"Online": Online});

//   }

//   Future<String>  AddCommentToBlog({required BlogId,required CommentText,required Name,required ProfileImage,required MyId,required bool IsVIP,required int FinalCommentCount,required int AllCommentLength,required bool IsAddComments})async{
//     FirebaseApp secondaryApp = Firebase.app();
//     FirebaseDatabase db = FirebaseDatabase.instanceFor(app: secondaryApp,databaseURL: 'https://one-piece-b44fe-default-rtdb.firebaseio.com/');
//     var Tag=db.ref('Users').push().key;
//     String res='';
//     try{
//       db.ref('BlogPosts/').child('$BlogId').child('comments').child('$Tag').set(
//           {
//             'profilePic': ProfileImage,
//             'name': Name,
//             'uid': MyId,
//             'text': CommentText,
//             'VIP':IsVIP,
//             'commentId': Tag,
//             'datePublished': DateTime.now().toString(),

//           }
//       );
//       /* db.ref('BlogPosts/').child('$BlogId').update({'finalCommentCount':FinalCommentCount});
//      if(IsAddComments==false) {
//        db.ref('BlogPosts/').child('$BlogId/').update(
//            {'AllCommentsIDs/$AllCommentLength': [MyId]});
//      }*/

//       res='Done';
//     }catch(e){
//       print('======================Erorr $e');
//       res= 'Error $e';
//     }
//     return res;
//   }

//   Future<String>  UpdateOneCommentToBlog({required BlogId,required CommentId,required Name,required ProfileImage,required bool IsVIP,required int WhatThisUpdate})async{
//     FirebaseApp secondaryApp = Firebase.app();
//     FirebaseDatabase db = FirebaseDatabase.instanceFor(app: secondaryApp,databaseURL: 'https://one-piece-b44fe-default-rtdb.firebaseio.com/');

//     String res='';
//     try{
//       /*    'profilePic': ProfileImage,
//     'name': Name,
//     'VIP':IsVIP,*/
//       if(WhatThisUpdate==0){
//         db.ref('BlogPosts/').child('$BlogId').child('comments').child('$CommentId').update(
//             {'name':Name}
//         );
//       }
//       if(WhatThisUpdate==1){
//         db.ref('BlogPosts/').child('$BlogId').child('comments').child('$CommentId').update(
//             {'profilePic':ProfileImage}
//         );
//       }
//       if(WhatThisUpdate==2){
//         db.ref('BlogPosts/').child('$BlogId').child('comments').child('$CommentId').update(
//             {'VIP':IsVIP}
//         );
//       }

//       res='Done';
//     }catch(e){
//       print('======================Erorr $e');
//       res= 'Error $e';
//     }
//     return res;
//   }

//   Future<String>  UpdateOneUsetToBlog({required BlogId,required Name,required ProfileImage,required bool IsVIP,required int WhatThisUpdate})async{
//     FirebaseApp secondaryApp = Firebase.app();
//     FirebaseDatabase db = FirebaseDatabase.instanceFor(app: secondaryApp,databaseURL: 'https://one-piece-b44fe-default-rtdb.firebaseio.com/');

//     String res='';
//     try{
//       /*    'profilePic': ProfileImage,
//     'name': Name,
//     'VIP':IsVIP,*/
//       if(WhatThisUpdate==0){
//         db.ref('BlogPosts/$BlogId').update(
//             {'UserName':Name}
//         );
//       }
//       if(WhatThisUpdate==1){
//         db.ref('BlogPosts/$BlogId').update(
//             {'UserImage':ProfileImage}
//         );
//       }
//       if(WhatThisUpdate==2){
//         db.ref('BlogPosts/$BlogId').update(
//             {'VIP':IsVIP}
//         );
//       }

//       res='Done';
//     }catch(e){
//       print('======================Erorr $e');
//       res= 'Error $e';
//     }
//     return res;
//   }

//   GetCommentToBlog({required BlogId,required int Limit}){
//     FirebaseApp secondaryApp = Firebase.app();
//     FirebaseDatabase db = FirebaseDatabase.instanceFor(app: secondaryApp,databaseURL: 'https://one-piece-b44fe-default-rtdb.firebaseio.com/');
//     var Tag=db.ref('BlogPosts').push().key;
//     List BlogsComments=[{}];
//     BlogsComments.clear();
//     int i=0;
//     try{
//       db.ref('BlogPosts').child('$BlogId').child('comments').limitToLast(Limit).once()
//           .then((event) {
//         for (final child in event.snapshot.children) {
//           // Handle the post.FAbhSsa4M3ZAVrK1KfksFxIAEzW2
//           var val = child.value as Map<String, dynamic>;
//           var tag = child.key;
//           //{tag:val}
//           BlogsComments.add( val);
//           i += 1;
//         }

//       });
//       return BlogsComments;
//     }catch(e){
//       print('======================Erorr $e');

//     }
//   }

//   GetBlogsCommentCount({required BlogId,required bool NeedCommentlength})async{
//     FirebaseApp secondaryApp = Firebase.app();
//     FirebaseDatabase db = FirebaseDatabase.instanceFor(app: secondaryApp,databaseURL: 'https://one-piece-b44fe-default-rtdb.firebaseio.com/');
//     var Tag=db.ref('BlogPosts').push().key;
//     dynamic  a=[];
//     dynamic  b=[];
//     var count=0;
//     var countAll=0;
//     await db.ref('BlogPosts').child('$BlogId').once()
//         .then((event) {
//       count=event.snapshot.child('AllCommentsIDs').children.length;
//       var we=event.snapshot.value as Map<String, dynamic> ;
//       a.add( we);
//     });

//     b=a;
//     countAll=count;
//     if(NeedCommentlength) {
//       return countAll;
//     }else{
//       return b[0]['finalCommentCount'];
//     }
//   }

//   GetFollowers({required Id,required bool NeedfollowersCount})async{
//     FirebaseApp secondaryApp = Firebase.app();
//     FirebaseDatabase db = FirebaseDatabase.instanceFor(app: secondaryApp,databaseURL: 'https://one-piece-b44fe-default-rtdb.firebaseio.com/');
//     dynamic  a=[];
//     dynamic  b=[];
//     var count=0;
//     var countAll=0;
//     var key;
//     bool ex=false;
//     await db.ref('Users/$Id').once()
//         .then((event) {
//       count=event.snapshot.child('followers').children.length;
//       ex=event.snapshot.child('followers/${FirebaseAuth.instance.currentUser!.uid}').exists;
//       var we=event.snapshot.value as Map<String, dynamic> ;
//       a.add( we);

//     });

//     b=a;
//     countAll=count;

//     if(NeedfollowersCount) {
//       return countAll;
//     }else{
//       return ex;
//     }
//   }

//   GetFollowing({required Id,required bool NeedfollowingCount})async{
//     FirebaseApp secondaryApp = Firebase.app();
//     FirebaseDatabase db = FirebaseDatabase.instanceFor(app: secondaryApp,databaseURL: 'https://one-piece-b44fe-default-rtdb.firebaseio.com/');
//     dynamic  a=[];
//     dynamic  b=[];
//     var count=0;
//     var countAll=0;
//     bool ex=false;
//     await db.ref('Users/$Id').once()
//         .then((event) {
//       count=event.snapshot.child('following').children.length;
//       ex=event.snapshot.child('followers/${FirebaseAuth.instance.currentUser!.uid}').exists;

//       var we=event.snapshot.value as Map<String, dynamic> ;
//       a.add( we);
//     });

//     b=a;
//     countAll=count;
//     if(NeedfollowingCount) {
//       return countAll;
//     }else{
//       return ex;
//     }
//   }

//   AddFollows({required Id,required bool followers})async{
//     FirebaseApp secondaryApp = Firebase.app();
//     FirebaseDatabase db = FirebaseDatabase.instanceFor(app: secondaryApp,databaseURL: 'https://one-piece-b44fe-default-rtdb.firebaseio.com/');
//     var myId=FirebaseAuth.instance.currentUser!.uid;

//     if(followers==false) {
//       db.ref('Users/$Id').
//       update({'followers/${myId}':['${myId}']});
//     }else{
//       db.ref('Users/$Id').
//       child('followers/${myId}').remove();
//     }
//   }

//   AddFollowing({required Id,required bool followers})async{
//     FirebaseApp secondaryApp = Firebase.app();
//     FirebaseDatabase db = FirebaseDatabase.instanceFor(app: secondaryApp,databaseURL: 'https://one-piece-b44fe-default-rtdb.firebaseio.com/');
//     var myId=FirebaseAuth.instance.currentUser!.uid;
//     if(followers==false) {
//       db.ref('Users/$myId').
//       update({'following/${Id}':['${Id}']});
//     }else{
//       db.ref('Users/$myId').
//       child('following/${Id}').remove();
//     }
//   }

//   DeleteCommentBlog({required BlogId,required CommentId})async{
//     FirebaseApp secondaryApp = Firebase.app();
//     FirebaseDatabase db = FirebaseDatabase.instanceFor(app: secondaryApp,databaseURL: 'https://one-piece-b44fe-default-rtdb.firebaseio.com/');
//     var Tag=db.ref('BlogPosts').push().key;

//     await  db.ref('BlogPosts').child('$BlogId').child('comments/$CommentId').remove();
//   }

//   GetAllBlog({required int Limit,required String Value ,required Keys}){
//     FirebaseApp secondaryApp = Firebase.app();
//     FirebaseDatabase db = FirebaseDatabase.instanceFor(app: secondaryApp,databaseURL: 'https://one-piece-b44fe-default-rtdb.firebaseio.com/');
//     var Tag=db.ref('BlogPosts').push().key;
//     List Blogs=[{}];
//     int i=0;
//     try{//.startAfter(Value)
//       db.ref('BlogPosts').limitToLast(Limit).orderByChild('date').once()
//           .then((event) {
//         for (final child in event.snapshot.children) {
//           // Handle the post.FAbhSsa4M3ZAVrK1KfksFxIAEzW2
//           var val = child.value as Map<String, dynamic>;
//           var tag = child.key;
//           //{tag:val}
//           Blogs.add( val);
//           i += 1;
//         }
//       });
//       return Blogs;
//     }catch(e){
//       print('======================Erorr $e');

//     }
//   }

//   GetBlogsLimit()async{
//     FirebaseApp secondaryApp = Firebase.app();
//     FirebaseDatabase db = FirebaseDatabase.instanceFor(app: secondaryApp,databaseURL: 'https://one-piece-b44fe-default-rtdb.firebaseio.com/');
//     var Tag=db.ref('BlogPosts').push().key;
//     dynamic  a=[];
//     dynamic  b=[];
//     await db.ref('BlogLimit').once()
//         .then((event) {
//       var we=event.snapshot.value as Map<String, dynamic> ;
//       a.add( we);
//     });

//     b=a;
//     return b[0]['BlogLimit'];
//   }

//   EditNameAndStatus({required NewName,required NewStatus,required bool NameOrStatus})async{
//     FirebaseApp secondaryApp = Firebase.app();
//     FirebaseDatabase db = FirebaseDatabase.instanceFor(app: secondaryApp,databaseURL: 'https://one-piece-b44fe-default-rtdb.firebaseio.com/');
//     var myId=FirebaseAuth.instance.currentUser!.uid;
//     if(NameOrStatus) {
//       await db.ref('Users/$myId').
//       update({'name':'${NewName}'});
//     }else{
//       await db.ref('Users/$myId').
//       update({'status':'${NewStatus}'});
//     }
//   }

//   EditImage({required NewImage})async {
//     FirebaseApp secondaryApp = Firebase.app();
//     FirebaseDatabase db = FirebaseDatabase.instanceFor(app: secondaryApp,
//         databaseURL: 'https://one-piece-b44fe-default-rtdb.firebaseio.com/');
//     var myId = FirebaseAuth.instance.currentUser!.uid;
//     await db.ref('Users/$myId').
//     update({'imageProFile': ['${NewImage}']});

//   }

//   SearchUsers({required Name})async{await Firebase.initializeApp();
//   FirebaseApp secondaryApp = Firebase.app();

//   FirebaseDatabase db = FirebaseDatabase.instanceFor(app: secondaryApp,databaseURL: 'https://one-piece-b44fe-default-rtdb.firebaseio.com/');

//   var Tag=db.ref('Users').push().key;
//   List user=[{}];
//   int i=0;
//   try {
//     user.clear();
//     await db
//         .ref('Users/').orderByChild('name/$Name')
//         .once()
//         .then((event) {
//       var val = event.snapshot.value as Map<String, dynamic>;
//       user.add( val);
//     });
//     return user;
//   }catch(e){
//     return user;
//   }

//   }











// }

























// //await Firebase.initializeApp(name: 'onepiece');
// //  FirebaseApp secondaryApp = Firebase.app('DEFAULT');
// //   FirebaseDatabase.instance.setPersistenceEnabled(true);

// // FirebaseDatabase database = FirebaseDatabase.instanceFor(app: secondaryApp,databaseURL: 'https://one-piece-b44fe-default-rtdb.firebaseio.com/');
// //var kesss=database.ref('Users/').push().key;
// /*
//    List user=[{}];
//    int i=0;
//    await database.ref('Users/').limitToLast(1).onValue.listen((event) {
//      user.clear();
//       for (final child in event.snapshot.children) {
//         // Handle the post.FAbhSsa4M3ZAVrK1KfksFxIAEzW2
//         var val=child.value  as Map<String, dynamic>;
//         var tag=child.key ;
//        //{tag:val}
//         user.insert(i,val );
//         i+=1;
//       }
//     }, onError: (error) {
//       // Error.
//     });
//    print('======================Data dsdsss  \n  ${user}');*/