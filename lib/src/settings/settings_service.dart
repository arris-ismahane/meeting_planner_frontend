import 'package:flutter/material.dart';
import 'package:devicelocale/devicelocale.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rxdart/rxdart.dart';

class SettingsService {
  static const Locale en = Locale('en', '');
  static const Locale fr = Locale('fr', '');

  static const themeKey = "theme";
  static const localeKey = "locale";

  List<Locale> supportedLocales() => [fr, en];

  Future<ThemeMode> themeMode() {
    return SharedPreferences.getInstance()
        .asStream()
        .map((prefs) => prefs.getString(themeKey))
        .map((event) {
          if (event == null) {
            return ThemeMode.system;
          }
          switch (event) {
            case "system":
              return ThemeMode.system;
            case "dark":
              return ThemeMode.dark;
            case "light":
              return ThemeMode.light;
          }
          return ThemeMode.system;
        })
        .onErrorReturn(ThemeMode.system)
        .first;
  }

  Future<void> updateThemeMode(ThemeMode theme) {
    return SharedPreferences.getInstance()
        .asStream()
        .asyncMap((prefs) => prefs.setString(themeKey, theme.name))
        .first;
  }

  Future<void> updateLocale(Locale locale) {
    return SharedPreferences.getInstance()
        .asStream()
        .asyncMap((prefs) => prefs.setString(localeKey, locale.serialize()))
        .first;
  }

  Future<Locale> current() async {
    var prefs = await SharedPreferences.getInstance();
    var locale = prefs.getString(localeKey);
    if (locale != null) {
      var parsedLocale = LocaleExt.parse(locale);
      if (parsedLocale != null) {
        return parsedLocale;
      }
    }
    return _getDefaultLocale();
  }

  Future<Locale> _getDefaultLocale() async {
    var current = await Devicelocale.currentAsLocale;
    if (current != null) {
      var list = supportedLocales()
          .where((current) => current.languageCode == current.languageCode)
          .toList();
      if (list.isNotEmpty) {
        return list.first;
      }
    }
    return supportedLocales().first;
  }
}

extension LocaleExt on Locale {
  String serialize() {
    return "${languageCode}_$countryCode";
  }

  static Locale? parse(String value) {
    try {
      var split = value.split("_");
      return Locale(split[0], split.length > 1 ? split[1] : '');
    } catch (error) {
      /**
       * Ignore this
       */
    }
    return null;
  }
}
