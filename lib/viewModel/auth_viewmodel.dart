import 'package:flutter/foundation.dart';
import '../service/auth_service.dart';
import '../model/user.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  AppUser? _currentUser;

  AppUser? get currentUser => _currentUser;

  Future<bool> register(String name, String email, String password, String role,
      String phoneNumber) async {
    try {
      final user =
          await _authService.register(name, email, password, role, phoneNumber);
      if (user != null) {
        _currentUser = AppUser(
            id: user.uid,
            name: name,
            email: email,
            role: role,
            phoneNumber: phoneNumber);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<bool> signIn(String email, String password) async {
    try {
      final user = await _authService.signIn(email, password);
      if (user != null) {
        // Fetch user details from Firestore
        _currentUser = await _authService.getAppUser(user.uid);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _currentUser = null;
    notifyListeners();
  }
}
