import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/member_provider.dart';


class MemberFormScreen extends StatefulWidget {
  @override
  State<MemberFormScreen> createState() => _MemberFormScreenState();
}

class _MemberFormScreenState extends State<MemberFormScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _roleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final memberProvider = Provider.of<MemberProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: Text('Tambah Anggota')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nama'),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _roleController,
              decoration: InputDecoration(labelText: 'Role (anggota/ketua)'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await memberProvider.addMember(
                  _nameController.text,
                  _emailController.text,
                  _roleController.text,
                );
                Navigator.pop(context); // balik ke list
              },
              child: Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
