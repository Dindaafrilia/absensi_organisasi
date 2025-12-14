import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/member_provider.dart';
import 'member_form_screen.dart';

class MembersListScreen extends StatefulWidget {
  const MembersListScreen({super.key});

  @override
  State<MembersListScreen> createState() => _MembersListScreenState();
}

class _MembersListScreenState extends State<MembersListScreen> {
  @override
  void initState() {
    super.initState();

    // aman dipanggil setelah build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MemberProvider>(context, listen: false).fetchMembers();
    });
  }

  // ✅ KONVERSI ROLE NUMBER → NAMA
  String getRoleName(int role) {
    switch (role) {
      case 1:
        return 'Ketua';
      case 2:
        return 'Sekretaris';
      case 3:
        return 'Bendahara';
      default:
        return 'Anggota';
    }
  }

  @override
  Widget build(BuildContext context) {
    final memberProvider = Provider.of<MemberProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Anggota'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            tooltip: 'Tambah Anggota',
            onPressed: () async {
              // buka form
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const MemberFormScreen(),
                ),
              );

              // 🔄 PASTI REFRESH SETELAH BALIK
              if (!mounted) return;
              await Provider.of<MemberProvider>(
                context,
                listen: false,
              ).fetchMembers();
            },
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Data Anggota',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 4),
            Text(
              'Tekan lama pada anggota untuk menghapus',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),

            Expanded(
              child: memberProvider.members.isEmpty
                  ? const Center(
                      child: Text('Belum ada anggota'),
                    )
                  : ListView.builder(
                      itemCount: memberProvider.members.length,
                      itemBuilder: (context, index) {
                        final member = memberProvider.members[index];

                        return Card(
                          elevation: 1,
                          margin:
                              const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .primary,
                              child: Text(
                                member.name.isNotEmpty
                                    ? member.name[0].toUpperCase()
                                    : '?',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            title: Text(
                              member.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            subtitle: Text(
                              '${member.email}\n${getRoleName(member.role)}',
                            ),

                            isThreeLine: true,

                            // 🗑️ HAPUS DENGAN LONG PRESS
                            onLongPress: () {
                              showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title:
                                      const Text('Hapus Anggota'),
                                  content: Text(
                                    'Yakin ingin menghapus ${member.name}?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context),
                                      child: const Text('Batal'),
                                    ),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                      ),
                                      onPressed: () async {
                                        await memberProvider
                                            .deleteMember(member.id);

                                        if (!mounted) return;
                                        Navigator.pop(context);

                                        // 🔄 refresh setelah hapus
                                        await Provider.of<MemberProvider>(
                                          context,
                                          listen: false,
                                        ).fetchMembers();
                                      },
                                      child: const Text('Hapus'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
