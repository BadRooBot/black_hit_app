import 'package:AliStore/Dashbord/profile.dart';
import 'package:AliStore/resources/API_Black_Hit.dart';
import 'package:flutter/material.dart';
import '../resources/Localizations_constants.dart';
import '../resources/MyWidgetFactory.dart';
import 'messageAcitvity.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

class AllUser extends StatefulWidget {
  const AllUser({Key? key}) : super(key: key);

  @override
  State<AllUser> createState() => _AllUserState();
}

class _AllUserState extends State<AllUser> {
  var myS = 23.0;
  String img = 'assets/back.jpg';
  List AllUsersListInfo = [];
  final scrollController = ScrollController();

  getAllUser(bool IsFirstTime2) async {
    // var realDb = new realtimeDb();

    int lu = 2;
    if (myS >= 550) {
      lu = 15;
    } else {
      lu = 10;
    }
    var _val;
    if (IsFirstTime2) {
      _val = await API().getAllUsers(); //realDb.GetAllUserData(Limite: lu);
      setState(() {
        AllUsersListInfo = _val;
      });
      /*  var inof2 = await userinfoRef.orderBy("uID").limit(lu).get();
     inof2.docs.forEach((element) {
       setState(() {
         AllUsersListInfo.add(element.data());
       });
     });
     */
    } else {
      _val = await API().getAllUsers(); // realDb.GetAllUserData(Limite: lu);
      setState(() {
        AllUsersListInfo = _val;
      });
      /* var inof = await userinfoRef.orderBy("uID").startAt([AllUsersListInfo[AllUsersListInfo.length-1]["uID"]]).limit(lu).get();
     inof.docs.forEach((element) {
       setState(() {
         if(AllUsersListInfo[AllUsersListInfo.length-1]["uID"]!=element["uID"]){
         AllUsersListInfo.add(element.data());
         }
       });
     });*/
    }
  }

  @override
  void initState() {
    getAllUser(true);
    scrollController.addListener(() {
      if (scrollController.offset >=
          scrollController.position.maxScrollExtent) {
        setState(() {
          getAllUser(false);
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String _AllUsers = getTranslated(context, "AllUsers");

    return Scaffold(
      appBar: AppBar(
        title: Text('$_AllUsers'),
      ),
      body: AllUsers(context),
    );
  }

  AllUsers(context) {
    return ListView.builder(
        itemCount: AllUsersListInfo.length,
        controller: scrollController,
        itemBuilder: (context, i) {
          try {
            return SizedBox(
              width: MediaQuery.of(context).size.width - 1.7,
              height: 90,
              child: InkWell(
                onTap: () {
                  // Navigator.of(context).push(MaterialPageRoute(
                  //   builder: (context) => message(
                  //     Name: "${AllUsersListInfo[i]["name"]}",
                  //     Image: "${AllUsersListInfo[i]["imageProFile"]}",
                  //     Uid: "${AllUsersListInfo[i]["uID"]}",
                  //     isGroup: false,
                  //     VIP: AllUsersListInfo[i]["VIP"],
                  //   ),
                  // ));
                },
                splashColor: Colors.blueAccent,
                borderRadius: BorderRadius.circular(15),
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 20.0 * 0.75),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            AllUsersListInfo[i]["VIP"]
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(25),
                                    child: Container(
                                      width: 46,
                                      height: 46,
                                      child: HtmlWidget(
                                        '<img width="46" height="46" src="${AllUsersListInfo[i]["imageProFile"]}" '
                                        '/>',
                                        factoryBuilder: () => MyWidgetFactory(),
                                        enableCaching: true,
                                      ),
                                    ),
                                  )
                                : CircleAvatar(
                                    backgroundImage: AssetImage(img),
                                    child: Text(
                                      "${AllUsersListInfo[i]["name"].toString().substring(0, 1).toUpperCase()}",
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                            /* CircleAvatar(
                          radius: 24,
                          backgroundImage: NetworkImage(
                              "${myListInfo[i]["imageProFile"]}"),
                        ),*/
                            if (false) //chat.isActive
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
                                        color: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        width: 3),
                                  ),
                                ),
                              )
                          ],
                        ),
                        Container(
                          height: 52,
                          width: (MediaQuery.of(context).size.width) / 1.8,
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${AllUsersListInfo[i]["name"]}",
                                maxLines: 1,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                              SizedBox(height: 2),
                              Opacity(
                                opacity: 0.60,
                                child: Text(
                                  "${AllUsersListInfo[i]["status"]}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Opacity(
                          opacity: .67,
                          child: InkWell(
                              splashColor: Colors.blueGrey,
                              onTap: () {
                                // Navigator.of(context).push(MaterialPageRoute(
                                //   builder: (context) => profile(
                                //     uid: "${AllUsersListInfo[i]["uID"]}",
                                //     VIP: AllUsersListInfo[i]["VIP"],
                                //   ),
                                // ));
                              },
                              child: Icon(
                                Icons.info_outline_rounded,
                                size: 32,
                              )),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          } catch (e) {
            return Text("");
          }
        });
  }
}
