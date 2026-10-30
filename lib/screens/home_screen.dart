import 'package:firebase_debi/home/cubit/home_cubit.dart';
import 'package:firebase_debi/home/cubit/home_state.dart';
import 'package:firebase_debi/screens/student_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    // Initialize HomeCubit
    return BlocProvider(
      create: (context) => HomeCubit()..getStudentsFromServer(),
      child: HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    HomeCubit cubit = context.read<HomeCubit>();

    return BlocListener<HomeCubit, HomeState>(
      listener: (context, state) {

        // Handle Add Student Success
        if (state is AddStudentSuccess) {

          // Clear Input Fields
          cubit.nameControl.clear();
          cubit.ageControl.clear();
          cubit.gradeControl.clear();

          // Show Success Message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Student added successfully'),
              backgroundColor: Colors.green,
            ),
          );

          // Navigate to Student List Screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => StudentListScreen(
                cubit: cubit,
              ),
            ),
          );

          // Refresh Students List
          cubit.getStudentsFromServer();
        }

        // Handle Failure State
        if (state is HomeFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.msg),
              backgroundColor: Colors.red,
            ),
          );
        }
      },

      child: Scaffold(
        backgroundColor: Color(0xFFFAF8F6),

        // App Bar
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          centerTitle: true,
          title: Text(
            'Add Your Data',
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFF5E00),
            ),
          ),
         
        ),

        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                SizedBox(height: 10),

                // Add Student Form
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      'Add New Student',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6D3805),
                      ),
                    ),

                    SizedBox(height: 20),

                    // Student Name Field
                    _buildTextField(
                      controller: cubit.nameControl,
                      hint: 'Name',
                  
                    ),

                    SizedBox(height: 15),

                    // Student Age Field
                    _buildTextField(
                      controller: cubit.ageControl,
                      hint: 'Age',
                    
                      keyboardType: TextInputType.number,
                    ),

                    SizedBox(height: 15),

                    // Student Grade Field
                    _buildTextField(
                      controller: cubit.gradeControl,
                      hint: 'Grade',
                      
                    ),

                    SizedBox(height: 20),

                    // Add Student Button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {

                          // Validate Input Fields
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

                          // Add Student to Firestore
                          cubit.addStudentToServer();
                        },

                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFFF5E00),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),

                        child: Text(
                          'Add ',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                          ),
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

  // Custom Text Field
  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
   
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
       
        filled: true,
        fillColor: Color(0xFFFFFAF6),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Color(0xFFF3E5DA),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Color(0xFFF3E5DA),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Color(0xFFFF5E00),
            width: 1.5,
          ),
        ),
      ),
    );
  }
}