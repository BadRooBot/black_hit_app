import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';
import 'package:AliStore/Ads/AdManager.dart';
import 'package:AliStore/alert.dart';
import 'package:flutter/material.dart';
import 'package:tap_joy_plugin/tap_joy_plugin.dart';

class TapJoy extends StatefulWidget {
  const TapJoy({Key? key}) : super(key: key);

  @override
  _TapJoyState createState() => _TapJoyState();
}

class _TapJoyState extends State<TapJoy> {
  TJPlacement myPlacement = TJPlacement(name: "wall");
  TJPlacement myPlacement2 = TJPlacement(name: "video");
  bool isRReady = false;
  String contentStateText = "";
  String connectionState = "";
  String iOSATTAuthResult = "";
  String balance = "";
  var myBalance;
  int MyPoints = 0;

  late Timer _timerForInter;
  @override
  void initState() {
    super.initState();
    // set connection result handler
    TapJoyPlugin.shared.setConnectionResultHandler(_connectionResultHandler());
    // connect to TapJoy, all fields are required.
    TapJoyPlugin.shared.connect(
        androidApiKey:
            "uHRlVCNCRJ6aohUKzZveuAECbG1agxg30fJHXsAOZ8fnylVaDUsp4IZDsuus", // "uHRlVCNCRJ6aohUKzZveuAECbG1agxg30fJHXsAOZ8fnylVaDUsp4IZDsuus",
        iOSApiKey:
            "k_X8qU2XQwqE6WZ9g_IEyAEBEVKcOcwAUfyTbP3FeYi2tKW_KrbNqvKs4u-_",
        debug: true);
    // set userID
    //TapJoyPlugin.shared.setUserID(userID: "${FirebaseAuth.instance.currentUser!.uid}");
    // set contentState handler for each placement
    myPlacement.setHandler(_placementHandler());
    myPlacement2.setHandler(_placementHandler());
    // add placements.
    TapJoyPlugin.shared.addPlacement(myPlacement);
    TapJoyPlugin.shared.addPlacement(myPlacement2);
    // set currency Handlers
    TapJoyPlugin.shared.setGetCurrencyBalanceHandler(_currencyHandler());
    TapJoyPlugin.shared.setAwardCurrencyHandler(_currencyHandler());
    TapJoyPlugin.shared.setSpendCurrencyHandler(_currencyHandler());
    TapJoyPlugin.shared.setEarnedCurrencyAlertHandler(_currencyHandler());
    TapJoyPlugin.shared.getCurrencyBalance();
    /*   _timerForInter = Timer.periodic(Duration(seconds: 10), (result) {
      ShowOfferWall(context);
    });*/
  }

// currency handler
  TJSpendCurrencyHandler _currencyHandler() {
    TJSpendCurrencyHandler handler = (currencyName, amount, error) {
      setState(() {
        myBalance = "Currency Name: " +
            currencyName.toString() +
            " Amount:  " +
            amount.toString() +
            " Error:" +
            error.toString();
        balance = currencyName.toString() + ' :  ' + amount.toString();
        MyPoints = amount!;
        // savePointInFirebase(amount);
      });
    };
    return handler;
  }

  // savePointInFirebase(point) async{
  //   await FirebaseFirestore.instance.collection("users").doc("${FirebaseAuth.instance.currentUser!.uid}").set({
  //     "points":point},SetOptions(merge: true));

  // }
  // connection result handler
  TJConnectionResultHandler _connectionResultHandler() {
    TJConnectionResultHandler handler = (result) {
      switch (result) {
        case TJConnectionResult.connected:
          // TODO: Handle this case.
          setState(() {
            connectionState = "Connected";
          });
          break;
        case TJConnectionResult.disconnected:
          // TODO: Handle this case.
          setState(() {
            connectionState = "Disconnected";
          });
          break;
      }
    };
    return handler;
  }

