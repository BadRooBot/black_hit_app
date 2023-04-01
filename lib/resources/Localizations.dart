import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
class DemoLocalizations{
  final Locale locale;

  DemoLocalizations(this.locale);

  static DemoLocalizations of(BuildContext context) {
    return Localizations.of<DemoLocalizations>(context, DemoLocalizations)!;
  }

 late Map<String,String> _LocalizedVaues;

  Future load()async{
    String jsonStringVales=await rootBundle.loadString("lib/i18n/${locale.languageCode}.json");

    Map<String,dynamic> mapJson=json.decoder.convert(jsonStringVales) ;

    _LocalizedVaues=mapJson.map((key, value) => MapEntry(key, value.toString()));
  }


  String getTranslatedValue(String key){
    return _LocalizedVaues[key]!;
  }

  static const LocalizationsDelegate<DemoLocalizations>delegate=_DemoLocalizationsDelegate();
}
class _DemoLocalizationsDelegate
    extends LocalizationsDelegate<DemoLocalizations> {
  const _DemoLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en','ar'].contains(locale.languageCode);
  }


  @override
  Future<DemoLocalizations> load(Locale locale) async{
    DemoLocalizations localizations =new DemoLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_DemoLocalizationsDelegate old) => false;
}