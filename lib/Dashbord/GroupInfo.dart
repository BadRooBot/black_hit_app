/*import 'dart:typed_data';
import 'package:AliStore/resources/MyWidgetFactory.dart';
import 'package:AliStore/resources/realtime_database_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart' as image;
import 'package:AliStore/Dashbord/profile.dart';
import 'package:AliStore/post/follow_button.dart';
import 'package:AliStore/resources/Localizations_constants.dart';
import 'package:AliStore/resources/firestore_methods.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';


class GroupInfo extends StatefulWidget {
  final uid;
  const GroupInfo({Key? key,required this.uid}) : super(key: key);

  @override
  _GroupInfoState createState() => _GroupInfoState();
}
Uint8List? _file;
var userSnap;
String img='assets/back.jpg';

List postSnap=[{}];
List dd=[{}];
CollectionReference memberSnap =
FirebaseFirestore.instance.collection("users");
class _GroupInfoState extends State<GroupInfo> {



  _selectImage(BuildContext parentContext) async {
    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Create a Group'),
          children: <Widget>[
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a photo'),
                onPressed: () async {
                  Navigator.pop(context);
                  Uint8List file = await pickImage(image.ImageSource.camera);
                  setState(() {
                    _file = file;

                  });
                }),
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose from Gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(image.ImageSource.gallery);
                  setState(() {
                    _file = file;

                  });
                }),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  var userData = {};
  var adminId = "";
  var myId = "";
  int postLen = 0;
  int member = 0;
  List Stmember=[] ;
  var request ;
  bool isFollowing = false;
  bool isLoading = true;
  bool isSendRequest = false;

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
  //  userData.clear();
    postSnap.clear();
    userSnap = await FirebaseFirestore.instance
        .collection('Group')
        .doc(widget.uid)
        .get();
    try {
    setState(() {
      isLoading = true;
      userData = userSnap.data()!;
      adminId = userSnap.data()!["adminId"];
      member = userSnap.data()!['member'].length;
      Stmember = userSnap.data()!['member'];

      isFollowing = userSnap
          .data()!['member']
          .contains(FirebaseAuth.instance.currentUser!.uid);

    });
    List d=[];
    Stmember.forEach((element) async{
      var getAllMemberDatat=await realtimeDb().GetOneUserData(Id: element);

      postSnap+=getAllMemberDatat;
    });


      // get post lENGTH

      GetRequssst();

      myId=FirebaseAuth.instance.currentUser!.uid;

    } catch (e) {
      showSnackBar(
        context,
        e.toString(),
      );
    }
    setState(() {
      isLoading = false;
    });
  }
  GetRequssst() async{
    var AllRequest= await  FirebaseFirestore.instance.collection('users').doc(adminId).collection("request").get();
    AllRequest.docs.forEach((element) {
      if(myId.contains(element["uId"])){
        setState(() {
          request=element["requestID"];
          isSendRequest=true;
        });
      }else{
        setState(() {
          request=null;
          isSendRequest=false;
        });
      }


    });
  }

  @override
  Widget build(BuildContext context) {
    String Done = getTranslated(context,'Done');
    String GroupName = getTranslated(context,'GroupName');
    String GroupDesc = getTranslated(context,'GroupDesc');
    String Groupcount = getTranslated(context,'Groupcount');
    String UnRequest = getTranslated(context,'UnRequest');
    String SendRequest = getTranslated(context,'SendRequest');
    String Out = getTranslated(context,'Out');
    String Exit = getTranslated(context,'Exit');
    String Enter = getTranslated(context,'Enter');
    String AllMember = getTranslated(context,'AllMember');

    return Scaffold(
      appBar: AppBar(title: Text("${userData["name"]??''}")),
      body: isLoading?Card(child: LinearProgressIndicator()):
      ListTile(minVerticalPadding: 0,contentPadding:EdgeInsets.zero ,
        title: Container(
          child: Column(children: [
            userData.isEmpty?Center(child: CircularProgressIndicator(),): userData["VIP"]?HtmlWidget(
              '<img width="${MediaQuery.of(context).size.width}" height="${MediaQuery.of(context).size.width>=600?MediaQuery.of(context).size.height / 2:MediaQuery.of(context).size.height / 3}" src="${userData["profilePic"]}" '
                  '/>',
              factoryBuilder: () => MyWidgetFactory(),enableCaching: true,
            ):
            Container(width: MediaQuery.of(context).size.width,height: MediaQuery.of(context).size.height / 3,
              decoration:BoxDecoration(image:DecorationImage(image: AssetImage(img))),// AssetImage(img),
    child: Center(
      child: Text("${userData["name"].toString().substring(0,1).toUpperCase()}",
      style:
      TextStyle(fontSize: 74,fontWeight: FontWeight.bold,color: Colors.white),),
    ),
    ),

          Container(
              padding: EdgeInsets.only(top: 15,left: 5,right: 5),
              child: Row(children: [
                Text("$GroupName",),
                SizedBox(width: 25,),
                Expanded(child: Text("${userData["name"]}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16)))
              ],),
            ),
            Container(
              padding: EdgeInsets.only(top: 15,left: 5,right: 5),
              child: Row(children: [
                Expanded(child:Text("$GroupDesc")),
                SizedBox(width: 25,),
                Expanded(child: Text("${userData["bio"]}"))
              ],),
            ),
            Container(
              padding: EdgeInsets.only(top: 15,left: 5,right: 5),
              child: Row(children: [
                Text("$Groupcount"),
                SizedBox(width: 25,),
                Text("$member")
              ],),
            ),

            SizedBox(height: 10,),
            //Button 1
          userData["Type"]==1?isFollowing? FollowButton(textColor:Colors.white,backgroundColor: Theme.of(context).appBarTheme.backgroundColor,splashColor: Colors.blueGrey,text:("$Out"),
            function:() async{
            await FireStoreMethods().DeleteMember(userData["GroupId"], FirebaseAuth.instance.currentUser!.uid);
            }
            ,) :FollowButton(textColor:Colors.white,backgroundColor: Theme.of(context).appBarTheme.backgroundColor,splashColor: Colors.blueGrey,text:request==null?"$SendRequest":"$UnRequest",
            function:() async{
             isSendRequest?await FirebaseFirestore.instance.collection('users').doc(adminId).collection("request").doc(request).delete().whenComplete(() { showSnackBar(context, "$Done");
            setState(() {
              request=null;
              isSendRequest=false;
            });
             GetRequssst();
             })
                 : await FireStoreMethods().addMemberPrivet(adminId, FirebaseAuth.instance.currentUser!.uid,userData["GroupId"]).whenComplete(() {
               showSnackBar(context, "$Done");
               GetRequssst();
             });
            }
            ,)
          //Button 2
              :isFollowing?FollowButton(textColor:Colors.white,backgroundColor: Theme.of(context).appBarTheme.backgroundColor,splashColor: Colors.blueGrey,text:"$Exit",function:() async{
             await FireStoreMethods().DeleteMember(widget.uid, FirebaseAuth.instance.currentUser!.uid);}
            ,):FollowButton(textColor:Colors.white,backgroundColor: Theme.of(context).appBarTheme.backgroundColor,splashColor: Colors.blueGrey,text:"$Enter",function:() async{
            await FireStoreMethods().AddMaeber(widget.uid, FirebaseAuth.instance.currentUser!.uid,context);}
            ,),
            SizedBox(height: 20,),
               Text("$AllMember"),

               Expanded(
                 child: ListView.builder(shrinkWrap: false,physics: ScrollPhysics(parent:BouncingScrollPhysics()),reverse: false,itemCount: postSnap.length,itemBuilder: (context,index){

                    return Column(
                      children: [
                        SizedBox(width: MediaQuery.of(context).size.width-1.7,height: 90,
                          child: InkWell(onTap: (){

                          },splashColor: Colors.blueAccent,borderRadius: BorderRadius.circular(15),
                            child: Card(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                              elevation: 0,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal:  20.0, vertical:  20.0 * 0.75),
                                child: Row(
                                  children: [
                                    Stack(
                                      children: [
                                        postSnap[index]["VIP"]?ClipRRect(borderRadius:  BorderRadius.circular(25),
                                          child: Container(
                                            width: 46,height: 46,
                                            child: HtmlWidget(
                                              '<img width="46" height="46" src="${postSnap[index]["imageProFile"]}" '
                                                  '/>',
                                              factoryBuilder: () => MyWidgetFactory(),enableCaching: true,
                                            ),
                                          ),
                                        ):CircleAvatar(backgroundImage: AssetImage(img),
                                          child: Text("${postSnap[index]["name"].toString().substring(0,1).toUpperCase()}",
                                            style:
                                            TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
                                        ),
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
                                      width:MediaQuery.of(context).size.width-160 ,
                                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children:  [
                                          Text(
                                           "${postSnap[index]["name"]}",
                                            style:
                                            TextStyle(fontSize: 16, fontWeight: FontWeight.w500),maxLines: 1,
                                          ),
                                          SizedBox(height: 1),
                                          Opacity(
                                            opacity: 0.64,
                                            child: Text(postSnap[index]['status'],
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
                                                  builder: (context) => profile(
                                                    uid:"${postSnap[index]["uID"]}",
                                                      VIP: postSnap[index]["VIP"]
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
                      ],
                    );
                  }),
               )



          ],),
        ),
      ),
    );
  }

}

*/