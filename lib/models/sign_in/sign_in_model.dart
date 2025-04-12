import 'package:flutter/material.dart';
import 'package:flutter_final/service/auth_service.dart';

class SignInModel extends ChangeNotifier {
  final AuthService _authService;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscurePassword = true;

  SignInModel(this._authService);

  bool get obscurePassword => _obscurePassword;

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void signIn(BuildContext context) {
    final email = emailController.text;
    final password = passwordController.text;

    // Call AuthService to perform sign-in
    _authService.signIn(email, password).then((result) {
      // Handle sign-in result, e.g., navigate to another screen or show error
    });
  }

  void forgotPassword() {
    // Handle forgot password logic
  }
}
