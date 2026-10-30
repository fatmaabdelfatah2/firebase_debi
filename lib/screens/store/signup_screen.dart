// import 'package:firebase_debi/auth_cubit/auth_ccubit.dart';
// import 'package:firebase_debi/auth_cubit/auth_state.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class SignupScreen extends StatelessWidget {
//  const SignupScreen({super.key});


 
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
   
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         centerTitle: true,
//         title: Text(
//           'Sign Up',
//           style: TextStyle(
//             fontSize: 25,
//             fontWeight: FontWeight.w400,
//             color: Color(0xffFF5E00),
//           ),
//         ),
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: Icon(
//             Icons.arrow_back_ios_new_outlined,
//             size: 25,
//             color: Color(0xffFF5E00),
//           ),
//         ),
//       ),
    
//       body: BlocConsumer<AuthCubit, AuthState>(
//         listener: (context, state) {
//           /////-----Success------/////
//           if(state is RegisterSuccess){
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 backgroundColor: Colors.green,
//                 content: Text('Login Success'))
//             );
//           }

//            /////-----Failure------/////
//           if(state is RegisterFailure){
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                  backgroundColor: Colors.red,
//                 content: Text(state.msg))
//             );
//           }
//         },
//         builder: (context, state) {
// /////-----loadingState------/////
// final loadingState =state is RegisterLoading;

// final cubit =BlocProvider.of<AuthCubit>(context);


//           return SingleChildScrollView(
//               child: Padding(
//                 padding: EdgeInsets.all(18),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     Image.asset(
//                       'assets/images/signup_screen.png',
//                       height: 275,
//                     ),
//                     SizedBox(height: 50),
//                     Text(
//                       'Please enter your information to\ncreate an account.',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.w400,
//                         color: Color(0xff6D3805),
//                       ),
//                     ),
//                     SizedBox(height: 15),
//                     TextFormField(
//     controller: cubit.emailRegistercontrol,
//       decoration: InputDecoration(
        
//         hintText: 'Email',
//         hintStyle: const TextStyle(
//           fontWeight: FontWeight.w400,
//           fontSize: 16,
//           color: Color(0xffAC8E71),
//         ),
//         filled: true,
//         fillColor: const Color(0xffF3F3F3),
        
//         enabledBorder: const OutlineInputBorder(
//           borderSide: BorderSide(
//             color: Color(0xffF3F3F3),
//           ),
//         ),
//         disabledBorder: const OutlineInputBorder(
//           borderSide: BorderSide(
//             color: Color(0xffF3F3F3),
//           ),
//         ),
//       ),
     
//     ),
//                     SizedBox(height: 12),

//                      TextFormField(
//     controller: cubit.passwordRegistercontrol,
//       decoration: InputDecoration(
        
//         hintText: 'Password',
//         hintStyle: const TextStyle(
//           fontWeight: FontWeight.w400,
//           fontSize: 16,
//           color: Color(0xffAC8E71),
//         ),
//         filled: true,
//         fillColor: const Color(0xffF3F3F3),
//          suffixIcon: Icon(
//                         Icons.visibility_outlined,
//                         color: Color(0xffFF5E00),
//                       ),
//         enabledBorder: const OutlineInputBorder(
//           borderSide: BorderSide(
//             color: Color(0xffF3F3F3),
//           ),
//         ),
//         disabledBorder: const OutlineInputBorder(
//           borderSide: BorderSide(
//             color: Color(0xffF3F3F3),
//           ),
//         ),
//       ),
     
//     ),
                  
//                     SizedBox(height: 50),

//                     ElevatedButton(
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Color(0xffFF5E00),
//         fixedSize:  Size.fromHeight(50),
//       ),
//       onPressed: (){
// cubit.signUp();
//       },
//       child: 
//       loadingState?Center(
//         child: CircularProgressIndicator(
//           color: Colors.white,
//         ),
//       ):
//       Text(
//           'Sign Up',
//         style: TextStyle(
//           fontSize: 16,
//           fontWeight: FontWeight.w500,
//          color: Colors.white,
//         ),
//       ),
//     ),
                   
//                   ],
//                 ),
//               ),
//             );
//         },
//       ),
//     );
//   }
// }