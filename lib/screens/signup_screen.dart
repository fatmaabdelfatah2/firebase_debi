import 'package:firebase_debi/auth_cubit/auth_ccubit.dart';
import 'package:firebase_debi/auth_cubit/auth_state.dart';
import 'package:firebase_debi/screens/send_email_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupScreen extends StatefulWidget {
  SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // Form key for validation
  final formKey = GlobalKey<FormState>();

  // Password visibility
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
                SizedBox(height: 35),

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
                    'Create Account',
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
                    'Create your account to manage students',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ),

                SizedBox(height: 35),

                // Full Name Field
                _buildLabel('Name'),

                SizedBox(height: 8),

                TextFormField(
                  controller: context.read<AuthCubit>().nameRegisterControl,
                  decoration: _buildInputDecoration(
                    hint: 'Enter your name',
                    icon: Icons.person_outline,
                  ),

                  // Validate name
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 20),

                // Email Field
                _buildLabel('Email'),

                SizedBox(height: 8),

                TextFormField(
                  controller: context.read<AuthCubit>().emailRegistercontrol,
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

                // Password Field
                _buildLabel('Password'),

                SizedBox(height: 8),

                TextFormField(
                  controller: context.read<AuthCubit>().passwordRegistercontrol,
                  obscureText: !isPasswordVisible,
                  decoration: _buildInputDecoration(
                    hint: 'Enter your password',
                    icon: Icons.lock_outline,
                  ).copyWith(
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

                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }

                    return null;
                  },
                ),

                SizedBox(height: 30),

                // Register Button and Authentication States
                BlocConsumer<AuthCubit, AuthState>(
                  listener: (context, state) {
                    // Navigate to email verification screen
                    if (state is RegisterSuccess) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SendEmailScreen(),
                        ),
                      );
                    }

                    // Show registration error
                    if (state is RegisterFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(state.msg),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    // Check registration loading state
                    bool isLoading = state is RegisterLoading;

                    return SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () {
                                // Validate form before registration
                                if (formKey.currentState!.validate()) {
                                  context.read<AuthCubit>().register(
                                        context
                                            .read<AuthCubit>()
                                            .nameRegisterControl
                                            .text
                                            .trim(),
                                        context
                                            .read<AuthCubit>()
                                            .emailRegistercontrol
                                            .text
                                            .trim(),
                                        context
                                            .read<AuthCubit>()
                                            .passwordRegistercontrol
                                            .text,
                                      );
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
                                'Create Account',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    );
                  },
                ),

                SizedBox(height: 20),

                // Navigate to Login Screen
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Already have an account?'),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Sign In',
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