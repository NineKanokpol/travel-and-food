import 'package:localstorage/localstorage.dart';

import '../models/user_model.dart';

///การจัดการ local storage ของโทรศัพท์
class LocalStorageManager {
  static final LocalStorage storage = new LocalStorage('MyApp');

  static final String LOGINDATA = 'LOGINDATA';
  static final String SENSOR1 = 'SENSOR1';
  static final String SENSOR2 = 'SENSOR2';
  static final String NOTIDATA = 'NOTIDATA';

  static Future<UserModel> getAccount() async {
    await storage.ready;
    print('getDataData');
    var getApp = storage.getItem(LOGINDATA);
    if (getApp == null) {
      var response = UserModel();
      return response;
    }
    Map<String, dynamic> storageData = Map<String, dynamic>.from(getApp);
    var response = UserModel.fromJson(storageData);

    return response;
  }

  static saveLoginData(dynamic value) async {
    await storage.ready;
    print('saveChatData');
    return storage.setItem(LOGINDATA, value);
  }

  static void clearLoginData() async {
    print("clearLoginData");
    await storage.ready;
    await storage.deleteItem(LOGINDATA);
  }

  static void clearNotiData() async {
    print("clearLoginData");
    await storage.ready;
    await storage.deleteItem(NOTIDATA);
  }
}