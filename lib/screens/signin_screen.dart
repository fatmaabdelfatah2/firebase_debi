import 'package:firebase_debi/auth_cubit/auth_ccubit.dart';
import 'package:firebase_debi/auth_cubit/auth_state.dart';
import 'package:firebase_debi/screens/home_screen.dart';
import 'package:firebase_debi/screens/send_email_screen.dart';
import 'package:firebase_debi/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SigninScreen extends StatefulWidget {
 const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {

  // Form key for validation
  final formKey = GlobalKey<FormState>();

  // Control password visibility
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF8F3),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),

          child: Form(
            key: formKey,

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                SizedBox(height: 60),

                // App Logo
                Center(
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Color(0xFFFF5E00),
                    child: Icon(
                      Icons.school,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),

                SizedBox(height: 25),

                // Screen Title
                Center(
                  child: Text(
                    'Welcome Back!',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6D3805),
                    ),
                  ),
                ),

                SizedBox(height: 10),

                // Screen Description
                Center(
                  child: Text(
                    'Sign in to continue managing your students',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ),

                SizedBox(height: 45),

                // Email Label
                _buildLabel('Email'),

                SizedBox(height: 8),

                // Email Field
                TextFormField(
                  controller: context.read<AuthCubit>().emailLogincontrol,
                  keyboardType: TextInputType.emailAddress,
                  decoration: _buildInputDecoration(
                    hint: 'Enter your email',
                    icon: Icons.email_outlined,
                  ),

                  // Validate email
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your email';
                    }

                    if (!value.contains('@')) {
                      return 'Please enter a valid email';
                    }

                    return null;
                  },
                ),

                SizedBox(height: 20),

                // Password Label
                _buildLabel('Password'),

                SizedBox(height: 8),

                // Password Field
                TextFormField(
                  controller: context.read<AuthCubit>().passwordLogincontrol,
                  obscureText: !isPasswordVisible,
                  decoration: _buildInputDecoration(
                    hint: 'Enter your password',
                    icon: Icons.lock_outline,
                  ).copyWith(

                    // Show or hide password
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isPasswordVisible = !isPasswordVisible;
                        });
                      },
                      icon: Icon(
                        isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                    ),
                  ),

                  // Validate password
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }

                    return null;
                  },
                ),

                SizedBox(height: 10),

                // Forgot Password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // Forgot password will be implemented later
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Forgot Password coming soon'),
                        ),
                      );
                    },
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: Color(0xFFFF5E00),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 25),

                // Login Button and Authentication States
                BlocConsumer<AuthCubit, AuthState>(
                  listener: (context, state) {

                    // Navigate to Home Screen after successful login
                    if (state is LoginSuccess) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeScreen(),
                        ),
                      );
                    }

                    // Navigate to Email Verification Screen
                    if (state is EmailNotVerified) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SendEmailScreen(),
                        ),
                      );
                    }

                    // Show login error
                    if (state is LoginFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.msg),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },

                  builder: (context, state) {

                    // Check login loading state
                    bool isLoading = state is LoginLoading;

                    return SizedBox(
                      width: double.infinity,
                      height: 55,

                      child: ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () {
                                // Validate form before login
                                if (formKey.currentState!.validate()) {
                                  context.read<AuthCubit>().Login();
                                }
                              },

                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFFF5E00),
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: Colors.orange.shade200,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),

                        child: isLoading
                            ? CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                'Sign In',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    );
                  },
                ),

                SizedBox(height: 25),

                // Navigate to Sign Up Screen
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account?"),

                    TextButton(
                      onPressed: () {
                     Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => SignupScreen(),
  ),
);  },
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Color(0xFFFF5E00),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Build reusable label
  Widget _buildLabel(String title) {
    return Text(
      title,
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 15,
      ),
    );
  }

  // Build reusable text field decoration
  InputDecoration _buildInputDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: Color(0xFFFF5E00),
          width: 1.5,
        ),
      ),
    );
  }
}