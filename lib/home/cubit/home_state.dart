import 'package:cloud_firestore/cloud_firestore.dart';

abstract class HomeState {}

/////------- Initial State -------/////
class HomeInitial extends HomeState {}

/////------- Loading State -------/////
class HomeLoading extends HomeState {}

/////------- Failure State -------/////
class HomeFailure extends HomeState {
  final String msg;

  HomeFailure(this.msg);
}

/////------- Get Students Success -------/////
class GetStudentSuccess extends HomeState {
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> students;

  GetStudentSuccess(this.students);
}

/////------- Add Student Success -------/////
class AddStudentSuccess extends HomeState {}

/////------- Edit Student Success -------/////
class EditStudentSuccess extends HomeState {}

/////------- Delete Student Success -------/////
class DeleteStudentSuccess extends HomeState {}