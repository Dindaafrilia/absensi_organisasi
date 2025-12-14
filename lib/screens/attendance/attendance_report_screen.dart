import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AttendanceReportScreen extends StatefulWidget {
  @override
  State<AttendanceReportScreen> createState() =>
      _AttendanceReportScreenState();
}

class _AttendanceReportScreenState extends State<AttendanceReportScreen> {
  DateTime selectedDate = DateTime.now();

  String get formattedDate {
  final m = selectedDate.month.toString().padLeft(2, '0');
  final d = selectedDate.day.toString().padLeft(2, '0');
  return "${selectedDate.year}-$m-$d";
}


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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Laporan Absensi'),
      ),
      body: Column(
        children: [
          // 📅 PILIH TANGGAL
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text(formattedDate),
                Spacer(),
                ElevatedButton(
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
                  child: Text('Pilih Tanggal'),
                ),
              ],
            ),
          ),
          Divider(),

          // 📊 DATA ABSENSI
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('attendances')
                  .doc(formattedDate)
                  .collection('records')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData ||
                    snapshot.data!.docs.isEmpty) {
                  return Center(
                      child: Text(
                          'Belum ada absensi pada tanggal ini'));
                }

                final docs = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final data =
                        docs[index].data() as Map<String, dynamic>;
                    final status = data['status'];

                    return Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 6, horizontal: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor:
                              getStatusColor(status),
                          child: Icon(
                            getStatusIcon(status),
                            color: Colors.white,
                          ),
                        ),
                        title: Text(data['memberName']),
                        subtitle: Text(
                          status.toUpperCase(),
                          style: TextStyle(
                            color: getStatusColor(status),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
