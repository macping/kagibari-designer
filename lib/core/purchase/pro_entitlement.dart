/// MicroCalc Shell: 買切（Pro）権利状態。
/// ストア検証はローカル完結（レシート検証サーバーなし＝零服务器成本）。
library;

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProEntitlement extends ChangeNotifier {
  ProEntitlement();

  /// テスト用: 初期状態を指定して生成（load不要）。
  @visibleForTesting
  ProEntitlement.forTest({bool isPro = false}) {
    _isPro = isPro;
  }

  static const _prefsKey = 'pro_unlocked';

  bool _isPro = false;
  bool get isPro => _isPro;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _isPro = prefs.getBool(_prefsKey) ?? false;
    notifyListeners();
  }

  Future<void> setPro(bool value) async {
    if (_isPro == value) return;
    _isPro = value;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_prefsKey, value);
  }
}
