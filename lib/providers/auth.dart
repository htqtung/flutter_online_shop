import 'dart:convert';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _tokenExpDate;
  String _userId;
  Timer _authTimer;

  bool get isAuthenticated {
    return token != null;
  }

  String get token {
    if (_tokenExpDate != null &&
        _tokenExpDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyA_w4ENT6rlk8cSPLjWlRt1SEPPDk-1X_I';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _tokenExpDate = DateTime.now().add(Duration(
        seconds: int.parse(
          responseData['expiresIn'],
        ),
      ));
      _autoSignOut();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _tokenExpDate.toIso8601String(),
      });
      prefs.setString('userData', userData);
    } catch (error) {
      throw error;
    }
  }

  Future<void> signUp(String email, String password) async {
    // The future that is returned by _authenticate is the future that waits
    // for the http request, so we need to return that one, not the future of signUp()
    return _authenticate(email, password, 'signUp');
  }

  Future<void> signIn(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<bool> tryAutoSignIn() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }

    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);
    if (DateTime.now().isAfter(expiryDate)) {
      return false;
    }
    // After all the checks, the token is valid and can be used
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _tokenExpDate = expiryDate;
    _autoSignOut();
    notifyListeners();
    return true;
  }

  Future<void> clearLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    // * remove a certain key - value pair
    // prefs.remove('userData');

    // * clear all data in the local storage
    prefs.clear();
  }

  void signOut() async {
    _token = null;
    _userId = null;
    _tokenExpDate = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    notifyListeners();
    clearLocalStorage();
  }

  void _autoSignOut() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeTillTokenExpires =
        _tokenExpDate.difference(DateTime.now()).inSeconds;

    _authTimer = Timer(Duration(seconds: timeTillTokenExpires), signOut);
  }
}
