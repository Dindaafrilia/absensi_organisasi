import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AttendanceReport {
  final String date;
  final String note;
  final int hadir;
  final int izin;
  final int sakit;
  final int alfa;

  AttendanceReport({
    required this.date,
    required this.note,
    required this.hadir,
    required this.izin,
    required this.sakit,
    required this.alfa,
  });
}

class AttendanceReportProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<AttendanceReport> _reports = [];
  List<AttendanceReport> get reports => _reports;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchAllReports() async {
    _isLoading = true;
    notifyListeners();

    final snapshot = await _firestore.collection('attendances').get();

    final List<AttendanceReport> loaded = [];

    for (final doc in snapshot.docs) {
      final date = doc.id;
      final data = doc.data();

      final note = data['note'] ?? '-';

      final recordsSnapshot = await _firestore
          .collection('attendances')
          .doc(date)
          .collection('records')
          .get();

      int hadir = 0;
      int izin = 0;
      int sakit = 0;
      int alfa = 0;

      for (final r in recordsSnapshot.docs) {
        final status = r['status'];
        switch (status) {
          case 'hadir':
            hadir++;
            break;
          case 'izin':
            izin++;
            break;
          case 'sakit':
            sakit++;
            break;
          default:
            alfa++;
        }
      }

      loaded.add(
        AttendanceReport(
          date: date,
          note: note,
          hadir: hadir,
          izin: izin,
          sakit: sakit,
          alfa: alfa,
        ),
      );
    }

    loaded.sort((a, b) => b.date.compareTo(a.date));

    _reports = loaded;
    _isLoading = false;
    notifyListeners();
  }
}
