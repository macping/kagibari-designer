/// MicroCalc Shell: 言語設定（システム追従 or 手動選択）。
library;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleController extends ChangeNotifier {
  LocaleController();

  @visibleForTesting
  LocaleController.forTest(String? languageCode) {
    _locale = languageCode == null ? null : Locale(languageCode);
  }

  static const _prefsKey = 'app_locale';
  static const supported = [Locale('ja'), Locale('en'), Locale('zh')];

  /// null = システムに従う
  Locale? _locale;
  Locale? get locale => _locale;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(_prefsKey);
    _locale = code == null ? null : Locale(code);
    notifyListeners();
  }

  Future<void> setLocale(Locale? locale) async {
    _locale = locale;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    if (locale == null) {
      await prefs.remove(_prefsKey);
    } else {
      await prefs.setString(_prefsKey, locale.languageCode);
    }
  }
}
