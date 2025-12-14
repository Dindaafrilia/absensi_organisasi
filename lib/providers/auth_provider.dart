// lib/providers/auth_provider.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _service = AuthService();

  Stream<User?> get authStateChanges => _service.authStateChanges();

  Future<String?> signIn(String email, String password) async {
    try {
      await _service.signIn(email, password);
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> register(String email, String password) async {
    try {
      await _service.register(email, password);
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> signOut() => _service.signOut();
}
