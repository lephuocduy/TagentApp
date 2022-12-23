import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../models/entity/applicant.dart';

class ApplicantPreferences {
  static late SharedPreferences _preferences;

  static const _keyApplicant = 'applicant';
  static const _keyCurrentIndexProfile= 'profileApplicant';
  static const _keyToken = 'token';
  static const _keyInitScreen = 'initScreen';

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setUser(Applicant applicant) async {
    final json = jsonEncode(applicant.toJson());

    await _preferences.setString(_keyApplicant, json);
  }

  static Applicant getUser(Applicant applicant) {
    final json = _preferences.getString(_keyApplicant);
    return json == null ? applicant : Applicant.fromJson(jsonDecode(json));
  }

    static Future setCurrentIndexProfile(int id) async {
    await _preferences.setInt(_keyCurrentIndexProfile, id);
  }

  static int getCurrentIndexProfileId(int id) {
    final json = _preferences.getInt(_keyCurrentIndexProfile);
    return json ?? id;
  }

  static Future setToken(String token) async {
    await _preferences.setString(_keyToken, token);
  }

  static String getToken(String token) {
    final json = _preferences.getString(_keyToken);
    return json ?? token;
  }

  static Future setInitScreen(int initScreen) async {
    await _preferences.setInt(_keyInitScreen, initScreen);
  }

  static int getInitScreen(int initScreen) {
    final json = _preferences.getInt(_keyInitScreen);
    return json ?? initScreen;
  }

  static void clear() async {
    await _preferences.clear();
    await setInitScreen(1);
  }
}
