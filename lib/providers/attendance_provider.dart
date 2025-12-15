import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/attendance.dart';

class AttendanceProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Map<String, String> attendanceStatus = {};

  void setStatus(String memberId, String status) {
    attendanceStatus[memberId] = status;
    notifyListeners();
  }

  void clear() {
    attendanceStatus.clear();
    notifyListeners();
  }

  /// ✅ SAVE + HITUNG SUMMARY
  Future<void> saveAttendance(
    DateTime date,
    List<Attendance> records, {
    required String note,
  }) async {
    int hadir = 0;
    int izin = 0;
    int sakit = 0;
    int alfa = 0;

    for (var r in records) {
      switch (r.status) {
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

    final docId =
        "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

    await _firestore.collection('attendances').doc(docId).set({
      'date': Timestamp.fromDate(date),
      'note': note,
      'hadir': hadir,
      'izin': izin,
      'sakit': sakit,
      'alfa': alfa,
      'records': records.map((e) => e.toMap()).toList(),
    });
  }
}
