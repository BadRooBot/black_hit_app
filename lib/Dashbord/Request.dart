import 'package:unity_ads_plugin/unity_ads_plugin.dart';
import 'package:AliStore/Ads/AdManager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:AliStore/Dashbord/profile.dart';
import 'package:AliStore/alert.dart';
import 'package:AliStore/resources/Localizations_constants.dart';
import '../resources/realtime_database_methods.dart';


var YourNames=" ";
var YourImageeee=" ";
List myListInfoForRequst=[];
List myListInfoForGroup=[];
CollectionReference GruopInfo =
FirebaseFirestore.instance.collection("Group");
class Request extends StatefulWidget {
  const Request({Key? key}) : super(key: key);

  @override
  _RequestState createState() => _RequestState();
}

class _RequestState extends State<Request> {
  getAllUserInfo(Id) async {
   for(int g=0;g<Id.length;g++) {
     var inofGgroup = await GruopInfo.where(
         'GroupId', isEqualTo: Id[g]['GroupId']).get();
     inofGgroup.docs.forEach((element) {

         myListInfoForGroup.add(element.data());

     });
   }
  }

  @override
  Widget build(BuildContext context) {
    String  Request=getTranslated(context,"Request");
    return Scaffold(
      appBar: AppBar(title: Text("$Request"),),
      body: ListView(children: [ Center(
        child: UnityBannerAd(
            placementId: AdManager.bannerAdPlacementId),
      ),AllRequest(context)],),

    );
  }
  AllRequest(context){
    String  needjone=getTranslated(context,"needjone");
    String  NoRequest=getTranslated(context,"NoRequest");
    String  Group=getTranslated(context,"Group");
    return Container(
      margin: EdgeInsets.only(top: 8),
      child:
      StreamBuilder(stream: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection("request").snapshots()
        ,builder: (context,AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot){
          if (snapshot.connectionState == ConnectionState.waiting&&!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          getAllUserInfo(snapshot.data!.docs);
          AllDatat() async{
            for(int x=0;x<snapshot.data!.docs.length;x++){
              var getD=await realtimeDb().GetOneUserData(Id: snapshot.data!.docs[x]['uId']);
              setState(() {
                 myListInfoForRequst+=getD;
              });
            }
          }
          if(snapshot.connectionState != ConnectionState.waiting){
            AllDatat();
          }


          allRequestName(index){

            if(myListInfoForRequst.isNotEmpty) {
              for (int xx = 0; xx < myListInfoForRequst.length; xx++) {
                if (myListInfoForRequst[xx]["uID"] == snapshot.data!.docs[index]["uId"]) {
                  return YourNames = myListInfoForRequst[xx]["name"];
                }

              }
            }else return YourNames;
          }
          allRequestNameGroup(index){

            if(myListInfoForGroup.isNotEmpty) {
              for (int xx = 0; xx < myListInfoForGroup.length; xx++) {
                if (myListInfoForGroup[xx]["GroupId"] == snapshot.data!.docs[index]["GroupId"]) {
                  return YourNames = myListInfoForGroup[xx]["name"];
                }
              }
            }else return YourNames;
          }
          allRequestImage(index){

            if(myListInfoForRequst.isNotEmpty) {
              for (int xx = 0; xx < myListInfoForRequst.length; xx++) {
                if (myListInfoForRequst[xx]["uID"] == snapshot.data!.docs[index]["uId"]) {
                  YourImageeee = myListInfoForRequst[xx]["imageProFile"];
                  return YourImageeee;
                }

              }
            }else return YourImageeee;
          }
          allRequestImageGroup(index){

            if(myListInfoForGroup.isNotEmpty) {
              for (int xx = 0; xx < myListInfoForGroup.length; xx++) {
                if (myListInfoForGroup[xx]["uID"] == snapshot.data!.docs[index]["GroupId"]) {
                  YourImageeee = myListInfoForGroup[xx]["imageProFile"];
                  return YourImageeee;
                }

              }
            }else return YourImageeee;
          }

          //read All message
          return  snapshot.data!.docs.length==0? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("$NoRequest",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 18) ,),
            ],
          ) : ListView.builder(shrinkWrap:true,physics: ScrollPhysics(parent:BouncingScrollPhysics()),reverse: false,itemCount: snapshot.data!.docs.length,itemBuilder: (context,index){
            return InkWell(onTap: (){
              showAddOrDelete(context,allRequestName(index),allRequestNameGroup(index),snapshot.data!.docs[index]["GroupId"]
                  ,snapshot.data!.docs[index]["uId"],snapshot.data!.docs[index]["requestID"]);
            },
              splashColor: Colors.blueAccent,borderRadius: BorderRadius.circular(15),
              child: Card(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal:  20.0, vertical:  20.0 * 0.75),
                  child: Row(
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundImage:  NetworkImage(
                                "${allRequestImage(index)}"
                            ),
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
                        height: 50,
                        width:MediaQuery.of(context).size.width-150 ,
                        child: Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal:  20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:  [
                              Text("${allRequestName(index)}"
                                ,
                                style:
                                TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                              SizedBox(height: 8),
                              Opacity(
                                opacity: 0.64,
                                child: Text("$needjone"+" ${allRequestNameGroup(index)} "+"$Group",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Opacity(
                        opacity: .67,
                        child: InkWell(splashColor: Colors.black,
                            onTap: (){
                              Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => profile(
                                        uid:"${snapshot.data!.docs[index]["uId"]}",
                                        VIP: false
                                    ),
                                  ));
                            },
                            child: Icon(Icons.info_outline_rounded, size: 32,)),
                      )
                    ],
                  ),
                ),
              ),
            );
          });

        },),
    );
  }

}

