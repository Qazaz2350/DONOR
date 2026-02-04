import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static final LocalStorageService _instance = LocalStorageService._internal();
  factory LocalStorageService() => _instance;
  LocalStorageService._internal();

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // User data keys
  static const String _userIdKey = 'user_id';
  static const String _userTypeKey = 'user_type';
  static const String _userNameKey = 'user_name';
  static const String _userEmailKey = 'user_email';
  static const String _userPhoneKey = 'user_phone';
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _orphanageStatusKey = 'orphanage_status';
  static const String _isFirstTimeKey = 'is_first_time';

  // Save user data after signup
  Future<void> saveUserData({
    required String userId,
    required String userType,
    required String userName,
    required String userEmail,
    required String userPhone,
    String? orphanageStatus,
  }) async {
    await _prefs.setString(_userIdKey, userId);
    await _prefs.setString(_userTypeKey, userType);
    await _prefs.setString(_userNameKey, userName);
    await _prefs.setString(_userEmailKey, userEmail);
    await _prefs.setString(_userPhoneKey, userPhone);
    await _prefs.setBool(_isLoggedInKey, true);

    if (orphanageStatus != null) {
      await _prefs.setString(_orphanageStatusKey, orphanageStatus);
    }
  }

  // Save user data after login
  Future<void> saveLoginData({
    required String userId,
    required String userType,
    required String userName,
    required String userEmail,
    required String userPhone,
    String? orphanageStatus,
  }) async {
    await _prefs.setString(_userIdKey, userId);
    await _prefs.setString(_userTypeKey, userType);
    await _prefs.setString(_userNameKey, userName);
    await _prefs.setString(_userEmailKey, userEmail);
    await _prefs.setString(_userPhoneKey, userPhone);
    await _prefs.setBool(_isLoggedInKey, true);

    if (orphanageStatus != null) {
      await _prefs.setString(_orphanageStatusKey, orphanageStatus);
    }
  }

  // Get user data
  String get userId => _prefs.getString(_userIdKey) ?? '';
  String get userType => _prefs.getString(_userTypeKey) ?? '';
  String get userName => _prefs.getString(_userNameKey) ?? '';
  String get userEmail => _prefs.getString(_userEmailKey) ?? '';
  String get userPhone => _prefs.getString(_userPhoneKey) ?? '';
  String get orphanageStatus => _prefs.getString(_orphanageStatusKey) ?? '';
  bool get isLoggedIn => _prefs.getBool(_isLoggedInKey) ?? false;

  // Check if first time user (for onboarding)
  bool get isFirstTime => _prefs.getBool(_isFirstTimeKey) ?? true;
  Future<void> setFirstTime(bool value) async {
    await _prefs.setBool(_isFirstTimeKey, value);
  }

  // Update specific fields
  Future<void> updateUserName(String name) async {
    await _prefs.setString(_userNameKey, name);
  }

  Future<void> updateUserPhone(String phone) async {
    await _prefs.setString(_userPhoneKey, phone);
  }

  Future<void> updateOrphanageStatus(String status) async {
    await _prefs.setString(_orphanageStatusKey, status);
  }

  // Clear all data (logout)
  Future<void> clearAllData() async {
    await _prefs.clear();
  }

  // Clear specific data
  Future<void> clearUserData() async {
    await _prefs.remove(_userIdKey);
    await _prefs.remove(_userTypeKey);
    await _prefs.remove(_userNameKey);
    await _prefs.remove(_userEmailKey);
    await _prefs.remove(_userPhoneKey);
    await _prefs.remove(_orphanageStatusKey);
    await _prefs.setBool(_isLoggedInKey, false);
  }
}
