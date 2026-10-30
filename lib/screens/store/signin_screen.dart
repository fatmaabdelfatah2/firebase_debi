// import 'package:firebase_debi/auth_cubit/auth_ccubit.dart';
// import 'package:firebase_debi/auth_cubit/auth_state.dart';
// import 'package:firebase_debi/screens/store/send_email_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import 'signup_screen.dart';

// class SigninScreen extends StatelessWidget {
//   const SigninScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,

//       // App Bar
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         centerTitle: true,
//         elevation: 0,
//         surfaceTintColor: Colors.transparent,
//         title: const Text(
//           'Sign In',
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
//           icon: const Icon(
//             Icons.arrow_back_ios_new_outlined,
//             size: 25,
//             color: Color(0xffFF5E00),
//           ),
//         ),
//       ),

//       // Screen Body
//       body: BlocConsumer<AuthCubit, AuthState>(
//         listener: (context, state) {
//           // Login Success
//           if (state is LoginSuccess) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(
//                 backgroundColor: Colors.green,
//                 content: Text('Login Success'),
//               ),
//             );
//           }

//           // Login Failure
//           if (state is LoginFailure) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                 backgroundColor: Colors.red,
//                 content: Text(state.msg),
//               ),
//             );
//           }

//           // Email Not Verified
//           if (state is emailNotVerified) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(
//                 backgroundColor: Colors.orange,
//                 content: Text(
//                   'Your email is not verified yet. '
//                   'Please verify your email.',
//                 ),
//                 duration: Duration(seconds: 3),
//               ),
//             );

//             // Navigate to SendEmailScreen
//             Navigator.of(context).push(
//               MaterialPageRoute(
//                 builder: (_) => BlocProvider.value(
//                   value: context.read<AuthCubit>(),
//                   child: const SendEmailScreen(),
//                 ),
//               ),
//             );
//           }
//         },

//         builder: (context, state) {
//           // Loading State
//           final bool isLoading = state is LoginLoading;

//           final AuthCubit cubit = context.read<AuthCubit>();

//           return SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.all(18),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   // Sign In Image
//                   Image.asset(
//                     'assets/images/signin_screen.png',
//                     height: 275,
//                   ),

//                   const SizedBox(height: 50),

//                   // Description
//                   const Text(
//                     'Enter your Email and\npassword to access your account',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.w400,
//                       color: Color(0xff6D3805),
//                     ),
//                   ),

//                   const SizedBox(height: 15),

//                   // Email Field
//                   TextFormField(
//                     controller: cubit.emailLogincontrol,
//                     keyboardType: TextInputType.emailAddress,
//                     decoration: const InputDecoration(
//                       hintText: 'Email',
//                       hintStyle: TextStyle(
//                         fontWeight: FontWeight.w400,
//                         fontSize: 16,
//                         color: Color(0xffAC8E71),
//                       ),
//                       filled: true,
//                       fillColor: Color(0xffF3F3F3),
//                       enabledBorder: OutlineInputBorder(
//                         borderSide: BorderSide(
//                           color: Color(0xffF3F3F3),
//                         ),
//                       ),
//                       disabledBorder: OutlineInputBorder(
//                         borderSide: BorderSide(
//                           color: Color(0xffF3F3F3),
//                         ),
//                       ),
//                     ),
//                   ),

//                   const SizedBox(height: 12),

//                   // Password Field
//                   TextFormField(
//                     controller: cubit.passwordLogincontrol,
//                     obscureText: true,
//                     decoration: const InputDecoration(
//                       hintText: 'Password',
//                       hintStyle: TextStyle(
//                         fontWeight: FontWeight.w400,
//                         fontSize: 16,
//                         color: Color(0xffAC8E71),
//                       ),
//                       filled: true,
//                       fillColor: Color(0xffF3F3F3),
//                       suffixIcon: Icon(
//                         Icons.visibility_outlined,
//                         color: Color(0xffFF5E00),
//                       ),
//                       enabledBorder: OutlineInputBorder(
//                         borderSide: BorderSide(
//                           color: Color(0xffF3F3F3),
//                         ),
//                       ),
//                       disabledBorder: OutlineInputBorder(
//                         borderSide: BorderSide(
//                           color: Color(0xffF3F3F3),
//                         ),
//                       ),
//                     ),
//                   ),

//                   const SizedBox(height: 50),

//                   // Login Button
//                   SizedBox(
//                     height: 50,
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xffFF5E00),
//                         foregroundColor: Colors.white,
//                         elevation: 0,
//                       ),

//                       // Disable Button While Loading
//                       onPressed: isLoading
//                           ? null
//                           : () {
//                               cubit.Login();
//                             },

//                       // Loading Indicator or Button Text
//                       child: isLoading
//                           ? const SizedBox(
//                               height: 24,
//                               width: 24,
//                               child: CircularProgressIndicator(
//                                 color: Colors.white,
//                                 strokeWidth: 2.5,
//                               ),
//                             )
//                           : const Text(
//                               'Login',
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w500,
//                                 color: Colors.white,
//                               ),
//                             ),
//                     ),
//                   ),

//                   const SizedBox(height: 20),

//                   // Navigate to Sign Up
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const Text(
//                         'Don’t have an account? ',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w400,
//                           color: Color(0xff6D3805),
//                         ),
//                       ),

//                       GestureDetector(
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => SignupScreen(),
//                             ),
//                           );
//                         },
//                         child: const Text(
//                           'Sign Up',
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.w400,
//                             color: Color(0xffFF5E00),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),

//                   const SizedBox(height: 20),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }