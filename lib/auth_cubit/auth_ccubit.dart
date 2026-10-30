import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_debi/auth_cubit/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  ////------ Firebase Instances -------////

  final fireAuth = FirebaseAuth.instance;
  final fireStore = FirebaseFirestore.instance;

  ////------ Controllers -------////

  // Sign Up Controllers
  TextEditingController nameRegisterControl = TextEditingController();
  TextEditingController emailRegistercontrol = TextEditingController();
  TextEditingController passwordRegistercontrol = TextEditingController();

  // Login Controllers
  TextEditingController emailLogincontrol = TextEditingController();
  TextEditingController passwordLogincontrol = TextEditingController();

  ////------ Sign Up -------////

  Future<void> register(
    String name,
    String email,
    String password,
  ) async {
    emit(RegisterLoading());

    try {
      // Create a new account using Firebase Authentication
      final data = await fireAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final user = data.user;

      // Check if user was created successfully
      if (user == null) {
        emit(RegisterFailure('Unable to create account'));
        return;
      }

      // Update user's display name
      await user.updateDisplayName(name);

      // Save user information in Cloud Firestore
      await fireStore.collection('Users').doc(user.uid).set({
        'name': name,
        'email': email.trim(),
        'uid': user.uid,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Send email verification
      await user.sendEmailVerification();

      emit(RegisterSuccess());

    } on FirebaseAuthException catch (e) {

      // Handle Firebase Authentication errors
      if (e.code == 'weak-password') {
        emit(RegisterFailure('The password provided is too weak.'));

      } else if (e.code == 'email-already-in-use') {
        emit(RegisterFailure('The account already exists for that email.'));

      } else if (e.code == 'invalid-email') {
        emit(RegisterFailure('The email address is invalid.'));

      } else {
        emit(RegisterFailure(e.message ?? 'Firebase Authentication error'));
      }

    } catch (e) {
      emit(RegisterFailure(e.toString()));
    }
  }

  ////------ Sign In -------////

  Future<void> Login() async {
    emit(LoginLoading());

    try {
      // Sign in using email and password
      final data = await fireAuth.signInWithEmailAndPassword(
        email: emailLogincontrol.text.trim(),
        password: passwordLogincontrol.text,
      );

      final user = data.user;

      // Check if user exists
      if (user == null) {
        emit(LoginFailure('Unable to login'));
        return;
      }

      // Refresh user information
      await user.reload();

      final updatedUser = fireAuth.currentUser;

      // Check email verification status
      if (updatedUser != null && updatedUser.emailVerified) {
        emit(LoginSuccess());
      } else {
        emit(EmailNotVerified());
      }

    } on FirebaseAuthException catch (e) {

      // Handle login errors
      if (e.code == 'user-not-found') {
        emit(LoginFailure('No user found for that email.'));

      } else if (e.code == 'wrong-password') {
        emit(LoginFailure('Wrong password provided for that user.'));

      } else if (e.code == 'invalid-credential') {
        emit(LoginFailure('Password or email is incorrect.'));

      } else {
        emit(LoginFailure(e.message ?? 'Firebase Authentication error'));
      }

    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }

  ////------ Resend Email Verification -------////

  Future<void> resndMailVerifiction() async {
    emit(VerifyLoading());

    try {
      // Get the currently signed-in user
      final user = fireAuth.currentUser;

      if (user == null) {
        emit(VerifyFailure('Please sign in to continue'));
        return;
      }

      // Refresh user information
      await user.reload();

      final updatedUser = fireAuth.currentUser;

      if (updatedUser == null) {
        emit(VerifyFailure('No login data found'));
        return;
      }

      // Check if email is already verified
      if (updatedUser.emailVerified) {
        emit(VerifySuccess());
        return;
      }

      // Send a new verification email
      await updatedUser.sendEmailVerification();

      emit(ResendVerifySuccess());

    } on FirebaseAuthException catch (e) {
      emit(VerifyFailure(e.message ?? e.code));

    } catch (e) {
      emit(VerifyFailure(e.toString()));
    }
  }

  ////------ Check Email Verification -------////

  Future<void> checkEmailVerification() async {
    emit(VerifyLoading());

    try {
      // Get the currently signed-in user
      final user = fireAuth.currentUser;

      if (user == null) {
        emit(VerifyFailure('Please sign in to continue'));
        return;
      }

      // Refresh user information from Firebase
      await user.reload();

      final updatedUser = fireAuth.currentUser;

      if (updatedUser == null) {
        emit(VerifyFailure('No login data found'));
        return;
      }

      // Check if email has been verified
      if (updatedUser.emailVerified) {
        emit(VerifySuccess());
      } else {
        emit(VerifyFailure('Your email is not verified yet'));
      }

    } on FirebaseAuthException catch (e) {
      emit(VerifyFailure(e.message ?? e.code));

    } catch (e) {
      emit(VerifyFailure(e.toString()));
    }
  }

  ////------ Logout -------////

  Future<void> logout() async {
    await fireAuth.signOut();
  }

  ////------ Dispose Controllers -------////

  @override
  Future<void> close() {
    nameRegisterControl.dispose();
    emailRegistercontrol.dispose();
    passwordRegistercontrol.dispose();
    emailLogincontrol.dispose();
    passwordLogincontrol.dispose();

    return super.close();
  }
}