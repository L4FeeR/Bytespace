import 'package:flutter/material.dart';
import 'package:bytespace/auth/auth_class.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  //auth class
  final authService = AuthService();

  //controller
  final _emailController = new TextEditingController();
  final _passwordController = new TextEditingController();
  final _confirmPasswordController = new TextEditingController();
  final _usernameController = new TextEditingController();

  Future<void> signup() async {
    //prepare data
    final email = _emailController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;
    final username = _usernameController.text;
    //checking password match
    if (password != confirmPassword) {
      AlertDialog(
        title: Text("Error"),
        content: Text("Password Mismatch! "),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Ok"),
          ),
        ],
      );
    }
    //attempting to sign up
    try {
      await authService.signUp(
        email,
        password,
        username,
      ); //passing username, but not done anything with it!
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Signup Failed!"),
            content: Text("Error: $e"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text("Try Again"),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          children: [
            SizedBox(height: 50),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: "Username"),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: "Password"),
              onSubmitted: (value) async {
                await signup();
              },
            ),
            SizedBox(height: 10),
            ElevatedButton(onPressed: signup, child: Text("Signup")),
            SizedBox(height: 30),
            Row(
              children: [
                Text("Have an account? "),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Login"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
