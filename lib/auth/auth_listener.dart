import 'package:bytespace/pages/notes_page.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:bytespace/pages/login_page.dart';
import 'package:bytespace/pages/notes_page.dart';

class AuthListener extends StatelessWidget {
  const AuthListener({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      //list to auth state change
      stream: Supabase.instance.client.auth.onAuthStateChange,
      //content to be changed
      builder: (context, snapshot) {
        //loading or waiting
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        // final session = snapshot.data?.session;
        final session =
            snapshot.data?.session ??
            Supabase.instance.client.auth.currentSession;
        if (session != null) {
          return NotesPage(); //Notes Page
        } else {
          return LoginPage(); //Login Page
        }
      },
    );
  }
}
