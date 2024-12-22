import 'dart:io';
import 'package:clothes_app/models/models.dart';
import 'package:clothes_app/screens/login_screen.dart';
import 'package:clothes_app/services/auth_services.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  UserModel? _user;

  UserModel? get user => _user;

  Stream<UserModel?> get userStream => _authService.user;

  Future<UserModel?> signUp(String email, String password, String displayName,
      String role, String city, String adress, int postalCode, String birthday,
      {String? code}) async {
    _user = await _authService.signUp(
        email, password, displayName, city, adress, postalCode, birthday,
        code: code);
    notifyListeners();
    return _user;
  }

  Future<UserModel?> signInWithEmail(String email, String password) async {
    _user = await _authService.signInWithEmail(email, password);
  
    notifyListeners();
    return _user;
  }

  Future<UserModel?> signInWithCode(String code) async {
    _user = await _authService.signInWithCode(code);
    notifyListeners();
    return _user;
  }

  Future<void> signOut(BuildContext context) async {
    await _authService.signOut();
    _user = null;
    notifyListeners();

    // Navigate back to the login screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  Future<UserModel?> fetchUserData(String uid) async {
    _user = await _authService.fetchUserData(uid);
    notifyListeners();
    return _user;
  }

  Future<void> updateUser(
    String uid, {
    String? displayName,
    String? email,
    String? profilePictureUrl,
  }) async {
    _user = await _authService.updateUser(
      uid,
      displayName: displayName,
      email: email,
      profilePictureUrl: profilePictureUrl,
    );
    notifyListeners();
  }

  Future<void> updateUserCode(String uid, String code) async {
    await _authService.updateUserCode(uid, code);
    if (_user != null) {
      _user = await _authService.fetchUserData(uid);
      notifyListeners();
    }
  }

  Future<void> updateProfilePicture(String uid, File imageFile) async {
    try {
      String? profilePictureUrl =
          await _authService.uploadProfilePicture(imageFile);

      if (profilePictureUrl != null) {
        await updateUser(uid, profilePictureUrl: profilePictureUrl);
      }
    } catch (e) {
      print('Error updating profile picture: ${e.toString()}');
    }
  }
}
