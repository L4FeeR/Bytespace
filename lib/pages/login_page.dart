import 'package:flutter/material.dart';
import 'package:bytespace/auth/auth_class.dart';
import 'package:bytespace/pages/signup_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //authservice class
  final authservice = AuthService();

  //controller
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  //login
  Future<void> login() async {
    final email = emailController.text;
    final password = passwordController.text;
    try {
      await authservice.signinWithEmailPassword(email, password);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error : $e")));
      }
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
              controller: emailController,
              decoration: InputDecoration(labelText: "Username"),
            ),
            SizedBox(height: 10),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: "Password"),
              onSubmitted: (value) async {
                await login();
              },
            ),
            SizedBox(height: 10),
            ElevatedButton(onPressed: login, child: Text("Login")),
            SizedBox(height: 30),
            Row(
              children: [
                Text("Don't have an account? "),
                ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (contex) => SignupPage()),
                  ),
                  child: Text("Signup"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
