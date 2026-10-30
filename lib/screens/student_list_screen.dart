import 'package:firebase_debi/home/cubit/home_cubit.dart';
import 'package:firebase_debi/home/cubit/home_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentListScreen extends StatelessWidget {
  final HomeCubit cubit;

  const StudentListScreen({
    super.key,
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: cubit,
      child: StudentListView(cubit: cubit),
    );
  }
}

class StudentListView extends StatelessWidget {
  final HomeCubit cubit;

  const StudentListView({
    super.key,
    required this.cubit,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFF8FC),

      // App Bar
      appBar: AppBar(
        backgroundColor: Color(0xFFFF9800),
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        title: Text(
          'All Students',
          style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),

      // Students List
      body: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {

          // Handle Edit Success
          if (state is EditStudentSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Student updated successfully'),
                backgroundColor: Colors.green,
              ),
            );

            cubit.getStudentsFromServer();
          }

          // Handle Delete Success
          if (state is DeleteStudentSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Student deleted successfully'),
                backgroundColor: Colors.green,
              ),
            );

            cubit.getStudentsFromServer();
          }

          // Handle Failure
          if (state is HomeFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.msg),
                backgroundColor: Colors.red,
              ),
            );
          }
        },

        builder: (context, state) {

          // Loading
          if (state is HomeLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: Color(0xFFFF9800),
              ),
            );
          }

          // Display Students
          if (state is GetStudentSuccess) {

            // Empty List
            if (state.students.isEmpty) {
              return Center(
                child: Text(
                  'No students found',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              );
            }

            return ListView.separated(
              itemCount: state.students.length,

              separatorBuilder: (context, index) {
                return Divider(
                  height: 1,
                  thickness: 1,
                  color: Colors.grey.shade300,
                );
              },

              itemBuilder: (context, index) {

                // Get Current Student
                var student = state.students[index];

                return Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),

                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      // Student Information
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Text(
                              'Name : ${student['name'] ?? ''}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),

                            Text(
                              'Age : ${student['age'] ?? ''}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),

                            Text(
                              'Grade : ${student['grade'] ?? ''}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // More Options Menu
                      PopupMenuButton<String>(
                        icon: Icon(
                          Icons.more_vert,
                          color: Colors.black54,
                        ),

                        onSelected: (value) {

                          // Edit Student
                          if (value == 'edit') {
                            cubit.nameControl.text =
                                student['name'] ?? '';

                            cubit.ageControl.text =
                                student['age'].toString();

                            cubit.gradeControl.text =
                                student['grade'] ?? '';

                            _showEditDialog(
                              context,
                              cubit,
                              student.id,
                            );
                          }

                          // Delete Student
                          if (value == 'delete') {
                            _showDeleteDialog(
                              context,
                              cubit,
                              student.id,
                            );
                          }
                        },

                        itemBuilder: (context) => [

                          PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.edit_outlined,
                                  color: Colors.blue,
                                ),
                                SizedBox(width: 10),
                                Text('Edit'),
                              ],
                            ),
                          ),

                          PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(
                                  Icons.delete_outline,
                                  color: Colors.red,
                                ),
                                SizedBox(width: 10),
                                Text('Delete'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          }

          // Error State
          if (state is HomeFailure) {
            return Center(
              child: Text('Something went wrong'),
            );
          }

          return SizedBox();
        },
      ),

      // Add Student Button
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFFFF9800),
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.pop(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  // Edit Student Dialog
  void _showEditDialog(
    BuildContext context,
    HomeCubit cubit,
    String studentId,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('Edit Student'),

          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              TextField(
                controller: cubit.nameControl,
                decoration: InputDecoration(
                  labelText: 'Name',
                ),
              ),

              TextField(
                controller: cubit.ageControl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Age',
                ),
              ),

              TextField(
                controller: cubit.gradeControl,
                decoration: InputDecoration(
                  labelText: 'Grade',
                ),
              ),
            ],
          ),

          actions: [

            // Cancel Button
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: Text('Cancel'),
            ),

            // Update Button
            ElevatedButton(
              onPressed: () {

                // Validate Fields
                if (cubit.nameControl.text.trim().isEmpty ||
                    cubit.ageControl.text.trim().isEmpty ||
                    cubit.gradeControl.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Please fill all fields'),
                      backgroundColor: Colors.orange,
                    ),
                  );

                  return;
                }

                // Update Student in Firestore
                cubit.editStudentFromServer(studentId);

                Navigator.pop(dialogContext);
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  // Delete Confirmation Dialog
  void _showDeleteDialog(
    BuildContext context,
    HomeCubit cubit,
    String studentId,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('Delete Student'),

          content: Text(
            'Are you sure you want to delete this student?',
          ),

          actions: [

            // Cancel Button
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: Text('Cancel'),
            ),

            // Delete Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                cubit.deleteStudentFromServer(studentId);

                Navigator.pop(dialogContext);
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}