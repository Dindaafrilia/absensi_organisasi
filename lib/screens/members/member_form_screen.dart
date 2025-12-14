import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/member_provider.dart';

class MemberFormScreen extends StatefulWidget {
  const MemberFormScreen({super.key});

  @override
  State<MemberFormScreen> createState() => _MemberFormScreenState();
}

class _MemberFormScreenState extends State<MemberFormScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  int _selectedRole = 4; // default Anggota

  @override
  Widget build(BuildContext context) {
    final memberProvider = Provider.of<MemberProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Anggota')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nama'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 12),

            // ===== DROPDOWN ROLE =====
            DropdownButtonFormField<int>(
              value: _selectedRole,
              decoration: const InputDecoration(labelText: 'Role'),
              items: const [
                DropdownMenuItem(value: 1, child: Text('Ketua')),
                DropdownMenuItem(value: 2, child: Text('Sekretaris')),
                DropdownMenuItem(value: 3, child: Text('Bendahara')),
                DropdownMenuItem(value: 4, child: Text('Anggota')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedRole = value!;
                });
              },
            ),

            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: () async {
                await memberProvider.addMember(
                  _nameController.text.trim(),
                  _emailController.text.trim(),
                  _selectedRole, // ✅ INT
                );

                if (!mounted) return;
                Navigator.pop(context);
              },
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
