import 'package:flutter/material.dart';
import 'package:flutter_final/models/sign_in/sign_in_model.dart';
import 'package:flutter_svg/svg.dart';
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
                    const Text(
                      'Sign In',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Please sign in to your account first',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    const SizedBox(height: 24),

                    // Email TextField
                    TextField(
                      controller: model.emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Password TextField
                    TextField(
                      controller: model.passwordController,
                      obscureText: model.obscurePassword,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        suffixIcon: IconButton(
                          icon: Icon(
                            model.obscurePassword ? Icons.visibility_off : Icons.visibility,
                          ),
                          onPressed: model.togglePasswordVisibility,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Forgot Password
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: model.forgotPassword,
                        child: const Text(
                          'Forgot password?',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ),

                    // Sign In Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => model.signIn(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.tealAccent[700],
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Sign In'),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Social media
                    const Text("Or sign in using Social Media.", style: TextStyle(color: Colors.grey)),
                    const SizedBox(height: 12),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Google Sign-In
                        IconButton(
                          icon: SvgPicture.asset('assets/images/google-logo.svg', height: 36, width: 36),
                          onPressed: () => {}, // Call your sign-in logic
                        ),
                        const SizedBox(width: 24),

                        // Facebook Sign-In
                        IconButton(
                          icon: SvgPicture.asset('assets/images/facebook-logo.svg', height: 36, width: 36),
                          onPressed: () => {}, // Call your sign-in logic
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    
                    // Sign up
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account? "),
                        GestureDetector(
                          onTap: () {
                            // Navigate to Sign Up
                          },
                          child: const Text(
                            "Sign up.",
                            style: TextStyle(color: Colors.blue),
                          ),
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
