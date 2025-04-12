import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_final/models/sign_in/sign_in_model.dart';
import 'package:flutter_final/service/auth_service.dart';
import 'package:flutter_final/screens/auth/sign_in_screen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),  // Provide AuthService
        ChangeNotifierProvider<SignInModel>(  // Provide SignInModel with AuthService dependency
          create: (context) => SignInModel(context.read<AuthService>()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Sign In',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const SignInScreen(),
      ),
    );
  }
}