  // placement Handler
  TJPlacementHandler _placementHandler() {
    TJPlacementHandler handler = (contentState, name, error) {
      switch (contentState) {
        case TJContentState.contentReady:
          Navigator.of(context).pop();
          if (name == "wall") {
            myPlacement.showPlacement();
          } else {
            myPlacement2.showPlacement();
          }
          setState(() {
            isRReady = true;
            contentStateText = "Content Ready for placement :  $name";
          });
          break;
        case TJContentState.contentDidAppear:
          setState(() {
            isRReady = false;
            contentStateText = "Content Did Appear for placement :  $name";
          });
          break;
        case TJContentState.contentDidDisappear:
          TapJoyPlugin.shared.getCurrencyBalance();
          setState(() {
            isRReady = false;
            contentStateText = "Content Did Disappear for placement :  $name";
          });
          myPlacement.requestContent;
          break;
        case TJContentState.contentRequestSuccess:
          setState(() {
            isRReady = false;
            contentStateText = "Content Request Success for placement :  $name";
          });
          break;
        case TJContentState.contentRequestFail:
          setState(() {
            isRReady = false;
            contentStateText =
                "Content Request Fail + $error for placement :  $name";
          });
          break;
        case TJContentState.userClickedAndroidOnly:
          setState(() {
            isRReady = false;
            contentStateText = "Content User Clicked for placement :  $name";
          });
          break;
      }
    };
    return handler;
  }

  // get App Tracking Authentication . iOS ONLY
  Future<String> getAuth() async {
    TapJoyPlugin.shared.getIOSATTAuth().then((value) {
      switch (value) {
        case IOSATTAuthResult.notDetermined:
          setState(() {
            iOSATTAuthResult = "Not Determined";
          });
          break;
        case IOSATTAuthResult.restricted:
          setState(() {
            iOSATTAuthResult = "Restricted ";
          });
          break;
        case IOSATTAuthResult.denied:
          setState(() {
            iOSATTAuthResult = "Denied ";
          });
          break;
        case IOSATTAuthResult.authorized:
          setState(() {
            iOSATTAuthResult = "Authorized ";
          });
          break;
        case IOSATTAuthResult.none:
          setState(() {
            iOSATTAuthResult = "Error ";
          });
          break;
        case IOSATTAuthResult.iOSVersionNotSupported:
          setState(() {
            iOSATTAuthResult = "IOS Version Not Supported ";
          });
          break;
        case IOSATTAuthResult.android:
          setState(() {
            iOSATTAuthResult = "on Android";
          });
      }
    });
    return iOSATTAuthResult;
  }

  @override
  void dispose() {
    // Add these to dispose to cancel timer when user leaves the app
    _timerForInter.cancel();

    super.dispose();
  }

  getPlatform() {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return true;
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('BR : $MyPoints'),
      ),
      body: getPlatform()
          ? Container(
              child: ListView(
                children: [
                  Center(
                    child: UnityBannerAd(
                        placementId: AdManager.bannerAdPlacementId),
                  ),
                  Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                      child: GestureDetector(
                          onTap: () {
                            ShowOfferWall(context);
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.asset(
                              "assets/offer.png",
                              fit: BoxFit.fill,
                              width: size.width - 15,
                              height: 150,
                            ),
                          ))),
                  Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      child: GestureDetector(
                          onTap: () {
                            ShowVideo(context);
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.asset(
                              "assets/watch_video.png",
                              fit: BoxFit.fill,
                              width: size.width - 15,
                              height: 150,
                            ),
                          )))
                ],
              ),
            )
          : Center(
              child: Text(
                  "Sorry you have to download one land app to use this feature")),
    );
  }

  ShowOfferWall(context) async {
    if (isRReady) {
      myPlacement.showPlacement();
    } else {
      // showLoading(context, "", true);
      await myPlacement.requestContent
          .call()
          .whenComplete(() => isRReady = true);
    }
  }

  ShowVideo(context) async {
    if (isRReady) {
      myPlacement2.showPlacement();
    } else {
      //showLoading(context, "", true);
      await myPlacement2.requestContent
          .call()
          .whenComplete(() => isRReady = true);
    }
  }
}

getPoints() {
  TapJoyPlugin.shared.getCurrencyBalance();
}

SpendCurrency(sx) {
  TapJoyPlugin.shared.spendCurrency(sx);
}
