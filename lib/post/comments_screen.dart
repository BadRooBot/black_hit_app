import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:AliStore/Dashbord/home.dart';
import 'package:AliStore/post/comment_card.dart';
import 'package:AliStore/resources/Localizations_constants.dart';
import 'package:AliStore/resources/firestore_methods.dart';

import '../resources/realtime_database_methods.dart';


class CommentsScreen extends StatefulWidget {
  final postId;
  const CommentsScreen({Key? key, required this.postId}) : super(key: key);

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController commentEditingController =
      TextEditingController();
  List newListComments = [];
  void postComment(String uid, String name, String profilePic,bool VIP) async {
    try {
      String res = await FireStoreMethods().postComment(
        widget.postId,
        commentEditingController.text,
        uid,
        name,
        profilePic,VIP
      );

      if (res != 'success') {
        showSnackBar(context, res);
      }
      setState(() {
        commentEditingController.text = "";
      });
    } catch (err) {
      showSnackBar(
        context,
        err.toString(),
      );
    }
  }
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
 //   final User user = Provider.of<UserProvider>(context).getUser;
    String Comments=getTranslated(context,"Comments");
    String Commentas=getTranslated(context,"Commentas");
    String Post=getTranslated(context,"Post");
    newListComments.clear();

    return Scaffold(
      appBar: AppBar(

        title:  Text(
          '$Comments',
        ),
        centerTitle: false,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .doc(widget.postId)
            .collection('comments')
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          newListComments.clear();
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (ctx, index){
              if(snapshot.data!.docs.isNotEmpty){
                AllUpdateNames(index)async{
                  //   ListlastChat.clear();
                  for(int num=0;num<=snapshot.data!.docs.length-1;num++){
                    try{
                       /* var nAndI = await _firestore.collection('users')
                            .where('uID',
                            isEqualTo: snapshot.data!.docs[num]['uid'])
                            .get();*/
                      var nAndI=await realtimeDb().GetOneUserData(Id: snapshot.data!.docs[num]['uid']);
                        nAndI.forEach((element) async {
                          DocumentReference myStore = FirebaseFirestore
                              .instance.collection('posts')
                              .doc(widget.postId)
                              .collection('comments').doc(snapshot.data!.docs[num]['commentId']);
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
                          }
                        });
                    }catch(d){ print('++++++++++++++++Enter Error  $d');}

                  }

                }
              if(snapshot.data!.docs.length-1==index){
                AllUpdateNames(index);
              }
                getName(index)async{
                  newListComments.add(snapshot.data!.docs[index]);
                  for (int xx = 0; xx <snapshot.data!.docs.length; xx++) {

                    var ae=await _firestore.collection('users').where('uID',isEqualTo:newListComments[index]['uid'] ).get();
                    ae.docs.forEach((element) {
                      setState(() {
                        newListComments[index]['name']=element['name'];
                        newListComments[index]['VIP']=element['VIP'];
                        newListComments[index]['profilePic']=element['imageProFile'];
                      });

                    });
                  }
/*                           newListComments.add({
                        'VIP':element.data()["VIP"],
                        'profilePic':element.data()["imageProFile"]
                        ,'name':element.data()["name"],
                        'text':snapshot.data!.docs[index]["text"],
                        'datePublished':snapshot.data!.docs[index]["datePublished"]
                      });

               if (myListInfo[xx]["uID"] == snapshot.data!.docs[index]["uid"]) {
                      newListComments.add({
                        'VIP':myListInfo[xx]["VIP"],
                        'profilePic':myListInfo[xx]["imageProFile"]
                        ,'name':myListInfo[xx]["name"],
                        'text':snapshot.data!.docs[index]["text"],
                        'datePublished':snapshot.data!.docs[index]["datePublished"]
                      });

                      return newListComments[index];
                    }
*/
                }

              return CommentCard(
              snap:snapshot.data!.docs[index],postId: widget.postId,IsCommentBlog: false,
            );}else{return Text('');}
            }
          );
        },
      ),
      // text input
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          padding: const EdgeInsets.only(left: 16, right: 8),
          child: Row(
            children: [
              UserInfoList[0]['VIP']?    CircleAvatar(
                backgroundImage: NetworkImage("${UserInfoList[UserInfoList.length - 1]["imageProFile"]}"),
                radius: 18,
              ):CircleAvatar(backgroundImage: AssetImage(img),
                child: Text("${UserInfoList[0]["name"].toString().substring(0,1).toUpperCase()}",
                  style:
                  TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 8),
                  child:
                  TextField(
                    controller: commentEditingController,
                    decoration: InputDecoration(
                      hintText: '$Commentas'+"${UserInfoList[UserInfoList.length - 1]["name"]}",
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () => postComment(
                  FirebaseAuth.instance.currentUser!.uid,
                  "${UserInfoList[UserInfoList.length - 1]["name"]}",
                  "${UserInfoList[UserInfoList.length - 1]["imageProFile"]}",
                    UserInfoList[UserInfoList.length - 1]["VIP"]
                ),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child:  Text(
                    '$Post',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
