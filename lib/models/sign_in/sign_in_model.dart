import 'package:flutter/material.dart';
import 'package:flutter_final/service/auth_service.dart';

class SignInModel extends ChangeNotifier {
  final AuthService _authService;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  SignInModel(this._authService);

  bool get obscurePassword => _obscurePassword;
  bool get isLoading => _isLoading;

  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void signIn(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter email and password')),
      );
      return;
    }

    _isLoading = true;
    notifyListeners();

    bool success = await _authService.signIn(email, password);

    _isLoading = false;
    notifyListeners();

    if (success) {
      Navigator.pushReplacementNamed(context, '/RaceScreen');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid email or password')),
      );
    }
  }

  void forgotPassword() {
    // You can show a simple message
    // Or navigate to another screen
  }
}
