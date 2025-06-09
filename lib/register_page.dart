import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/components/my_button.dart';
import 'package:flutter_application_1/components/square_tile.dart';
import 'package:flutter_application_1/components/textfield.dart';
import 'package:flutter_application_1/services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key,required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmpasswordController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

 //Sign Up the User
void signUserUp() async {
  final email = emailController.text.trim();
  final password = passwordController.text.trim();
  final confirmPassword = confirmpasswordController.text.trim();

  // Basic validations before calling Firebase
  if (email.isEmpty || !email.contains('@')) {
    _showErrorDialog('Please enter a valid email address.');
    return;
  }
  if (password.length < 6) {
    _showErrorDialog('Password must be at least 6 characters long.');
    return;
  }
  if (password != confirmPassword) {
    _showErrorDialog('Passwords don\'t match!');
    return;
  }

  try {
    // Just attempt to create the user directly
    UserCredential userCredential=
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    _firestore.collection('users').doc(userCredential.user!.uid).set({
      'uid':userCredential.user!.uid,
      'email': email,
    }
    );

    // Success: navigate or show success message here

  } on FirebaseAuthException catch (e) {
    print('Firebase Auth Error code: ${e.code}');
    print('Firebase Auth Error message: ${e.message}');
    switch (e.code) {
      case 'invalid-email':
        _showErrorDialog('The email address is badly formatted.');
        break;
      case 'email-already-in-use':
        // This error happens if email is registered already
        _showErrorDialog('This email is already registered. Please sign in instead.');
        break;
      case 'user-disabled':
        _showErrorDialog('This user account has been disabled.');
        break;
      default:
        _showErrorDialog('Sign up failed. Please try again.');
        break;
    }
  } catch (e) {
    _showErrorDialog('Unexpected error: ${e.toString()}');
  }
}





void _showErrorDialog(String message) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Error'),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('OK'),
        ),
      ],
    ),
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 30),
                const Icon(
                  Icons.lock,
                  size: 100,
                ),
                const SizedBox(height: 50),
                Text(
                  'Let\'s create an account for you!',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),

                //Username text field
                MyTextField(
                    controller: emailController,
                    hintText: 'Email-ID',
                    obscureText: false),
                const SizedBox(
                  height: 8,
                ),

                //Password text field
                MyTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: true),
                const SizedBox(
                  height: 8,
                ),
                
                //Confirm Password text field
                MyTextField(
                    controller: confirmpasswordController,
                    hintText: 'Confirm Password',
                    obscureText: true),
                

                const SizedBox(
                  height: 25,
                ),
                MyButton(
                  text:'Sign Up',
                  onTap: signUserUp,
                ),
                const SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[20],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'Or Continue with',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[20],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SquareTile(
                      //Google
                       onTap: ()=>AuthService().signInWithGoogle(),
                      imagePath: 'lib/images/google.png'),


                    const SizedBox(width: 10),

                    //Apple
                    SquareTile(
                      onTap: (){},
                      imagePath: 'lib/images/apple.png')
                  ],
                ),
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Already have an account?'),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text('Login Now',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
