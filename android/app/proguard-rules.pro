# R8 full mode (AGP 8) が JNI/リフレクション経由でしか呼ばれないクラス・メソッドを
# 剥がして release ビルドだけ壊すため、ここで明示的に keep する。
# debug / flutter run は難読化しないので、この種の不具合は release 実機/エミュ検証でしか出ない。

# shared_preferences_android 2.5.x は jnigen (dartjni) 経由で Kotlin suspend メソッドを呼ぶ。
# keep しないと起動時に JNI 参照先が見つからず runApp 前に main が死に、
# splash で永久停止する（2026-10-21 kagibari 実測、2段階で発現）:
#   1) NoSuchMethodError: SharedPreferencesApiRegistrar.getAll(...Continuation;)
#   2) ClassNotFoundException: kotlin.coroutines.intrinsics.CoroutineSingletons
#      （suspend 戻り値の COROUTINE_SUSPENDED 判定を JNI が名前で引くため）
# kotlin.coroutines はパッケージごと keep（intrinsics 含む・サイズ影響は僅少）。
# 終極処方（2026-10-21 rente-2027 実測報より）: coroutines 包だけ keep しても
# kotlin.Result 等が剥がれて三度目の発現がある → kotlin 標準庫を丸ごと keep。
# サイズ影響 ~1MB 弱 vs 再発リスク、迷わず全保。
-keep class io.flutter.plugins.sharedpreferences.** { *; }
-keep class com.github.dart_lang.jni.** { *; }
-keep class kotlin.** { *; }

# Room/WorkManager 生成クラスの無引数コンストラクタ（2026-09-16 tw-license 実測、予防的に常備）
-keep class * extends androidx.room.RoomDatabase { <init>(); }
