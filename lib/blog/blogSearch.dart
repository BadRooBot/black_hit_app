import 'package:AliStore/blog/blogView.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../resources/Localizations_constants.dart';
class blogSearch extends StatefulWidget {
  const blogSearch({Key? key}) : super(key: key);

  @override
  State<blogSearch> createState() => _blogSearchState();
}

class _blogSearchState extends State<blogSearch> {
  bool isShowUsers = false;
  bool isUsers = true;
  List searchList=[];
  List ImageBlogs=[];
  List DownloadList=[];
  bool IsAddComments=false;

  final TextEditingController searchController = TextEditingController();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  getBolgImage(x){
    ImageBlogs.clear();

    for(int y=0;y<searchList[x]['ImageBlogCount'];y++){
      setState(() {
        ImageBlogs.add(searchList[x]['blogImage$y']);
      });

    }
  }
  getDownloadLink(d){
    DownloadList.clear();
    for(int y=1;y<=searchList[d]['DownloadLinkCount'];y++){
      setState(() {
        DownloadList.add(searchList[d]['DownloadLink$y']);
      });

    }
  }
  setIsAddComments(sx)async{
    var pds=await _firestore.collection('BlogPosts').doc(searchList[sx]['Key']).get();
    setState(() {
      IsAddComments=pds.data()!['AllCommentsIDs'].contains(FirebaseAuth.instance.currentUser!.uid);
    });


  }
  forblog(){
    isShowUsers=true;
    searchList.clear();
    return StreamBuilder(
        stream: ( searchController.text!= "" && searchController.text!= null)?FirebaseFirestore.instance.collection("BlogPosts").where("UserName",isGreaterThanOrEqualTo: searchController.text).orderBy("UserName")
            .endAt([searchController.text+'\uf8ff',])
            .snapshots()
            :FirebaseFirestore.instance.collection("BlogPosts").limit(12).snapshots(),
        builder:(BuildContext context,AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>snapshot) {

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

          return viewForblog(context);}
        });}

  viewForblog(context){
    String NoData =getTranslated(context,"NoData");
    return isShowUsers? searchList.isEmpty? Center(child: Text('${NoData}'))
        : ListView.builder(
      itemCount:searchList.length,
      itemBuilder: (context, i) {
        getBolgImage(i);
        getDownloadLink(i);
        setIsAddComments(i);
        return InkWell(
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => blogView(title:searchList[i]["title"],blogBio: searchList[i]["bio"], blogKey:  searchList[i]["Key"], VIP:  searchList[i]["VIP"], UserName:  searchList[i]["UserName"], UserImage:  searchList[i]["UserImage"]
                  ,blogImages: ImageBlogs,blogDownloadLink: DownloadList,IsAddComments: IsAddComments,blogImagesCount: searchList[i] ['ImageBlogCount']),

            ),
          ),
          child: ListTile(
            leading: searchList[i]['VIP']?CircleAvatar(
              backgroundImage: NetworkImage(
                searchList[i]['UserImage'],
              ),
              radius: 16,
            ):CircleAvatar(backgroundImage: AssetImage(img),
              child: Text("${searchList[i]['UserName'].toString().substring(0,1).toUpperCase()}",
                style:
                TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
            ),
            title: Column(
              children: [
                Text(searchList[i]['title'],),
                Opacity(
                  opacity: 0.60,
                  child: Text(
                    "By: ${searchList[i]["UserName"]}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ):Center(child: CircularProgressIndicator());


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(leading:  InkWell(onTap: (){ Navigator.of(context).pushNamed('blogpage');},child: Icon(Icons.arrow_back_ios)),
          //   backgroundColor: mobileBackgroundColor,
          title: Form(
            child: TextFormField(
              controller: searchController,
              decoration:
              InputDecoration(labelText: 'Search'),
              onFieldSubmitted: (String index) {
                setState(() {
                  forblog();
                });
              },
            ),
          ),
        ),
        body:viewForblog(context)
    );
  }
}
