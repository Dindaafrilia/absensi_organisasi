import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'providers/member_provider.dart';
import 'providers/attendance_provider.dart';
import 'providers/attendance_report_provider.dart'; // 🔥 WAJIB
import 'screens/auth/login_screen.dart';
import 'screens/home_screen.dart';
import 'providers/attendance_report_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyCu-PLwOxJ38UNLPAZDfgDFQvl7B8hyKcU",
      authDomain: "absensikomunitas-5d028.firebaseapp.com",
      projectId: "absensikomunitas-5d028",
      storageBucket: "absensikomunitas-5d028.firebasestorage.app",
      messagingSenderId: "763390932938",
      appId: "1:763390932938:web:aecf9b11ac672efe8d0133",
      measurementId: "G-25MVDS1VEL",
    ),
  );

  runApp(const MyApp());
}

/// ================= ROOT APP =================
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => MemberProvider()),
        ChangeNotifierProvider(create: (_) => AttendanceProvider()),
        ChangeNotifierProvider(create: (_) => AttendanceReportProvider()), // ✅
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Absensi HMPS-SI 2025',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
          ),
        ),
        home: const AuthGate(),
      ),
    );
  }
}

/// ================= AUTH GATE =================
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return StreamBuilder(
      stream: auth.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData) {
          return const HomeScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
