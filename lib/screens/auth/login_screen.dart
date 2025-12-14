// lib/screens/auth/login_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import 'register_screen.dart';



class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtl = TextEditingController();
  final _passCtl = TextEditingController();
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _emailCtl, decoration: InputDecoration(labelText: 'Email')),
            
            TextField(controller: _passCtl, decoration: InputDecoration(labelText: 'Password'), obscureText: true),
            SizedBox(height: 16),
            _loading ? CircularProgressIndicator() : ElevatedButton(
              onPressed: () async {
                setState(() => _loading = true);
                final err = await auth.signIn(_emailCtl.text.trim(), _passCtl.text.trim());
                setState(() => _loading = false);
                if (err != null) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
                }
              },
              child: Text('Login'),
            ),
            TextButton(onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => RegisterScreen()));
            }, child: Text('Daftar baru'))
          ],
        ),
      ),
    );
  }
}

