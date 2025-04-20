import 'package:flutter/material.dart';
import 'package:flutter_final/models/sign_in/sign_in_model.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Consumer<SignInModel>(
              builder: (context, model, _) {
                return Column(
                  children: [
                    Image.asset('assets/images/logo-sport.png', height: 200, width: 200),
                    const SizedBox(height: 24),
                    const Text('Sign In', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    const Text('Please sign in to your account first', style: TextStyle(fontSize: 14, color: Colors.grey)),
                    const SizedBox(height: 24),

                    TextField(
                      controller: model.emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'Email',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        filled: true,
                        fillColor: Colors.grey[100],
                      ),
                    ),
                    const SizedBox(height: 16),

                    TextField(
                      controller: model.passwordController,
                      obscureText: model.obscurePassword,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        suffixIcon: IconButton(
                          icon: Icon(model.obscurePassword ? Icons.visibility_off : Icons.visibility),
                          onPressed: model.togglePasswordVisibility,
                        ),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),

                    const SizedBox(height: 12),

                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: model.forgotPassword,
                        child: const Text('Forgot password?', style: TextStyle(color: Colors.blue)),
                      ),
                    ),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: model.isLoading ? null : () => model.signIn(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.tealAccent[700],
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: model.isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text('Sign In'),
                      ),
                    ),

                    const SizedBox(height: 16),
                    const Text("Or sign in using Social Media.", style: TextStyle(color: Colors.grey)),
                    const SizedBox(height: 12),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: SvgPicture.asset('assets/images/google-logo.svg', height: 36, width: 36),
                          onPressed: () {}, // Add logic if needed
                        ),
                        const SizedBox(width: 24),
                        IconButton(
                          icon: SvgPicture.asset('assets/images/facebook-logo.svg', height: 36, width: 36),
                          onPressed: () {}, // Add logic if needed
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account? "),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/signup');
                          },
                          child: const Text("Sign up.", style: TextStyle(color: Colors.blue)),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
