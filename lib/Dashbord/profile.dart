/*import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'as image;
import 'package:AliStore/Dashbord/home.dart';
import 'package:AliStore/Dashbord/messageAcitvity.dart';
import 'package:AliStore/alert.dart';
import 'package:AliStore/constants.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:AliStore/post/follow_button.dart';
import 'package:AliStore/profile_widget.dart';
import 'package:AliStore/resources/Localizations_constants.dart';
import 'package:AliStore/resources/MyWidgetFactory.dart';
import 'package:AliStore/resources/firestore_methods.dart';
import 'package:AliStore/resources/storage_methods.dart';

class profile extends StatefulWidget {
  final uid,VIP;
  const profile( {Key? key,required this.uid,required this.VIP}) : super(key: key);

  @override
  _profileState createState() => _profileState();
}
Uint8List? _file;

class _profileState extends State<profile> {

  _selectImage(BuildContext parentContext) async {
    String  Takeaphoto=getTranslated(context,"Takeaphoto");
    String  ChoosefromGallery=getTranslated(context,"ChoosefromGallery");
    String  Cancel=getTranslated(context,"Cancel");
    String  changeprofilepicture=getTranslated(context,"changeprofilepicture");

    return showDialog(
      context: parentContext,
      builder: (BuildContext context) {
        return SimpleDialog(
          title:  Text('$changeprofilepicture'),
          children: <Widget>[
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child:  Text('$Takeaphoto'),
                onPressed: () async {
                //  Navigator.pop(context);
                  var file = await pickImage(image.ImageSource.camera);


                  editProfileImage(context,file);

                }),
            SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child:  Text('$ChoosefromGallery'),
                onPressed: () async {
                 // Navigator.of(context).pop();
                  var file = await pickImage(image.ImageSource.gallery);

                    editProfileImage(context,file);

                }),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child:  Text("$Cancel"),
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
  String Name='';
  String Status='';
  String ImageUri='';
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;
  bool isMe=false;

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      //userData.clear();
        isMe=widget.uid==FirebaseAuth.instance.currentUser!.uid?true:false;
    /*    var userSnap = await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.uid)
            .get();
*/

        var _val=await realtimeDb().GetOneUserData(Id: widget.uid);



        var userSnap;
        setState(() {
          userSnap  =_val;
        });
        // get post lENGTH
        var postSnap = await FirebaseFirestore.instance
            .collection('posts')
            .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .get();

        postLen = postSnap.docs.length;
        userData = userSnap[0];
        Name=userData["name"];
        ImageUri=userData["imageProFile"];
        Status=userData["status"];
      /*  followers = userSnap['followers'].length;
        following = userSnap['following'].length;*/

      followers=await realtimeDb().GetFollowers(Id: widget.uid??FirebaseAuth.instance.currentUser!.uid,NeedfollowersCount: true)??0;
        following=await realtimeDb().GetFollowing(Id: widget.uid??FirebaseAuth.instance.currentUser!.uid, NeedfollowingCount: true)??0;
        isFollowing=await realtimeDb().GetFollowers(Id: widget.uid??FirebaseAuth.instance.currentUser!.uid,NeedfollowersCount: false)??false;
    } catch (e) {
      print('=========================Eror $e');
      showSnackBar(
        context,
        e.toString(),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    String ProfileBackImage='https://img-prod-cms-rt-microsoft-com.akamaized.net/cms/api/am/imageFileData/RE4wyTI?ver=c51c';
    String  Message=getTranslated(context,"Message");
    String  _following=getTranslated(context,"following");
    String  _followers=getTranslated(context,"followers");
    String  Unfollow=getTranslated(context,"Unfollow");
    String  Follow=getTranslated(context,"Follow");
    return Scaffold(
      body: Card(
        child:
        isLoading?LinearProgressIndicator():ListView(
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                //https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTxJHXx_a_l5mZ904vvYhc1DeV437G8abScIw&usqp=CAU
                HtmlWidget(
                  '<img width="${MediaQuery.of(context).size.width}" height="${MediaQuery.of(context).size.width>=600?MediaQuery.of(context).size.height / 2:MediaQuery.of(context).size.height / 3}" src="$ProfileBackImage" '
                      '/>',
                  factoryBuilder: () => MyWidgetFactory(),enableCaching: true,
                ),

                Positioned(
                  bottom: -45,
                  child: ProfileWidget(VIP: widget.VIP,name: Name,
                    isEdit:isMe,
                    imagePath:
                    "${ImageUri}",
                    onClicked: () {
                      if(widget.VIP&&widget.uid==FirebaseAuth.instance.currentUser!.uid){
                      _selectImage(context);
                      }
                    },
                  ),

                ),
              ],

            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [buildStatColumn(followers, "$_followers"), buildStatColumn(following, "$_following"),],),
            SizedBox(height: 70),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  child:  Text(
                    "${Name}",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),Visibility(visible: isMe,child: InkWell(onTap: (){editName(context);},child: Icon(Icons.edit),))
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 20),
                  alignment: Alignment.center,
                  child:  Text(
                    "$Status",
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),Visibility(visible: isMe,child: InkWell(onTap: (){editStatus(context);},child: Icon(Icons.edit),))
              ],
            ), Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceEvenly,
              children: [
                isFollowing
                    ? FollowButton(
                  text: '$Unfollow',
                  backgroundColor: Colors.white,
                  textColor: Colors.black,
                  splashColor: Colors.teal,
                  function: () async {/*
                    await FireStoreMethods()
                        .followUser(
                      FirebaseAuth.instance
                          .currentUser!.uid,
                      userData['uID'],
                    );*/

                    await  realtimeDb().AddFollows(Id: widget.uid, followers: true);
                    await  realtimeDb().AddFollowing(Id: widget.uid, followers: true);

                    setState(() {
                      isFollowing = false;
                      followers--;
                    });
                  },
                )
                    : FollowButton(
                  text: '$Follow',
                  backgroundColor: Colors.indigo,
                  textColor: Colors.white,
                  splashColor: Colors.blue,
                  function: () async {
                 /*   await FireStoreMethods()
                        .followUser(
                      FirebaseAuth.instance
                          .currentUser!.uid,
                      userData['uID'],
                    );*/
                    try {
                      var realDb = new realtimeDb();
                      await  realtimeDb().AddFollows(Id: widget.uid, followers: false);
                      await  realtimeDb().AddFollowing(Id: widget.uid, followers: false);

                    }catch(e){print('========================================$e');}
                    setState(() {
                      isFollowing = true;
                      followers++;
                    });
                  },
                )
              ],
            ),SizedBox(height: 5,),
            Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceEvenly,
              children: [
                FollowButton(
                  text: '$Message',
                  backgroundColor: Colors.indigo,
                  textColor: Colors.white,
                  splashColor: Colors.blue,
                  function: () async {
                    Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => message(
                            VIP:userData["VIP"],
                            Name:"${userData["name"]}",
                            Image: "${userData["imageProFile"]}",
                            Uid: "${userData['uID']}",isGroup: false,
                          ),
                        ));
                  },
                ),
              ],
            ),
            FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('posts')
                  .where('uid', isEqualTo: widget.uid)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return Card(
                  child: GridView.builder( padding: EdgeInsets.only(left: 12,right: 12,bottom: 0,top: 5),
                    shrinkWrap: true,
                    itemCount: (snapshot.data! as dynamic).docs.length,
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,

                      crossAxisSpacing: 2
                    ),
                    itemBuilder: (context, index) {
                      DocumentSnapshot snap =
                      (snapshot.data! as dynamic).docs[index];

                      return
                        Container(
                          child:HtmlWidget(
                            '<img width="${MediaQuery.of(context).size.width/3}" height="${MediaQuery.of(context).size.height/4}" src="${snap['postUrl']}" '
                                '/>',
                            factoryBuilder: () => MyWidgetFactory(),enableCaching: true,
                          ));
                    },
                  ),
                );
              },
            )

          ],
        ),
      ),

    );
  }
  editName(context)async{
    var editDb=realtimeDb();
    final TextEditingController _usernameController = TextEditingController();
    String Typeyourname = getTranslated(context,'Type-your-name');
    String Done = getTranslated(context,'Done');
    return showDialog(
        context: context,
        builder: (context) {
          return Container(
              alignment: Alignment.center,
              margin:EdgeInsets.symmetric(horizontal: 40) ,
              child:  Card(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                shadowColor: Colors.grey,
                child: Container(
                  height: 120,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment:MainAxisAlignment.center,children: [
                    TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        hintText: '$Typeyourname',
                        border: InputBorder.none,
                      ),
                    ),SizedBox(width: 25,),ElevatedButton(onPressed: () async{
                /*  await    FirebaseFirestore.instance.collection("users").doc("${FirebaseAuth.instance.currentUser!.uid}").update({"name":_usernameController.text});
*/
                      await editDb.EditNameAndStatus(NewName: _usernameController.text, NewStatus: 'NewStatus', NameOrStatus: true);
                      setState(() {
                        Name=_usernameController.text;
                        UserInfoList[0]["name"]=_usernameController.text;
                        Navigator.pop(context);
                      });

                      Navigator.of(context).pop;

                    }, child: Text("$Done"))
                  ],),
                ),
              ));
        });
  }
  editStatus(context)async{
    String Done = getTranslated(context,'Done');
    String TypeStatus = getTranslated(context,'Type-your-Status');
    final TextEditingController _bioController = TextEditingController();
    var editStatusDb=realtimeDb();
    return showDialog(
        context: context,
        builder: (context) {
          return Container(
              alignment: Alignment.center,
              margin:EdgeInsets.symmetric(horizontal: 40) ,
              child:  Card(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                shadowColor: Colors.grey,
                child: Container(
                  height: 120,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment:MainAxisAlignment.center,children: [
                    TextField(
                      controller: _bioController,
                      decoration: InputDecoration(
                        hintText: '$TypeStatus',

                        border: InputBorder.none,
                      ),
                    ),SizedBox(width: 25,),ElevatedButton(onPressed: ()async{

                   /* await  FirebaseFirestore.instance.collection("users").doc("${FirebaseAuth.instance.currentUser!.uid}").
                      update({"status":_bioController.text});*/

                      await editStatusDb.EditNameAndStatus(NewName:'bad RooBot', NewStatus: _bioController.text, NameOrStatus: false);
                      setState(() {
                        UserInfoList[0]["status"]=_bioController.text;
                        Status=_bioController.text;
                      });
                    Navigator.pop(context);
                    }, child: Text("$Done"))
                  ],),
                ),
              ));
        });
  }
  editProfileImage(context,Filess)async{
    String loading = getTranslated(context,'loading');
    showLoading(context,"$loading",true);
    var ImUrl=await StorageMethods().uploadImageGroupToStorage("ImageProfile", Filess, "${FirebaseAuth.instance.currentUser!.uid}");
   /* await  FirebaseFirestore.instance.collection("users").doc("${FirebaseAuth.instance.currentUser!.uid}").
    update({"imageProFile":ImUrl});*/
    var EdImage=realtimeDb();
    EdImage.EditImage(NewImage:ImUrl );
    setState(() {
      ImageUri=ImUrl;
    });
    Navigator.pop(context);
    Navigator.pop(context);


  }
}
Column buildStatColumn(int num, String label) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        num.toString(),
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      Container(
        margin: const EdgeInsets.only(top: 4),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w400,
            color: Colors.grey,
          ),
        ),
      ),
    ],
  );
}




*/