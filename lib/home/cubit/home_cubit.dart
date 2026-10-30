import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_debi/home/cubit/home_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  ////----======== Object ========-----/////

  final cloud = FirebaseFirestore.instance;

  ////----======== Collection Name ========-----/////

  final String docName = 'Students';

  ////----======== Controllers ========-----/////

  final nameControl = TextEditingController();
  final ageControl = TextEditingController();
  final gradeControl = TextEditingController();

  ////----======== Add Student ========-----/////

  Future<void> addStudentToServer() async {
    emit(HomeLoading());

    try {
      await cloud.collection(docName).add({
        'name': nameControl.text,
        'age': ageControl.text,
        'grade': gradeControl.text,
      });

      emit(AddStudentSuccess());

    } catch (e) {
      emit(HomeFailure(e.toString()));
    }
  }

  ////----======== Get Students ========-----/////

  Future<void> getStudentsFromServer() async {
    emit(HomeLoading());

    try {
      final students = await cloud.collection(docName).get();

      emit(GetStudentSuccess(students.docs));

    } catch (e) {
      emit(HomeFailure(e.toString()));
    }
  }

  ////----======== Edit Student ========-----/////

  Future<void> editStudentFromServer(String id) async {
    emit(HomeLoading());

    try {
      await cloud.collection(docName).doc(id).update({
        'name': nameControl.text,
        'age': ageControl.text,
        'grade': gradeControl.text,
      });

      emit(EditStudentSuccess());

    } catch (e) {
      emit(HomeFailure(e.toString()));
    }
  }

  ////----======== Delete Student ========-----/////

  Future<void> deleteStudentFromServer(String id) async {
    emit(HomeLoading());

    try {
      await cloud.collection(docName).doc(id).delete();

      emit(DeleteStudentSuccess());

    } catch (e) {
      emit(HomeFailure(e.toString()));
    }
  }

  ////----======== Close Controllers ========-----/////

  @override
  Future<void> close() {
    nameControl.dispose();
    ageControl.dispose();
    gradeControl.dispose();

    return super.close();
  }
}