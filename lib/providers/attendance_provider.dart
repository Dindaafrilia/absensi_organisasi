import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/attendance.dart';

class AttendanceProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // key: memberId, value: status
  Map<String, String> _attendanceStatus = {};
  Map<String, String> get attendanceStatus => _attendanceStatus;

  void setStatus(String memberId, String status) {
    _attendanceStatus[memberId] = status;
    notifyListeners();
  }

  Future<void> saveAttendance(
    DateTime date,
    List<Attendance> records,
  ) async {
    // 🔹 Format tanggal rapi: YYYY-MM-DD
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    final dateId = "${date.year}-$m-$d";

    // 🔹 DEBUG: cek berapa record yang akan disimpan
    print("SAVE ATTENDANCE: ${records.length} records untuk $dateId");

    for (final record in records) {
      await _firestore
          .collection('attendances')
          .doc(dateId)
          .collection('records')
          .doc(record.memberId)
          .set(record.toMap());
    }
  }

  void clear() {
    _attendanceStatus.clear();
  }
}
