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
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<MemberProvider>(context, listen: false).fetchMembers();
    });
  }

  String get formattedDate {
    final m = selectedDate.month.toString().padLeft(2, '0');
    final d = selectedDate.day.toString().padLeft(2, '0');
    return "${selectedDate.year}-$m-$d";
  }

  Color statusColor(String status) {
    switch (status) {
      case 'hadir':
        return Colors.green;
      case 'izin':
        return Colors.orange;
      case 'sakit':
        return Colors.blue;
      default:
        return Colors.red;
    }
  }

  Widget statusButton({
    required String label,
    required String current,
    required VoidCallback onTap,
  }) {
    final bool isActive = label == current;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 36,
          decoration: BoxDecoration(
            color: isActive ? statusColor(label) : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Center(
            child: Text(
              label.toUpperCase(),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: isActive ? Colors.white : Colors.black87,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final memberProvider = Provider.of<MemberProvider>(context);
    final attendanceProvider = Provider.of<AttendanceProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text('Absensi'),
        backgroundColor: Colors.indigo,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ===== HEADER TANGGAL =====
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.indigo, Colors.blue],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tanggal Absensi',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        formattedDate,
                        style: const TextStyle(color: Colors.white),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(
                          Icons.calendar_today,
                          color: Colors.white,
                        ),
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2030),
                          );
                          if (picked != null) {
                            setState(() => selectedDate = picked);
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // ===== KETERANGAN =====
            TextField(
              controller: _noteController,
              decoration: InputDecoration(
                labelText: 'Keterangan Kegiatan',
                hintText: 'Contoh: Rapat evaluasi',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 16),

            // ===== LIST ANGGOTA =====
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 100),
                itemCount: memberProvider.members.length,
                itemBuilder: (context, index) {
                  final member = memberProvider.members[index];
                  final status =
                      attendanceProvider.attendanceStatus[member.id] ?? 'alfa';

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          member.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            statusButton(
                              label: 'hadir',
                              current: status,
                              onTap: () => attendanceProvider.setStatus(
                                member.id,
                                'hadir',
                              ),
                            ),
                            const SizedBox(width: 6),
                            statusButton(
                              label: 'izin',
                              current: status,
                              onTap: () => attendanceProvider.setStatus(
                                member.id,
                                'izin',
                              ),
                            ),
                            const SizedBox(width: 6),
                            statusButton(
                              label: 'sakit',
                              current: status,
                              onTap: () => attendanceProvider.setStatus(
                                member.id,
                                'sakit',
                              ),
                            ),
                            const SizedBox(width: 6),
                            statusButton(
                              label: 'alfa',
                              current: status,
                              onTap: () => attendanceProvider.setStatus(
                                member.id,
                                'alfa',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // ===== SIMPAN =====
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.indigo,
        icon: const Icon(Icons.save),
        label: const Text('Simpan Absensi'),
        onPressed: () async {
          final records = memberProvider.members.map((m) {
            return Attendance(
              memberId: m.id,
              memberName: m.name,
              status: attendanceProvider.attendanceStatus[m.id] ?? 'alfa',
            );
          }).toList();

          await attendanceProvider.saveAttendance(
            selectedDate,
            records,
            note: _noteController.text.trim(),
          );

          attendanceProvider.clear();
          _noteController.clear();

          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Absensi berhasil disimpan')),
          );
        },
      ),
    );
  }
}
