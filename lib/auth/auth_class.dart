import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;

  //Sign in with email and password

  Future<AuthResponse> signinWithEmailPassword(
    String email,
    String password,
  ) async {
    return await _supabase.auth.signInWithPassword(
      password: password,
      email: email,
    );
  }

  //Sign up with email and password

  Future<AuthResponse> signUp(
    String email,
    String password,
    String username,
  ) async {
    return await _supabase.auth.signUp(email: email, password: password);
  }

  //signout

  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  //Get email if logged in

  String? getCurrentUserEmail() {
    final session = _supabase.auth.currentSession;
    final user = session?.user;
    return user?.email;
  }
}
