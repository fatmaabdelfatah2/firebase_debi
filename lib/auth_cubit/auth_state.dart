abstract class AuthState {}

/////-------- Initial State ---------/////

class AuthInitial extends AuthState {}

/////-------- Sign Up States ---------/////

class RegisterLoading extends AuthState {}

class RegisterSuccess extends AuthState {}

class RegisterFailure extends AuthState {
  final String msg;

  RegisterFailure(this.msg);
}

/////-------- Login States ---------/////

class LoginLoading extends AuthState {}

class LoginSuccess extends AuthState {}

class LoginFailure extends AuthState {
  final String msg;

  LoginFailure(this.msg);
}

/////-------- Email Verification States ---------/////

class EmailNotVerified extends AuthState {}

class VerifyLoading extends AuthState {}

class VerifySuccess extends AuthState {}

class ResendVerifySuccess extends AuthState {}

class VerifyFailure extends AuthState {
  final String msg;

  VerifyFailure(this.msg);
}