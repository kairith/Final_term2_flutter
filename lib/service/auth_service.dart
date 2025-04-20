class AuthService {
  // Dummy login check
  Future<bool> signIn(String email, String password) async {
    await Future.delayed(const Duration(seconds: 2)); // simulate network delay
    return email == "admin@gmail.com" && password == "admin123";
  }
}
