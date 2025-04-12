class AuthService {
  Future<void> signIn(String email, String password) async {
    if (email != "test@gmail.com" || password != "123456") {
      throw Exception("Invalid credentials");
    }
    // TODO: Implement actual sign-in logic (Firebase, API call)
  }
}
