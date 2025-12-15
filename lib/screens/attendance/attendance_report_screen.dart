import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

import 'attendance_detail_screen.dart';

class AttendanceReportScreen extends StatelessWidget {
  const AttendanceReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        title: const Text('Laporan Absensi'),
        backgroundColor: Colors.indigo,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('attendances')
            .orderBy(FieldPath.documentId)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('Belum ada data absensi'));
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final dateDoc = docs[index];
              final data = dateDoc.data() as Map<String, dynamic>;

              final hadir = data['hadir'] ?? 0;
              final izin = data['izin'] ?? 0;
              final sakit = data['sakit'] ?? 0;
              final alfa = data['alfa'] ?? 0;
              final note = data['note'] ?? '-';

              final total = hadir + izin + sakit + alfa;

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
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
                    // ===== HEADER =====
                    Text(
                      'Tanggal: ${dateDoc.id}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Kegiatan: $note',
                      style: const TextStyle(color: Colors.grey),
                    ),

                    const SizedBox(height: 8),

                    // ===== DETAIL BUTTON =====
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  AttendanceDetailScreen(dateId: dateDoc.id),
                            ),
                          );
                        },
                        icon: const Icon(Icons.visibility),
                        label: const Text('Lihat Detail'),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // ===== CHART =====
                    if (total > 0)
                      SizedBox(
                        height: 180,
                        child: PieChart(
                          PieChartData(
                            centerSpaceRadius: 40,
                            sectionsSpace: 4,
                            sections: [
                              PieChartSectionData(
                                value: hadir.toDouble(),
                                color: Colors.green,
                                title: 'Hadir\n$hadir',
                                radius: 45,
                                titleStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              PieChartSectionData(
                                value: izin.toDouble(),
                                color: Colors.orange,
                                title: 'Izin\n$izin',
                                radius: 45,
                                titleStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              PieChartSectionData(
                                value: sakit.toDouble(),
                                color: Colors.blue,
                                title: 'Sakit\n$sakit',
                                radius: 45,
                                titleStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              PieChartSectionData(
                                value: alfa.toDouble(),
                                color: Colors.red,
                                title: 'Alfa\n$alfa',
                                radius: 45,
                                titleStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Center(
                          child: Text(
                            'Belum ada data absensi',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),

                    const SizedBox(height: 12),

                    // ===== SUMMARY =====
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Hadir: $hadir'),
                        Text('Izin: $izin'),
                        Text('Sakit: $sakit'),
                        Text('Alfa: $alfa'),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
