import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

class DataRepository {
  static String? loginName;
  static String? firstName;
  static String? lastName;
  static String? phone;
  static String? email;

  static final EncryptedSharedPreferences _prefs = EncryptedSharedPreferences();

  static Future<void> loadData() async {
    loginName = await _prefs.getString('loginName') ?? '';
    firstName = await _prefs.getString('firstName') ?? '';
    lastName = await _prefs.getString('lastName') ?? '';
    phone = await _prefs.getString('phone') ?? '';
    email = await _prefs.getString('email') ?? '';
    print('Data loaded: loginName=$loginName, firstName=$firstName, lastName=$lastName, phone=$phone, email=$email');
  }

  static Future<void> saveData() async {
    await _prefs.setString('loginName', loginName ?? '');
    await _prefs.setString('firstName', firstName ?? '');
    await _prefs.setString('lastName', lastName ?? '');
    await _prefs.setString('phone', phone ?? '');
    await _prefs.setString('email', email ?? '');
    print('Data saved: loginName=$loginName, firstName=$firstName, lastName=$lastName, phone=$phone, email=$email');
  }
}
