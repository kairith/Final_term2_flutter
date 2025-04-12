import 'package:flutter_final/models/user.dart';

abstract class AuthRemoteDataSource {
  Future<bool> signIn(User user);
}
