import 'package:flutter/material.dart';
import 'package:AliStore/resources/Localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';


String getTranslated(BuildContext context,String key){
  return DemoLocalizations.of(context).getTranslatedValue(key);
}
const String ENGLSIH='en';
const String ARABIC='ar';

const LangaugeKey="LangugeKey";
Future<Locale> setLocale(String LangaugeCode)async{
  SharedPreferences _preferences =await SharedPreferences.getInstance();
 await _preferences.setString(LangaugeKey,LangaugeCode);
  return _locale(LangaugeCode);
}
Locale _locale(String LangaugeCode){
  Locale _temp;
  switch(LangaugeCode){
    case ENGLSIH:
      _temp=Locale("en","");
      break;
    case ARABIC:
      _temp=Locale("ar","");
      break;

    default:
      _temp=Locale("en","");
      break;
  }
  return _temp;
}

Future<Locale> getLocale()async{
  SharedPreferences _preferences =await SharedPreferences.getInstance();
  String LangaugeCode=_preferences.getString(LangaugeKey)??'en';
  return _locale(LangaugeCode);
}