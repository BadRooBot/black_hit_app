
import 'package:AliStore/Ads/AdManager.dart';
import 'package:AliStore/blog/AddNewBlog.dart';
import 'package:AliStore/blog/blogpage.dart';
import 'package:AliStore/downloadPage/DownloadPage.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:unity_mediation/unity_mediation.dart';
import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:AliStore/Dashbord/addNewGroup.dart';
import 'package:AliStore/Dashbord/home.dart';
import 'package:AliStore/Shop/AddItemToShop.dart';
import 'package:AliStore/constants.dart';
import 'package:AliStore/post/add_post_screen.dart';
import 'package:AliStore/resources/Localizations.dart';
import 'package:AliStore/resources/Localizations_constants.dart';
import 'package:AliStore/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unity_ads_plugin/unity_ads_plugin.dart';
import 'blog/blogSearch.dart';
import 'login/getUserInfo.dart';
import 'login/login.dart';
import 'login/signup.dart';
import 'package:splashscreen/splashscreen.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  static void setLocale(BuildContext context,Locale locale){
   _MyAppState state=context.findAncestorStateOfType<_MyAppState>()!;
    state.setLocale(locale);
  }
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
   Locale _locale=Locale("en");
  void setLocale(Locale locale){
    setState(() {
      if(locale!=null) {
        _locale = locale;
      }
    });
}


@override
  void didChangeDependencies() {
    getLocale().then((value) {
      setState(() {
        if(value!=null) {
          _locale = value;
        }
      });
    });

    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    LocalJsonLocalization.delegate.directories = ['lib/i18n'];

    return MaterialApp(

      title: 'One Land',
        debugShowCheckedModeBanner: false,
        theme:lightThemeData(context).copyWith(
          appBarTheme: const AppBarTheme(color: Color(0xFF508098)),//0xFF154c79
          scaffoldBackgroundColor:MyBadyColor ,cardColor: MyBadyColor//const Color(0xFFDAD8D9)
        ),
        darkTheme: darkThemeData(context).copyWith(
          appBarTheme: const AppBarTheme(color: Color(0xFF253341)),
          scaffoldBackgroundColor: MyBadyColorDark,cardColor: MyBadyColorDark
        ),
      supportedLocales: [Locale("en",""),Locale("ar","")],
        localizationsDelegates: [
          DemoLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
      locale: _locale!=null?_locale:Locale("en"),
      localeResolutionCallback: (deviceLocals,supportedLocals){
        for(var local in supportedLocals ){
          if(local.languageCode==deviceLocals!.languageCode){
            return deviceLocals;
          }
        }
        return supportedLocals.first;
      },

      home:const FirstScreen(),

      routes: {
        "login": (context) => const NewLogin(),
        "signup": (context) => const singup(),
        "home": (context) => const home(),
        "getUserInfo": (context) => const getUserInfo(),
        "addNewGroup": (context) => const addNewGroup(),
        "AddPostScreen": (context) => const AddPostScreen(),
        "AddItemToShop": (context) => const AddItemToShop(),
        "downloadPage": (context) => const DownloadPage(),
        "blogpage": (context) => const blogpage(),
        "AddNewBlog": (context) => const AddNewBlog(),
        "blogSearch": (context) => const blogSearch(),
      }
    );
  }
}
class FirstScreen extends StatefulWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  Future<Widget> loadFromFuture() async {






      SharedPreferences _preferences = await SharedPreferences.getInstance();
      UnityAds.init(
        gameId: AdManager.gameId,
        onComplete: () => print('Initialization Complete'),
        onFailed: (error, message) =>
            print('Initialization Failed: $error $message'),
      );
      UnityMediation.initialize(
        gameId: AdManager.gameId,
        onComplete: () => print('Initialization Complete'),
        onFailed: (error, message) =>
            print('Initialization Failed: $error $message'),
      );
      var dsds = await IsFirstlogin();

    return Future.value(home());
  }
  @override
  Widget build(BuildContext context) {
    var size=MediaQuery.of(context).size;
    return SplashScreen(
      navigateAfterFuture:  loadFromFuture(),
      image: Image.asset("assets/one_land_whit.png",fit: BoxFit.fill,),photoSize: 125,
      backgroundColor: Colors.blueGrey,
      loaderColor: Color(0xFF253341),
    );
  }
}

IsFirstlogin()async{
  SharedPreferences _preferences =await SharedPreferences.getInstance();

  var em=_preferences.getString('email')??'no';
  var pa=_preferences.getString('pas')??'';
  if(em!='no'){
  //  FirebaseAuth.instance.signInWithEmailAndPassword(email: em, password: pa);
   // if(UserInfoList.isEmpty){
     /* var Usersinof =
      await wesa.where("uID", isEqualTo: "${FirebaseAuth.instance.currentUser!.uid}").get();
      Usersinof.docs.forEach((element) {
       UserInfoList.add(element.data());
      });
*/



    //}
    return  home();
  }else{
    return NewLogin();
  }

}
/*
firebaseConfig = {
  apiKey: "AIzaSyBjcunQDiv3asGaq_wWgd7nFfoOG3kiUoo",
  authDomain: "one-piece-b44fe.firebaseapp.com",
  projectId: "one-piece-b44fe",
  storageBucket: "one-piece-b44fe.appspot.com",
  messagingSenderId: "456114151431",
  appId: "1:456114151431:web:9765b3a5c69e77c623caa2"
};
* */