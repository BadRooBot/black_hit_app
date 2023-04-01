import 'package:AliStore/Ads/AdManager.dart';
import 'package:AliStore/constants.dart';
import 'package:AliStore/downloadPage/DownloadPage.dart';
import 'package:flutter/foundation.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';

import 'package:AliStore/Dashbord/home.dart';
import 'package:AliStore/alert.dart';
import 'package:AliStore/post/follow_button.dart';
import 'package:AliStore/Ads/tapjoy.dart';
import 'package:AliStore/resources/Localizations_constants.dart';
import 'package:AliStore/resources/MyWidgetFactory.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
class AllGames extends StatefulWidget {
  const AllGames({Key? key}) : super(key: key);

  @override
  _AllGamesState createState() => _AllGamesState();
}

CollectionReference Shopref = FirebaseFirestore.instance.collection("GameShop");
CollectionReference reference = FirebaseFirestore.instance.collection("limitGamShop");
List AllGameList = [];
DocumentReference saveDataReference =FirebaseFirestore.instance.collection("GameShopAfterBuy").doc("${FirebaseAuth.instance.currentUser!.uid}") ;

GlobalKey<FormState> playerIdKey = new GlobalKey<FormState>();
GlobalKey<FormState> ServerIdKey = new GlobalKey<FormState>();
GlobalKey<FormState> GroupIdKey = new GlobalKey<FormState>();
GlobalKey<FormState> GameIdKey = new GlobalKey<FormState>();
var playerId="";var ServeId="";var GroupId="";var GameId="";
var TestText=" ";

int spendCurrency=0;
int MyPoints=0;
int Scrol=9;
int GamShopCount=0;
String? SelectedItemText="Select";
bool StopGet=true;
bool ShowLoding=false;
List<String> DropItemList=[];
/*{"Image":"https://firebasestorage.googleapis.com/v0/b/roobotapp-11104.appspot.com/o/7RCHjTfbCrXVs4X8f8bQ3munIs82Media%2FProfile_Image%2Fprofile?alt=media&token=e54541ba-5d19-4dbd-922f-a4cb302fce54",
  "Name":"Conquer online" ,"Count":52}*/
class _AllGamesState extends State<AllGames> {
  getShopItemsInfo() async {
    var limitGamShop=  await reference.get();
    limitGamShop.docs.forEach((element) {
      setState(() {
        GamShopCount=element["limit"];
      });
    });
    AllGameList.clear();
    var ItemsInfo = await Shopref.orderBy("Name",descending: true).limit(10).get();
    ItemsInfo.docs.forEach((element) {
      setState(() {
        AllGameList.add(element.data());

      });
    });

  }
  goToDownload(context){

    Navigator.pushNamed(context, "downloadPage");

  }

