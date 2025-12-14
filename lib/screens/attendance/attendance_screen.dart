import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/member_provider.dart';
import '../../providers/attendance_provider.dart';
import '../../models/attendance.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<MemberProvider>(context, listen: false).fetchMembers();
    });
  }

  // ================= HELPER WARNA =================
  Color getStatusColor(String status) {
    switch (status) {
      case 'hadir':
        return Colors.green;
      case 'izin':
        return Colors.orange;
      case 'sakit':
        return Colors.blue;
      case 'alfa':
      default:
        return Colors.red;
    }
  }

  // ================= HELPER ICON =================
  IconData getStatusIcon(String status) {
    switch (status) {
      case 'hadir':
        return Icons.check_circle;
      case 'izin':
        return Icons.edit_note;
      case 'sakit':
        return Icons.medical_services;
      case 'alfa':
      default:
        return Icons.cancel;
    }
  }

  String get formattedDate {
    final m = selectedDate.month.toString().padLeft(2, '0');
    final d = selectedDate.day.toString().padLeft(2, '0');
    return "${selectedDate.year}-$m-$d";
  }

  @override
  Widget build(BuildContext context) {
    final memberProvider = Provider.of<MemberProvider>(context);
    final attendanceProvider = Provider.of<AttendanceProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Absensi'),
      ),

      // ================= CONTENT =================
      body: Column(
        children: [
          // ===== PILIH TANGGAL =====
          Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Tanggal Absensi',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(formattedDate),
                      ],
                    ),
                    const Spacer(),
                    ElevatedButton.icon(
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030),
                        );
                        if (picked != null) {
                          setState(() {
                            selectedDate = picked;
                          });
                        }
                      },
                      icon: const Icon(Icons.calendar_today),
                      label: const Text('Pilih'),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ===== LIST ANGGOTA =====
          Expanded(
            child: memberProvider.members.isEmpty
                ? const Center(
                    child: Text('Belum ada anggota'),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 110), // 🔥 FIX UTAMA
                    itemCount: memberProvider.members.length,
                    itemBuilder: (context, index) {
                      final member = memberProvider.members[index];
                      final status =
                          attendanceProvider.attendanceStatus[member.id] ??
                              'alfa';

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          vertical: 6,
                          horizontal: 12,
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: getStatusColor(status),
                            child: Icon(
                              getStatusIcon(status),
                              color: Colors.white,
                            ),
                          ),
                          title: Text(member.name),
                          subtitle: Text(
                            status.toUpperCase(),
                            style: TextStyle(
                              color: getStatusColor(status),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          trailing: DropdownButton<String>(
                            value: status,
                            underline: const SizedBox(),
                            items: const [
                              'hadir',
                              'izin',
                              'sakit',
                              'alfa',
                            ]
                                .map(
                                  (s) => DropdownMenuItem(
                                    value: s,
                                    child: Text(s.toUpperCase()),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {
                              if (value != null) {
                                attendanceProvider.setStatus(
                                  member.id,
                                  value,
                                );
                              }
                            },
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),

      // ================= SIMPAN =================
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final records = memberProvider.members.map((member) {
            final status =
                attendanceProvider.attendanceStatus[member.id] ?? 'alfa';

            return Attendance(
              memberId: member.id,
              memberName: member.name,
              status: status,
            );
          }).toList();

          await attendanceProvider.saveAttendance(
            selectedDate,
            records,
          );
          attendanceProvider.clear();

          if (!mounted) return;

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Absensi berhasil disimpan'),
            ),
          );
        },
        icon: const Icon(Icons.save),
        label: const Text('Simpan Absensi'),
      ),
    );
  }
}
