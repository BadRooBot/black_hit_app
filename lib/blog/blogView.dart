
import 'package:AliStore/Dashbord/home.dart';
import 'package:AliStore/post/comment_card.dart';
import 'package:AliStore/resources/Localizations_constants.dart';
import 'package:AliStore/resources/firestore_methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../resources/MyWidgetFactory.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

import '../resources/realtime_database_methods.dart';

class blogView extends StatefulWidget {
  final title;
  final blogBio;
  final blogKey;
  final VIP;
  final UserName;
  final UserImage;
  final blogImagesCount;
  final List blogImages;
  final List blogDownloadLink;
  final bool IsAddComments;
  const blogView({Key? key,required this.title,required this.blogBio,required this.blogKey,required this.VIP,required this.UserName,required this.UserImage,required this.blogImages,required this.blogDownloadLink,required this.IsAddComments,required this.blogImagesCount}) : super(key: key);

  @override
  State<blogView> createState() => _blogViewState();
}
String img='assets/back.jpg';
var Download,Sorrythelinkcantbeshownuntilafterreplyingtothetopic,AddCommentss,Comment,OK,Cancel;

int RadioVal2=0;
late PageController _pageController2;
FirebaseFirestore _firestore = FirebaseFirestore.instance;
final TextEditingController commentEditingController =
TextEditingController();
List newListComments = [];
List defList=['badRooBot1548782'];
bool IsEndLoad=false;
bool IsAddComment=false;
int CommentCount=0;
int CommentLength=0;
class _blogViewState extends State<blogView> {
  final _ScrollController=ScrollController();
  int finalCommentCount=0;
  void postComment(String uid, String name, String profilePic,bool VIP) async {
    try {
      String res = await FireStoreMethods().postBlogComment(
          widget.blogKey,
          commentEditingController.text,
          uid,
          name,
          profilePic,VIP,finalCommentCount
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


  postCommentToBlog(String uid, String name, String profilePic,bool VIP)async{

    try {
     var res= await realtimeDb().AddCommentToBlog(BlogId: widget.blogKey,
          CommentText: commentEditingController.text,
          IsVIP: VIP,
          MyId: uid,
          Name: name,
          ProfileImage: profilePic,
          FinalCommentCount: finalCommentCount,
         AllCommentLength:CommentLength+1 ,IsAddComments: IsAddComment);
     if (res != 'Done') {
       showSnackBar(context, res);
     }
     setState(() {
       commentEditingController.text = "";
     });
    }catch(e){
      showSnackBar(
        context,
        e.toString(),
      );
    }
  }
  getAllComment(bool first)async{
    newListComments.clear();
   /* var ComData=await _firestore.collection('BlogPosts').doc(widget.blogKey).collection('comments').limit(10).get();
     ComData.docs.forEach((element) {
       setState(() {
         newListComments.add(element.data());
       });
     });*/
    var Com=await realtimeDb().GetCommentToBlog(BlogId:widget.blogKey ,Limit: 10);
    setState(() {
      newListComments=Com;
    });
     if(first) {
       UpdataUserInfo();
     }
  }
  UpdataUserInfo()async{
    //   ListlastChat.clear();
    for(int num=0;num<=newListComments.length-1;num++){
      try{

        List dataForOneUser= await realtimeDb().GetOneUserData(Id:  newListComments[num]['uid']);
        var nAndI = await _firestore.collection('users')
            .where('uID',
            isEqualTo: newListComments[num]['uid'])
            .get();
        dataForOneUser.forEach((element) async {
       /*   DocumentReference myStore = FirebaseFirestore
              .instance.collection('BlogPosts')
              .doc(widget.blogKey)
              .collection('comments').doc(newListComments[num]['commentId']);*/

          if (newListComments[num]['uid'] ==
              element['uID']) {
            if (newListComments[num]['name'] !=
                element['name']) {

              await realtimeDb().UpdateOneCommentToBlog(BlogId: widget.blogKey, CommentId: newListComments[num]['commentId'], Name:  element['name']
                  , ProfileImage: element['imageProFile'], IsVIP: element['VIP'], WhatThisUpdate: 0);

            }
            if (newListComments[num]['profilePic'] !=
                element['imageProFile']) {
              await realtimeDb().UpdateOneCommentToBlog(BlogId: widget.blogKey, CommentId: newListComments[num]['commentId'], Name:  element['name']
                  , ProfileImage: element['imageProFile'], IsVIP: element['VIP'], WhatThisUpdate: 1);

            }
            if (newListComments[num]['VIP'] !=
                element.data()['VIP']) {
              await realtimeDb().UpdateOneCommentToBlog(BlogId: widget.blogKey, CommentId: newListComments[num]['commentId'], Name:  element['name']
                  , ProfileImage: element['imageProFile'], IsVIP: element['VIP'], WhatThisUpdate: 2);
            }

          }
        });



      }catch(d){ print('++++++++++++++++Enter Error  $d');}

    }
    newListComments.clear();
    //  getAllComment();
  }
  setCommentCount()async{
    IsAddComment=widget.IsAddComments;
    CommentCount= await realtimeDb().GetBlogsCommentCount(BlogId: widget.blogKey,NeedCommentlength:false );
    finalCommentCount=CommentCount;
    CommentLength=await realtimeDb().GetBlogsCommentCount(BlogId: widget.blogKey,NeedCommentlength:true );
/*    var pds=await _firestore.collection('BlogPosts').doc(widget.blogKey).get();
    setState(() {
      IsAddComment=pds.data()!['AllCommentsIDs'].contains(FirebaseAuth.instance.currentUser!.uid);
      CommentCount=pds.data()!['AllCommentsIDs'].length;
      finalCommentCount=pds.data()!['finalCommentCount']+1;
    });*/



  }
  void onPageChanged(int page) {
    setState(() {
      RadioVal2 = page;

    });
  }
  void _launchUrl(Link) async {

    Uri _url = Uri.parse('$Link');
    if (!await launchUrl(_url)) throw 'Could not launch $_url';
  }
  getTr(context){
    Download=getTranslated(context,"Download");
    Sorrythelinkcantbeshownuntilafterreplyingtothetopic=getTranslated(context,"Sorrythelinkcantbeshownuntilafterreplyingtothetopic");
    AddCommentss=getTranslated(context,"AddComments");
    Comment=getTranslated(context,"Comment");
    OK=getTranslated(context,"OK");
    Cancel=getTranslated(context,"Cancel");


  }
  @override
  void initState() {
    _pageController2=new PageController(initialPage: 0,viewportFraction: 1.0,keepPage: false);
    newListComments.clear();
     RadioVal2=0;
    getAllComment(true);
    setCommentCount();

    IsEndLoad=true;
    IsAddComment=widget.IsAddComments;
    _ScrollController.addListener(() {
      if(_ScrollController.offset>=_ScrollController.position.maxScrollExtent){

      }
    });
    super.initState();
  }


  getAllInkWell(int Count,bool PageChanged){
    if(PageChanged){
      setState(() {
        RadioVal2=0;

      });
    }
    Color? clr1=Colors.blue;
    Color? clr2=Theme.of(context).appBarTheme.backgroundColor;
    return Row(mainAxisAlignment: MainAxisAlignment.spaceAround,crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Visibility(visible: Count>=0,
          child: InkWell(child: RadioVal2==0?Icon(Icons.adjust_outlined,color: clr1,size: 17,):Icon(Icons.circle_outlined,color:clr2,size: 17),onTap: (){
            setState(() {
              RadioVal2=0;
              _pageController2.animateToPage(RadioVal2, duration: Duration(milliseconds: 350), curve: Curves.decelerate);
            });
          },splashColor: Colors.blue,),
        ),
        Visibility(visible: Count>=1,
          child: InkWell(child: RadioVal2==1?Icon(Icons.adjust_outlined,color: clr1,size: 17,):Icon(Icons.circle_outlined,color:clr2,size: 17),onTap: (){
            setState(() {
              RadioVal2=1;
              _pageController2.animateToPage(RadioVal2, duration: Duration(milliseconds: 350), curve: Curves.decelerate);
            });
          },splashColor: Colors.blue,),
        ),
        Visibility(visible: Count>=2,
          child: InkWell(child:RadioVal2==2?Icon(Icons.adjust_outlined,color: clr1,size: 17,):Icon(Icons.circle_outlined,color:clr2,size: 17),onTap: (){
            setState(() {
              RadioVal2=2;
              _pageController2.animateToPage(RadioVal2, duration: Duration(milliseconds: 350), curve: Curves.decelerate);
            });
          },splashColor: Colors.blue,),
        ),
        Visibility(visible: Count>=3,
          child: InkWell(child: RadioVal2==3?Icon(Icons.adjust_outlined,color:clr1,size: 17,):Icon(Icons.circle_outlined,color:clr2,size: 17),onTap: (){
            setState(() {
              RadioVal2=3;
              _pageController2.animateToPage(RadioVal2, duration: Duration(milliseconds: 350), curve: Curves.decelerate);
            });
          },splashColor: Colors.blue,),
        ),     Visibility(visible: Count>=4,
          child: InkWell(child:RadioVal2==4?Icon(Icons.adjust_outlined,color:clr1,size: 17,):Icon(Icons.circle_outlined,color:clr2,size: 17),onTap: (){
            setState(() {
              RadioVal2=4;
              _pageController2.animateToPage(RadioVal2, duration: Duration(milliseconds: 350), curve: Curves.decelerate);
            });
          },splashColor: Colors.blue,),
        ),     Visibility(visible: Count>=5,
          child: InkWell(child: RadioVal2==5?Icon(Icons.adjust_outlined,color:clr1,size: 17,):Icon(Icons.circle_outlined,color:clr2,size: 17),onTap: (){
            setState(() {
              RadioVal2=5;
              _pageController2.animateToPage(RadioVal2, duration: Duration(milliseconds: 350), curve: Curves.decelerate);
            });
          },splashColor: Colors.blue,),
        ),     Visibility(visible: Count>=6,
          child: InkWell(child: RadioVal2==6?Icon(Icons.adjust_outlined,color:clr1,size: 17,):Icon(Icons.circle_outlined,color:clr2,size: 17),onTap: (){
            setState(() {
              RadioVal2=6;
              _pageController2.animateToPage(RadioVal2, duration: Duration(milliseconds: 350), curve: Curves.decelerate);
            });
          },splashColor: Colors.blue,),
        ),     Visibility(visible: Count>=7,
          child: InkWell(child: RadioVal2==7?Icon(Icons.adjust_outlined,color: clr1,size: 17,):Icon(Icons.circle_outlined,color:clr2,size: 17),onTap: (){
            setState(() {
              RadioVal2=7;
              _pageController2.animateToPage(RadioVal2, duration: Duration(milliseconds: 350), curve: Curves.decelerate);
            });
          },splashColor: Colors.blue,),
        ),     Visibility(visible: Count>=8,
          child: InkWell(child: RadioVal2==8?Icon(Icons.adjust_outlined,color: clr1,size: 17,):Icon(Icons.circle_outlined,color:clr2,size: 17),onTap: (){
            setState(() {
              RadioVal2=8;
              _pageController2.animateToPage(RadioVal2, duration: Duration(milliseconds: 350), curve: Curves.decelerate);
            });
          },splashColor: Colors.blue,),
        ),     Visibility(visible: Count>=9,
          child: InkWell(child: RadioVal2==9?Icon(Icons.adjust_outlined,color: clr1,size: 17,):Icon(Icons.circle_outlined,color:clr2,size: 17),onTap: (){
            setState(() {
              RadioVal2=9;
              _pageController2.animateToPage(RadioVal2, duration: Duration(milliseconds: 350), curve: Curves.decelerate);
            });
          },splashColor: Colors.blue,),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    //getTr(context);
    OK=getTranslated(context,"OK");
    Download=getTranslated(context,"Download");
    Sorrythelinkcantbeshownuntilafterreplyingtothetopic=getTranslated(context,"Sorrythelinkcantbeshownuntilafterreplyingtothetopic");
    AddCommentss=getTranslated(context,"AddComment");
  //  Cancel=getTranslated(context,"Cancel");

    return Scaffold(appBar: AppBar(title: Row(
      children: [
      Container(width: 48,height: 48,padding: EdgeInsets.all(8),
      child:widget.VIP? CircleAvatar(
        backgroundImage: NetworkImage(widget.UserImage),
        radius: 18,
      ):
      CircleAvatar(backgroundImage: AssetImage(img),
        child: Text("${widget.UserName.toString().substring(0,1).toUpperCase()}",
          style:
          TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
      ),
    ),
        Text(widget.UserName.toString()),
      ],
    ),leading: InkWell(onTap: (){ Navigator.of(context).pushNamed('blogpage');},child: Icon(Icons.arrow_back_ios))
    ,),
        body: ListView(controller: _ScrollController,
          children: [
        Stack(alignment: Alignment.bottomCenter,children: [
          Container(width: MediaQuery.of(context).size.width,height: MediaQuery.of(context).size.height*.60,child: getAllItmeImage(widget.blogImagesCount, context)),
          Positioned(child:getAllInkWell(widget.blogImagesCount,false),bottom:10)]),
          Container(margin: EdgeInsets.symmetric(vertical: 10,horizontal: 10),child: Text('${widget.title}'),),
          Divider(color: Colors.blueGrey,),
          Container(margin: EdgeInsets.symmetric(vertical: 10,horizontal: 10),child: SelectableText('${widget.blogBio}'),),
          Divider(),
            Visibility(visible: widget.blogDownloadLink.length>=1 ,
            child: Container(margin: EdgeInsets.symmetric(vertical: 10,horizontal: 10),child: Row(
              children: [
                Text('$Download:  '),
                IsAddComment? Flexible(
                  child: SelectableText('${widget.blogDownloadLink[0]}',style: TextStyle(color: Colors.blue),onTap: (){
                    _launchUrl(widget.blogDownloadLink[0]);
                  },),
                ):Text('$Sorrythelinkcantbeshownuntilafterreplyingtothetopic'),
              ],
            ),),
          ),
            Visibility(visible: widget.blogDownloadLink.length>=2 ,
            child: Container(margin: EdgeInsets.symmetric(vertical: 10,horizontal: 10),child: IsAddComment? Flexible(
              child: SelectableText('${widget.blogDownloadLink.length>=2?widget.blogDownloadLink[1]:''}',style: TextStyle(color: Colors.blue),onTap: (){
                _launchUrl(widget.blogDownloadLink[1]);
              },),
            ):Text('$Sorrythelinkcantbeshownuntilafterreplyingtothetopic'),),
          ),
            Visibility(visible: widget.blogDownloadLink.length>=3 ,
              child: Container(margin: EdgeInsets.symmetric(vertical: 10,horizontal: 10),child: IsAddComment? Flexible(
                child: SelectableText('${widget.blogDownloadLink.length>=3?widget.blogDownloadLink[2]:''}',style: TextStyle(color: Colors.blue),onTap: (){
                  _launchUrl(widget.blogDownloadLink[2]);
                },),
              ):Text('$Sorrythelinkcantbeshownuntilafterreplyingtothetopic'),),
            ),
            Visibility(visible: widget.blogDownloadLink.length>=4 ,
              child: Container(margin: EdgeInsets.symmetric(vertical: 10,horizontal: 10),child: IsAddComment? Flexible(
                child: SelectableText('${widget.blogDownloadLink.length>=4?widget.blogDownloadLink[3]:''}',style: TextStyle(color: Colors.blue),onTap: (){
                  _launchUrl(widget.blogDownloadLink[3]);
                },),
              ):Text('$Sorrythelinkcantbeshownuntilafterreplyingtothetopic'),),
            ),
            Visibility(visible: widget.blogDownloadLink.length>=5 ,
              child: Container(margin: EdgeInsets.symmetric(vertical: 10,horizontal: 10),child: IsAddComment? Flexible(
                child: SelectableText('${widget.blogDownloadLink.length>=5?widget.blogDownloadLink[4]:''}',style: TextStyle(color: Colors.blue),onTap: (){
                  _launchUrl(widget.blogDownloadLink[4]);
                },),
              ):Text('$Sorrythelinkcantbeshownuntilafterreplyingtothetopic'),),
            ),
            Visibility(visible: widget.blogDownloadLink.length>=6 ,
              child: Container(margin: EdgeInsets.symmetric(vertical: 10,horizontal: 10),child: IsAddComment? Flexible(
                child: SelectableText('${widget.blogDownloadLink.length>=6?widget.blogDownloadLink[5]:''}',style: TextStyle(color: Colors.blue),onTap: (){
                  _launchUrl(widget.blogDownloadLink[5]);
                },),
              ):Text('$Sorrythelinkcantbeshownuntilafterreplyingtothetopic'),),
            ),
            Visibility(visible: widget.blogDownloadLink.length>=7,
              child: Container(margin: EdgeInsets.symmetric(vertical: 10,horizontal: 10),child: IsAddComment?Flexible(
                child: SelectableText('${widget.blogDownloadLink.length>=7?widget.blogDownloadLink[6]:''}',style: TextStyle(color: Colors.blue),onTap: (){
                  _launchUrl(widget.blogDownloadLink[6]);
                },),
              ):Text('$Sorrythelinkcantbeshownuntilafterreplyingtothetopic'),),
            ),
            Visibility(visible: widget.blogDownloadLink.length>=8 ,
              child: Container(margin: EdgeInsets.symmetric(vertical: 10,horizontal: 10),child: IsAddComment?Flexible(
                child: SelectableText('${widget.blogDownloadLink.length>=8?widget.blogDownloadLink[7]:''}',style: TextStyle(color: Colors.blue),onTap: (){
                  _launchUrl(widget.blogDownloadLink[7]);
                },),
              ):Text('$Sorrythelinkcantbeshownuntilafterreplyingtothetopic'),),
            ),
            Visibility(visible: widget.blogDownloadLink.length>=9 ,
              child: Container(margin: EdgeInsets.symmetric(vertical: 10,horizontal: 10),child: IsAddComment?Flexible(
                child: SelectableText('${widget.blogDownloadLink.length>=9?widget.blogDownloadLink[8]:''}',style: TextStyle(color: Colors.blue),onTap: (){
                  _launchUrl(widget.blogDownloadLink[8]);
                },),
              ):Text('$Sorrythelinkcantbeshownuntilafterreplyingtothetopic'),),
            ),
            Visibility(visible: widget.blogDownloadLink.length>=10 ,
              child: Container(margin: EdgeInsets.symmetric(vertical: 10,horizontal: 10),child: IsAddComment?Flexible(
                child: SelectableText('${widget.blogDownloadLink.length>=10?widget.blogDownloadLink[9]:''}',style: TextStyle(color: Colors.blue),onTap: (){
                  _launchUrl(widget.blogDownloadLink[9]);
                },),
              ):Text('$Sorrythelinkcantbeshownuntilafterreplyingtothetopic'),),
            ),
            Visibility(visible: widget.blogDownloadLink.length>=11 ,
              child: Container(margin: EdgeInsets.symmetric(vertical: 10,horizontal: 10),child: IsAddComment?Flexible(
                child: SelectableText('${widget.blogDownloadLink.length>=11?widget.blogDownloadLink[10]:''}',style: TextStyle(color: Colors.blue),onTap: (){
                  _launchUrl(widget.blogDownloadLink[10]);
                },),
              ):Text('$Sorrythelinkcantbeshownuntilafterreplyingtothetopic'),),
            ),

          ElevatedButton(onPressed: (){
            AddComment(context);}, child: Text('$AddCommentss')),
          Divider(height: 1.5),
          ListView.builder(itemCount:newListComments.length ,shrinkWrap: true,itemBuilder: (context,index){
            return IsEndLoad? CommentCard( snap:newListComments[index],postId:widget.blogKey,
            IsCommentBlog: true,):Center(child:  LinearProgressIndicator());
          })


        ],),
    );
  }
  AddComment(context){
    return showDialog(
        context: context,
        builder: (BuildContext context) {

          OK=getTranslated(context,"OK");
          Cancel=getTranslated(context,"Cancel");
          Comment=getTranslated(context,"Comment");

          return SimpleDialog(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      children: <Widget>[
        SimpleDialogOption(
            padding: const EdgeInsets.all(20),
            child:  TextField(
              controller: commentEditingController,
              decoration: InputDecoration(
                hintText: '$Comment',
                border: InputBorder.none,
              ),
            ),
            onPressed: () async {

            }),
        SimpleDialogOption(
            padding: const EdgeInsets.all(20),
            child: Text('$OK'),
            onPressed: () async {
              postCommentToBlog(FirebaseAuth.instance.currentUser!.uid,UserInfoList[0]["name"],UserInfoList[0]["imageProFile"],UserInfoList[0]["VIP"]);
             /* await _firestore.collection('BlogPosts').doc(widget.blogKey).set({
                'AllCommentsIDs': FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid])
              },SetOptions(merge: true));
              await  _firestore.collection('BlogPosts').doc(widget.blogKey).set({'finalCommentCount':finalCommentCount},SetOptions(merge: true));
              */
              newListComments.clear();
              setState(() {
                IsAddComment=true;
              });
              getAllComment(false);
             // setCommentCount();
              Navigator.pop(context);

            }),
        SimpleDialogOption(
          padding: const EdgeInsets.all(20),
          child: Text("$Cancel"),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],

    );});

  }

  getAllItmeImage(int Count,context){


    return
      PageView.builder(itemBuilder:  (context, index){
        return ClipRRect(borderRadius:  BorderRadius.circular(0),
          child: HtmlWidget(
            '<img width="${ MediaQuery.of(context).size.width}" height="${ MediaQuery.of(context).size.height*.60}" src="${widget.blogImages[index]}" '
                '/>',
            factoryBuilder: () => MyWidgetFactory(),enableCaching: true,
          ),
        );

      },itemCount: Count,controller:_pageController2, onPageChanged: onPageChanged,);
  }



}



