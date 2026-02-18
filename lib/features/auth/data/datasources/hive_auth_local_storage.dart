import 'package:digify_hr_system/core/services/hive_service.dart';
import 'package:digify_hr_system/features/auth/data/datasources/auth_local_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';

const String _boxName = 'auth_box';
const String _keyToken = 'auth_token';
const String _keyRememberMe = 'remember_me';
const String _keySavedEmail = 'saved_email';

class HiveAuthLocalStorage implements AuthLocalStorage {
  HiveAuthLocalStorage({Box? box}) : _box = box;

  Box? _box;

  Future<Box> _getBox() async {
    _box ??= await HiveService.openBox(_boxName);
    return _box!;
  }

  @override
  Future<void> saveToken(String token) async {
    final box = await _getBox();
    await box.put(_keyToken, token);
  }

  @override
  Future<String?> getToken() async {
    final box = await _getBox();
    final value = box.get(_keyToken);
    return value is String ? value : null;
  }

  @override
  Future<void> clearToken() async {
    final box = await _getBox();
    await box.delete(_keyToken);
  }

  @override
  Future<bool> getRememberMe() async {
    final box = await _getBox();
    final value = box.get(_keyRememberMe);
    return value == true;
  }

  @override
  Future<void> setRememberMe(bool value) async {
    final box = await _getBox();
    await box.put(_keyRememberMe, value);
  }

  @override
  Future<String?> getSavedEmail() async {
    final box = await _getBox();
    final value = box.get(_keySavedEmail);
    return value is String ? value : null;
  }

  @override
  Future<void> setSavedEmail(String? email) async {
    final box = await _getBox();
    if (email == null || email.isEmpty) {
      await box.delete(_keySavedEmail);
    } else {
      await box.put(_keySavedEmail, email);
    }
  }
}
