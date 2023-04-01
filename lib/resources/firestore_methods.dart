import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:AliStore/models/post.dart';
import 'package:AliStore/resources/storage_methods.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';


class FireStoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadPost(String description, Uint8List file, String uid,
      String username, String profImage,String Type) async {
    // asking uid here because we dont want to make extra calls to firebase auth when we can just get from our state management
    String res = "Some error occurred";
    String photoUrl="Text";
    try {
      if(Type!="Text") {
         photoUrl = await StorageMethods().uploadImageToStorage(
            'posts', file, true);
      }


      String postId =FirebaseFirestore.instance.collection("posts").doc().id; // creates unique id based on time
      Post post = Post(
        description: description,
        uid: uid,
        username: username,
        likes: [],
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profImage: profImage,
      );
      _firestore.collection('posts').doc(postId).set(post.toJson());
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> likePost(String postId, String uid, List likes) async {
    String res = "Some error occurred";
    try {
      if (likes.contains(uid)) {
        // if the likes list contains the user uid, we need to remove it
        _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid])
        });
      } else {
        // else we need to add uid to the likes array
        _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid])
        });
      }
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Post comment
  Future<String> postComment(String postId, String text, String uid,
      String name, String profilePic,bool VIP) async {
    String res = "Some error occurred";
    try {
      if (text.isNotEmpty) {
        // if the likes list contains the user uid, we need to remove it
        String commentId =FirebaseFirestore.instance.collection("posts").doc().id ;
        _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'VIP':VIP,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
        res = 'success';
      } else {
        res = "Please enter text";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> postBlogComment(String postId, String text, String uid,
      String name, String profilePic,bool VIP,int Count) async {
    String res = "Some error occurred";
    try {
      if (text.isNotEmpty) {
        // if the likes list contains the user uid, we need to remove it
        String commentId =FirebaseFirestore.instance.collection("BlogPosts").doc().id ;
        _firestore
            .collection('BlogPosts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'VIP':VIP,
          'commentId': commentId,
          'datePublished': DateTime.now(),

        });
        res = 'success';
      } else {
        res = "Please enter text";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Delete Post
  Future<String> deletePost(String postId) async {
    String res = "Some error occurred";
    try {
      await _firestore.collection('posts').doc(postId).delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> followUser(
    String uid,
    String followId
  ) async {
    try {
      DocumentSnapshot snap = await _firestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];

      if(following.contains(followId)) {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }

    } catch(e) {
      print(e.toString());
    }
  }

  Future<void> AddMaeber(
      String uid,
      String followId,context
      ) async {
    try {
      DocumentSnapshot snap = await _firestore.collection('Group').doc(uid).get();
      List following = (snap.data()! as dynamic)['member'];
      if(following.contains(followId)) {
        showSnackBar(context,"You are Member !!");
      }
        await _firestore.collection('Group').doc(uid).update({
          'member': FieldValue.arrayUnion([followId])
        });
      }
  catch(e) {
      print(e.toString());
    }
  }
  Future<void> DeleteMember(
      String uid,
      String followId
      ) async {
    try {


        await _firestore.collection('Group').doc(uid).update({
          'member': FieldValue.arrayRemove([followId])
        });

    }
    catch(e) {
      print(e.toString());
    }
  }
  Future<void> addMemberPrivet(
      String uid,//admin
      String followId,//new member
      String GroupID//group ID
      ) async {

      String requestID =FirebaseFirestore.instance.collection("users").doc().id;
     /* DocumentSnapshot snap = await _firestore.collection('Group').doc(uid).get();
      List following = (snap.data()! as dynamic)['member'];
      if(following.contains(followId)) {
        await _firestore.collection('Group').doc(uid).update({
          'member': FieldValue.arrayRemove([followId])
        });
      }*/
      await _firestore.collection('users').doc(uid).collection("request").doc(requestID).set({
        'uId':followId,"GroupId":GroupID,"requestID":requestID
      });

  }



  Future<String> sendMessage(String myId, String text, String yourId,
      String myName, String myProfilePic,String yourName, String yourProfilePic,bool isGroup) async {
    String res = "Some error occurred";
    try {
      if (text.isNotEmpty) {
        if(isGroup){
        // if the likes list contains the user uid, we need to remove it
        String commentId =FirebaseFirestore.instance.collection("chatList").doc().id ;
        //myListChat
        _firestore
            .collection('chatList')
            .doc(yourId).set({'membersID':FieldValue.arrayUnion([myId])},SetOptions(merge: true));

       /* _firestore
            .collection('chatList')
            .doc(myId)
            .collection(yourId)
            .doc(commentId)
            .set({
          'profilePic': yourProfilePic,
          'name': yourName,
          'uid': yourId,
          'text': text,
          'senderId': myId,
          'Online': 0,
          'VIP': false,
          'isGroup':isGroup,
          'datePublished': DateTime.now(),
        },SetOptions(merge: true));
        //myLastChat*/
        _firestore
            .collection('lastChat')
            .doc(myId).collection("allChat").doc(yourId).set({
          'profilePic': yourProfilePic,
          'name': yourName,
          'uid': yourId,
          'isGroup':isGroup,
          'text': text,
          'senderId': myId,
          'Online': 0,
          'VIP': false,
          'datePublished': DateTime.now(),
        });

     /*   _firestore
            .collection('lastChat')
            .doc(yourId).collection("allChat").doc(yourId).set({
          'profilePic': yourProfilePic,
          'name': yourName,
          'uid': yourId,
          'isGroup':isGroup,
          'text': text,
          'Online': 0,
          'VIP': false,
          'senderId': myId,
          'datePublished': DateTime.now(),
        });
*/
        //YouChatLis
        _firestore
            .collection('chatList')
            .doc(yourId)
            .collection(yourId)
            .doc(commentId)
            .set({
          'profilePic': myProfilePic,
          'name': myName,
          'uid': myId,
          'Online': 0,
          'VIP': false,
          'isGroup':isGroup,
          'text': text,
          'senderId': myId,
          'datePublished': DateTime.now(),
          'messageKey':commentId
        },SetOptions(merge: true));



        res = 'success';
      }else{
          // if the likes list contains the user uid, we need to remove it
          String commentId =FirebaseFirestore.instance.collection("chatList").doc().id ;
          //myListChat
          _firestore
              .collection('chatList')
              .doc(myId)
              .collection(yourId)
              .doc(commentId)
              .set({
            'profilePic': yourProfilePic,
            'name': yourName,
            'uid': yourId,
            'isGroup':isGroup,
            'text': text,
            'Online': 0,
            'VIP': false,
            'senderId': myId,
            'datePublished': DateTime.now(),
            'messageKey':commentId
          },SetOptions(merge: true));
          //myLastChat
          _firestore
              .collection('lastChat')
              .doc(myId).collection("allChat").doc(yourId).set({
            'profilePic': yourProfilePic,
            'name': yourName,
            'uid': yourId,
            'isGroup':isGroup,
            'Online': 0,
            'VIP': false,
            'text': text,
            'senderId': myId,
            'datePublished': DateTime.now(),

          });

          //YouChatLis
          _firestore
              .collection('chatList')
              .doc(yourId)
              .collection(myId)
              .doc(commentId)
              .set({
            'profilePic': myProfilePic,
            'name': myName,
            'uid': myId,
            'isGroup':isGroup,
            'Online': 0,
            'VIP': false,
            'text': text,
            'senderId': myId,
            'datePublished': DateTime.now(),
            'messageKey':commentId
          },SetOptions(merge: true));
          //YouLastChat
          _firestore
              .collection('lastChat')
              .doc(yourId).collection("allChat").doc(myId).set({
            'profilePic': myProfilePic,
            'name': myName,
            'uid': myId,
            'Online': 0,
            'VIP': false,
            'isGroup':isGroup,
            'text': text,
            'senderId': myId,
            'datePublished': DateTime.now(),
          });


          res = 'success';
        }
      } else {
        res = "Please enter text";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }


  Future<String> deleteLastChatAndChatList({required LastMessageId,required YourId,required int DeleteOptions}) async {
    String res = "Some error occurred";
    var myID=FirebaseAuth.instance.currentUser!.uid;
    try {
      var ge;
      var ge2;
      switch(DeleteOptions){
        case 0://Delete In My Data
          ge=  await _firestore.collection('chatList').doc('$myID').collection('$YourId').get();ge.docs.forEach((element) async{
              element.reference.delete();
          });
          break;
        case 1://Delete In My And You Data
          ge=  await _firestore.collection('chatList').doc('$myID').collection('$YourId').get();
          ge.docs.forEach((element) async{
            element.reference.delete();
          });
          ge2=    await _firestore.collection('chatList').doc('$YourId').collection('$myID').get();
          ge2.docs.forEach((element) async{
              element.reference.delete();
          });
          break;
        case 2://Delete list  In My Data
          await _firestore.collection('lastChat').doc('$myID').collection('allChat').doc('$YourId').delete();
          break;
        case 3://Delete list And Data In My And You Data

          ge=  await _firestore.collection('chatList').doc('$myID').collection('$YourId').get();
          ge.docs.forEach((element) async{
            element.reference.delete();
          });
          ge2=    await _firestore.collection('chatList').doc('$YourId').collection('$myID').get();
          ge2.docs.forEach((element) async{
            element.reference.delete();
          });
          await _firestore.collection('lastChat').doc('$myID').collection('allChat').doc('$YourId').delete();
          await _firestore.collection('lastChat').doc('$YourId').collection('allChat').doc('$myID').delete();
          break;
        case 4:
          break;
        case 5:
          break;
      }
      res = 'success';
    } catch (err) {
      print('===============================error $err');
      res = err.toString();
    }
    return res;
  }
  Future<String> deleteOneMessage({required MessageID,required YourId,required int DeleteOptions,required bool IsGroup}) async {
    String res = "Some error occurred";
    var myID=FirebaseAuth.instance.currentUser!.uid;
    try {

      switch(DeleteOptions){
        case 0://Delete one Message From Me
         await _firestore.collection('chatList').doc('$myID').collection('$YourId').doc('$MessageID').delete();

          break;
        case 1://Delete one Message From All
          if(IsGroup){
            await _firestore.collection('chatList').doc('$YourId').collection('$YourId').doc('$MessageID').delete();
          }else{
            await _firestore.collection('chatList').doc('$myID').collection('$YourId').doc('$MessageID').delete();
            await _firestore.collection('chatList').doc('$YourId').collection('$myID').doc('$MessageID').delete();
          }
          break;
      }
      res = 'success';
    } catch (err) {
      print('===============================error $err');
      res = err.toString();
    }
    return res;
  }
}

pickImage(ImageSource source) async {
  final ImagePicker _imagePicker = ImagePicker();
  PickedFile? _file = await _imagePicker.getImage(source: source);
  if (_file != null) {
    return await _file.readAsBytes();
  }
  print('No Image Selected');
}

// for displaying snackbars
showSnackBar(BuildContext context, String text) {
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(duration: const Duration(milliseconds: 700),
      content: Text(text),
    ),
  );
}