  getShopItemsInfo2(int length,ind) async {

    //  AllGameList.clear();

      if (length <= GamShopCount) {
        var ItemsInfo = await Shopref.orderBy("Name",descending: true).startAfter(["$ind"]).get();
        ItemsInfo.docs.forEach((element) {
          setState(() {
            AllGameList.add(element.data());
          });
        });
        if(length+1==GamShopCount){setState(() {
          ShowLoding=false;
          StopGet=false;
        });}
      }
      else {
        var ItemsInfo = await Shopref.limit(GamShopCount).get();
        ItemsInfo.docs.forEach((element) {
          setState(() {
            AllGameList.add(element.data());
          });
        });
        setState(() {
          StopGet=false;
        });
      }


  }
final sc=ScrollController();
  showBuyScreen(Map GameList,context,name,List<String> DropList,String? SelectedItem,bool IsServer,bool IsGroupGame,bool IsGame,serverHint,GroupHint,GameHint,Isplayer){
    return
    showDialog(context: context,
        builder: (context){
      return   getPlatform()?Container(
        alignment: Alignment.center,
        margin:EdgeInsets.symmetric(horizontal: 40) ,
        child: Card(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
            child: Column(mainAxisSize: MainAxisSize.min,children: [
              Text("$name"),
              SizedBox(height: 10,),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide: BorderSide(width: 3,color: Colors.lightBlue)
                )),
                hint: Text('Selected Item'),
                items: DropList.map((item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(item,),
                )).toList(),
                onChanged: (item){
                  setState(() {
                    SelectedItemText =item;
                    for(int d=1;d<=DropList.length;d++){
                      if(GameList["Card$d"].toString()==item){
                        spendCurrency=GameList["price$d"];
                      }
                    }
                  });
                },
              ),
              SizedBox(height: 10,),
              Form(  key: playerIdKey,
                child: Column(
                  children: [
                    Visibility(visible: Isplayer??true ,
                      child: TextFormField(
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "player Id required";
                          }
                          return null;
                        },
                        onSaved: (val){
                          playerId=val!;
                        },
                        decoration: InputDecoration(
                            hintText: "Type your ID",
                            label: Text("player Id"),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(width: 1))),),
                    ),
                    SizedBox(height: 6,),
                    Visibility(visible:IsServer ,
                      child: TextFormField(
                        key: ServerIdKey,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "$serverHint  required";
                          }
                          return null;
                        },
                        onSaved: (val){
                          ServeId =val!;
                        },
                        decoration: InputDecoration(
                            hintText: "$serverHint",
                            label: Text("$serverHint"),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(width: 1))),),
                    ),
                    SizedBox(height: 6,),
                    Visibility(visible:IsGroupGame ,
                      child: TextFormField(
                        key: GroupIdKey,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "$GroupHint required";
                          }
                          return null;
                        },
                        onSaved: (val){
                          GroupId=val!;
                        },
                        decoration: InputDecoration(
                            hintText: "$GroupHint",
                            label: Text("$GroupHint"),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(width: 1))),),
                    ),
                    SizedBox(height: 6,),
                    Visibility(visible:IsGame ,
                      child: TextFormField(
                        key: GameIdKey,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return "$GameHint required";
                          }
                          return null;
                        },
                        onSaved: (val){
                          GameId=val!;
                        },
                        decoration: InputDecoration(
                            hintText: "$GameHint",
                            label: Text("$GameHint"),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(width: 1))),),
                    ),
                  ],
                ),
              ),


              FollowButton(splashColor: Colors.lightBlue, text:'OK', textColor: Colors.white,backgroundColor: Colors.blueGrey,
                function: () async{

                if(MyPoints>=spendCurrency){
                  var formdata = playerIdKey.currentState;
                  if (formdata!.validate()) {
                    formdata.save();
                    String loading = getTranslated(context,'Please-Wait');
                    showLoading(context, "$loading", true);
                    String key =FirebaseFirestore.instance.collection("users").doc().id;;
                    SpendCurrency(spendCurrency);
                    await saveDataReference.collection("Items").doc(key).set({
                      "Key": key,
                      "Card": SelectedItemText,
                      "PlayerID": playerId,
                      "ServerID": ServeId,
                      "GroupID": GroupId,
                      "GameID": GameId
                      ,
                      "ItemName": name
                    });
                    getPoints();
                  }
                }else{
                  String CoinLess = getTranslated(context,'CoinLess');
                  showLoading(context, "$CoinLess $spendCurrency BR", false);
                }
                },)


            ],),
          ),
        ),
      ):
          Container(
          alignment: Alignment.center,
          margin:EdgeInsets.symmetric(horizontal: 40) ,
          child: Card(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 20),
          child: Column(mainAxisSize: MainAxisSize.min,children: [
            Text("Sorry you have to download one land app to use this feature"),
            Divider(),
            SizedBox(height: 30,),
            FollowButton(

              text: 'Download Now',
              backgroundColor: Colors.white,
              textColor: Colors.black,
              splashColor: Colors.teal,
              function: () async {
                goToDownload(context);

              },
            ),
            SizedBox(height: 30,),
            FollowButton(
              text: 'No thanks',
              backgroundColor: Colors.indigo,
              textColor: Colors.white,
              splashColor: Colors.blue,
              function: () async {
                Navigator.of(context).pop();
              },
            ),
          ]))));


      //
        }
    );
  }

  @override
  void initState() {
    StopGet=true;
    getMyInfo();
    getShopItemsInfo();
    MyPoints=UserInfoList[0]["points"];
    getPoints();
    sc.addListener(() {
      if(sc.offset>=sc.position.maxScrollExtent){
        if(StopGet) {
          setState(() {
          ShowLoding=true;
        });
          getShopItemsInfo2(AllGameList.length,AllGameList[AllGameList.length-1]["Name"]);
        }else{
          setState(() {
            ShowLoding=false;
            StopGet=false;
          });
        }
      }
    });
    super.initState();
  }
  @override
  void dispose() {
    sc.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$MyPoints BR'),),
      body: GridView.builder(controller:sc ,itemCount:AllGameList.length,gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisExtent: 170,
        // childAspectRatio: 1,
      ),
          itemBuilder: (context, index){

        if(index==AllGameList.length-1){

            Scrol=index;
            return Visibility(visible:ShowLoding,child: Center(child: CircularProgressIndicator(color: myAppBarColor),));
        }
            return   Card(
              child: Column(
                children: [
                  GestureDetector(
                    onTap: (){
                      DropItemList.clear();
                      for(int x=1;x<AllGameList[index]["Count"];x++){
                          DropItemList.add(AllGameList[index]["Card$x"]);
                      }
                      showBuyScreen(AllGameList[index],context,AllGameList[index]["Name"],DropItemList,SelectedItemText,AllGameList[index]["IsServer"],AllGameList[index]["IsGroupGame"],AllGameList[index]["IsGame"],AllGameList[index]["serverHint"],AllGameList[index]["GroupHint"],AllGameList[index]["GameHint"],AllGameList[index]["Isplayer"]);
                    },
                    child: ClipRRect(borderRadius:  BorderRadius.circular(6),
                      child: HtmlWidget(
                        '<img width="110" height="125" src="${AllGameList[index]["Image"]}" '
                            '/>',
                        factoryBuilder: () => MyWidgetFactory(),enableCaching: true,
                      ),
                    ),
                  ),
                  Text("${AllGameList[index]["Name"]}"),
                ],
              ),
            );
          })
      ,
    );
  }

  getPlatform() {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return true;
    }else  if (defaultTargetPlatform == TargetPlatform.iOS) {
      return true;
    }else{
      return false;
    }
  }
}

