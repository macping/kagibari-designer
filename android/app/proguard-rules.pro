# R8 full mode (AGP 8) が JNI/リフレクション経由でしか呼ばれないクラス・メソッドを
# 剥がして release ビルドだけ壊すため、ここで明示的に keep する。
# debug / flutter run は難読化しないので、この種の不具合は release 実機/エミュ検証でしか出ない。

# shared_preferences_android 2.5.x は jnigen (dartjni) 経由で Kotlin suspend メソッドを呼ぶ。
# keep しないと起動時 NoSuchMethodError: SharedPreferencesApiRegistrar.getAll(...Continuation;)
# → runApp 前に main が死に、splash で永久停止（2026-10-21 kagibari 実測）。
-keep class io.flutter.plugins.sharedpreferences.** { *; }
-keep class com.github.dart_lang.jni.** { *; }
-keep class kotlin.coroutines.Continuation { *; }

# Room/WorkManager 生成クラスの無引数コンストラクタ（2026-09-16 tw-license 実測、予防的に常備）
-keep class * extends androidx.room.RoomDatabase { <init>(); }
