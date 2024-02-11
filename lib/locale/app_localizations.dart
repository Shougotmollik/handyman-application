import 'package:flutter/material.dart';
import 'package:handyman_admin_flutter/locale/base_language.dart';
import 'package:handyman_admin_flutter/locale/language_ar.dart';
import 'package:handyman_admin_flutter/locale/language_en.dart';
import 'package:handyman_admin_flutter/locale/language_fr.dart';
import 'package:handyman_admin_flutter/locale/language_hi.dart';
import 'package:nb_utils/nb_utils.dart';

import 'lanuage_de.dart';

class AppLocalizations extends LocalizationsDelegate<BaseLanguage> {
  const AppLocalizations();

  @override
  Future<BaseLanguage> load(Locale locale) async {
    switch (locale.languageCode) {
      case 'en':
        return LanguageEn();
      case 'hi':
        return LanguageHi();
      case 'ar':
        return LanguageAr();
      case 'fr':
        return LanguageFr();
      case 'de':
        return LanguageDe();
      default:
        return LanguageEn();
    }
  }

  @override
  bool isSupported(Locale locale) => LanguageDataModel.languages().contains(locale.languageCode);

  @override
  bool shouldReload(LocalizationsDelegate<BaseLanguage> old) => false;
}
