import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:AliStore/Dashbord/profile.dart';
import 'package:AliStore/alert.dart';
import 'package:AliStore/resources/Localizations_constants.dart';

import '../post/post_card.dart';
import 'home.dart';

bool isShowUsers = false;
bool isUsers = true;
List searchList=[];
class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with TickerProviderStateMixin{

  final TextEditingController searchController = TextEditingController();
  late TabController mc;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  int start=0;


  @override
  Widget build(BuildContext context) {

    mc=TabController(length: 2,initialIndex: start,vsync:this);
  String  Story=getTranslated(context,"Story");
  String  User=getTranslated(context,"User");
  String  SearchUser=getTranslated(context,"SearchUser");

    GlobalKey TabBarKey=new GlobalKey();

    return Scaffold(
      appBar: AppBar(bottom:TabBar(key:TabBarKey ,controller: mc,onTap: (tapIndex){


        setState(() {
          start=tapIndex;
          mc.index=tapIndex;
        });
        switch(tapIndex) {
          case 0:
            setState(() {
             searchList.clear();
              isUsers = true;
            });
          break;
          case 1:
            setState(() {
              searchList.clear();
              isUsers =false;
            });
            break;
          default:
            searchList.clear();
            isUsers?false:true;
            break;
      }
      },tabs: [
        Tab(
          child: Text("$User"),
        ),
        Tab(
          child: Text("$Story"),
        ),
      ]),
     //   backgroundColor: mobileBackgroundColor,
        title: Form(
          child: TextFormField(
            controller: searchController,
            decoration:
                 InputDecoration(labelText: '$SearchUser'),
            onFieldSubmitted: (String index) {

              setState(() {
                if(isUsers){
                  forUser();

                }else{
                  forStory();}
              });

            },
          ),
        ),
      ),
      body:isUsers? forUserNew():SearchForStory(context)


    );
  }
  forUser(){
    searchList.clear();
    isShowUsers = true;
    for(int xd=0;xd<myListInfo.length;xd++){

      if(myListInfo[xd]["name"].contains(searchController.text)){
        searchList.add(myListInfo[xd]);
      }
      else if (myListInfo[xd]["name"].toString().toUpperCase().trim().contains(searchController.text.toString().toUpperCase().trim())
          ||myListInfo[xd]["name"].toString().toLowerCase().trim().contains(searchController.text.toString().toLowerCase().trim())){
        searchList.add(myListInfo[xd]);
      }
      else  if(searchController.text.toString().toLowerCase().trim().startsWith(myListInfo[xd]["name"].toString().toLowerCase().trim())){
        searchList.add(myListInfo[xd]);
      }
      else  if(searchController.text.toString().toLowerCase().trim().endsWith(myListInfo[xd]["name"].toString().toLowerCase().trim())){
        searchList.add(myListInfo[xd]);
      }
      else if(searchController.text.toString().toLowerCase().trim()==(myListInfo[xd]["name"].toString().toLowerCase().trim())){
        searchList.add(myListInfo[xd]);
      }
    }
  }

  forUserNew(){

   return StreamBuilder(
        stream: ( searchController.text!= "" && searchController.text!= null)?FirebaseFirestore.instance.collection("users").where("name",isGreaterThanOrEqualTo: searchController.text).orderBy("name")
        .endAt([searchController.text+'\uf8ff',])
        .snapshots()
        :FirebaseFirestore.instance.collection("users").limit(12).snapshots(),
    builder:(BuildContext context,AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>snapshot) {
      searchList.clear();
    if (snapshot.connectionState == ConnectionState.waiting &&
    snapshot.hasData != true) {
    return Center(
    child:CircularProgressIndicator(),
    );
    }
    else
    {snapshot.data!.docs.forEach((element) {
      searchList.add(element);
    });

      return SearchForUser(context);}
  });}

  SearchForUser(context){
    String NoData =getTranslated(context,"NoData");
   return isShowUsers? searchList.isEmpty? Center(child: Text('${NoData}'))
        : ListView.builder(
      itemCount:searchList.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => profile(
                uid: searchList[index]['uID'],
                VIP: searchList[index]['VIP'],
              ),
            ),
          ),
          child: ListTile(
            leading: searchList[index]['VIP']?CircleAvatar(
              backgroundImage: NetworkImage(
                searchList[index]['imageProFile'],
              ),
              radius: 16,
            ):CircleAvatar(backgroundImage: AssetImage(img),
              child: Text("${searchList[index]['name'].toString().substring(0,1).toUpperCase()}",
                style:
                TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
            ),
            title: Text(
              searchList[index]['name'],
            ),
          ),
        );
      },
    ):Center(child: CircularProgressIndicator());


  }

  SearchForStory(context){
    String NoData =getTranslated(context,"NoData");
    var width =MediaQuery.of(context).size.width;
    return  isShowUsers? searchList.isEmpty? Center(child: Text("$NoData")):
    ListView.builder(addAutomaticKeepAlives: true,addSemanticIndexes: true,
      itemCount: searchList.length,
      itemBuilder: (ctx, index) => Container(
        margin: EdgeInsets.symmetric(
          horizontal: width > 600 ? width * 0.3 : 0,
          vertical: width > 600 ? 15 : 0,
        ),
        child: PostCard(
          snap: searchList[index].data(),
        ),
      ),
    ):Center(child: CircularProgressIndicator());
  }

  forStory(){
    searchList.clear();
    isShowUsers = true;
    for(int xd=0;xd<myListStorys.length;xd++){
      if(myListStorys[xd]["description"].contains(searchController.text)){
        searchList.add(myListStorys[xd]);
      } else if (myListStorys[xd]["description"].toString().toUpperCase().trim().contains(searchController.text.toString().toUpperCase().trim())
          ||myListStorys[xd]["description"].toString().toLowerCase().trim().contains(searchController.text.toString().toLowerCase().trim())){
        searchList.add(myListStorys[xd]);
      }
      else  if(searchController.text.toString().toLowerCase().trim().startsWith(myListStorys[xd]["description"].toString().toLowerCase().trim())){
        searchList.add(myListStorys[xd]);
      }
      else  if(searchController.text.toString().toLowerCase().trim().endsWith(myListStorys[xd]["description"].toString().toLowerCase().trim())){
        searchList.add(myListStorys[xd]);
      }
      else if(searchController.text.toString().toLowerCase().trim()==(myListStorys[xd]["description"].toString().toLowerCase().trim())){
        searchList.add(myListStorys[xd]);
      }
    }

  }

  forStoryNew(){

    return StreamBuilder(
        stream: ( searchController.text!= "" && searchController.text!= null)?FirebaseFirestore.instance.collection("posts").where("text",isGreaterThanOrEqualTo: searchController.text).orderBy("text")
            .endAt([searchController.text+'\uf8ff',])
            .snapshots()
            :FirebaseFirestore.instance.collection("posts").limit(12).snapshots(),
        builder:(BuildContext context,AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>snapshot) {
          searchList.clear();
          if (snapshot.connectionState == ConnectionState.waiting &&
              snapshot.hasData != true) {
            return Center(
              child:CircularProgressIndicator(),
            );
          }
          else
          {snapshot.data!.docs.forEach((element) {
            searchList.add(element);
          });

          return SearchForStory(context);}
        });}
}



