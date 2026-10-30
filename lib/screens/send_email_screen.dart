import 'package:firebase_debi/auth_cubit/auth_ccubit.dart';
import 'package:firebase_debi/auth_cubit/auth_state.dart';
import 'package:firebase_debi/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SendEmailScreen extends StatelessWidget {
  const SendEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {

    // Get the current authenticated user email
    final email = context.read<AuthCubit>().fireAuth.currentUser?.email ?? '';

    return Scaffold(
      backgroundColor: Colors.white,

      // App Bar
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFFFF6900),
          ),
        ),
        title: const Text(
          'Verify Your Email',
          style: TextStyle(
            color: Color(0xFFFF6900),
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      // Listen to email verification states
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {

          // Navigate to HomeScreen after successful verification
          if (state is VerifySuccess) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => HomeScreen(),
              ),
              (route) => false,
            );
          }

          // Show success message when verification email is resent
          if (state is ResendVerifySuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Verification email sent successfully. Please check your email.',
                ),
                backgroundColor: Colors.green,
              ),
            );
          }

          // Show error message
          if (state is VerifyFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.red,
                content: Text(state.msg),
              ),
            );
          }
        },

        builder: (context, state) {

          // Check if verification request is loading
          final bool isLoading = state is VerifyLoading;

          final AuthCubit cubit = context.read<AuthCubit>();

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  const SizedBox(height: 40),

                  // Email Illustration
                  Container(
                    height: 240,
                    width: 240,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFF5EB),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.mark_email_unread_outlined,
                      size: 130,
                      color: Color(0xFFFF6900),
                    ),
                  ),

                  const SizedBox(height: 35),

                  // Screen Title
                  const Text(
                    'Check Your Email',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF572000),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Screen Description
                  const Text(
                    'We have sent a verification link to your email address. '
                    'Please check your inbox and click the link to verify your account.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 17,
                      height: 1.6,
                      color: Color(0xFF79452E),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Display User Email
                  TextFormField(
                    initialValue: email,
                    readOnly: true,
                    decoration: InputDecoration(
                      hintText: 'Your email address',
                      hintStyle: const TextStyle(
                        color: Color(0xFF906F60),
                        fontSize: 16,
                      ),
                      prefixIcon: const Icon(
                        Icons.mail_outline,
                        color: Color(0xFFFF6900),
                        size: 28,
                      ),
                      filled: true,
                      fillColor: const Color(0xFFFFF7F0),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 24,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Resend Verification Email Button
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF6900),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),

                      // Disable button while loading
                      onPressed: isLoading
                          ? null
                          : () {
                              cubit.resndMailVerifiction();
                            },

                      // Show loading or button text
                      child: isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text(
                              'Resend Verification Email',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Check Email Verification Button
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFFF6900),
                        side: const BorderSide(
                          color: Color(0xFFFF6900),
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),

                      // Check whether the email has been verified
                      onPressed: isLoading
                          ? null
                          : () {
                              cubit.checkEmailVerification();
                            },

                      child: const Text(
                        'I Verified My Email',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Back To Login
                  TextButton(
                    onPressed: () async {

                      // Sign out before returning to login
                      await cubit.logout();

                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    },
                    child: const Text(
                      'Back to Login',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF906F60),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}