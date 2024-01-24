import 'package:hive_flutter/hive_flutter.dart';

enum MainBoxKeys { accessToken, refreshToken, isLogin, userName, email }

mixin class MainBoxMixin {
  static late Box? mainBox;
  static const _boxName = 'futurehook_crm_app';

  static Future<void> initHive() async {
    await Hive.initFlutter();
    mainBox = await Hive.openBox(_boxName);
  }

  Future<void> addData<T>(MainBoxKeys key, T value) async {
    await mainBox?.put(key.name, value);
  }

  Future<void> removeData(MainBoxKeys key) async {
    await mainBox?.delete(key.name);
  }

  T getData<T>(MainBoxKeys key) => mainBox?.get(key.name) as T;

  Future<void> logoutBox() async {
    /// Clear the box
    removeData(MainBoxKeys.isLogin);
    removeData(MainBoxKeys.refreshToken);
    removeData(MainBoxKeys.accessToken);
    removeData(MainBoxKeys.email);
    removeData(MainBoxKeys.userName);
  }

  Future<void> closeBox() async {
    try {
      if (mainBox != null) {
        await mainBox?.close();
        await mainBox?.deleteFromDisk();
      }
    } catch (e, stackTrace) {
      // if (!isUnitTest) {
      //   FirebaseCrashLogger().nonFatalError(error: e, stackTrace: stackTrace);
      // }
    }
  }
}
