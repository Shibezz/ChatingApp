import 'package:flutter/material.dart';
import 'package:flutter_application_1/login_page.dart';
import 'package:flutter_application_1/register_page.dart';

class LoginOrRegisterPage extends StatefulWidget {
  const LoginOrRegisterPage({super.key});

  @override
  State<LoginOrRegisterPage> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegisterPage> {
  
  //initially show the login page
  bool showLoginpage=true;

  //toggle between login and register page
  void togglePages(){
    setState(() {
      showLoginpage=!showLoginpage;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    if (showLoginpage){
      return LoginPage(
        onTap: togglePages,
      );
    }else{
      return RegisterPage(
        onTap: togglePages,
      );
    }
  }
}