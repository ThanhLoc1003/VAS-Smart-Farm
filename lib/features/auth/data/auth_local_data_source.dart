import 'package:shared_preferences/shared_preferences.dart';
import 'package:vas_farm/features/auth/data/constants.dart';

class AuthLocalDataSource {
  final SharedPreferences sf;

  AuthLocalDataSource(this.sf);
  Future<void> saveRole(String role) async {
    await sf.setString(AuthDataConstants.roleKey, role);
  }

  Future<String?> getRole() async {
    return sf.getString(AuthDataConstants.roleKey);
  }

  Future<void> clearRole() async {
    await sf.remove(AuthDataConstants.roleKey);
  }
}
