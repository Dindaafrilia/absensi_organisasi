// lib/services/firestore_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/member.dart';
import '../models/attendance.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Members
  Stream<List<Member>> streamMembers() {
    return _db.collection('members').snapshots().map((snap) =>
      snap.docs.map((d) => Member.fromMap(d.id, d.data())).toList()
    );
  }

  Future<void> addMember(Member m) {
    return _db.collection('members').add(m.toMap());
  }

  Future<void> updateMember(Member m) {
    return _db.collection('members').doc(m.id).update(m.toMap());
  }

  Future<void> deleteMember(String id) {
    return _db.collection('members').doc(id).delete();
  }

  // Attendances
  Stream<List<Attendance>> streamAttendances() {
    return _db.collection('attendances').orderBy('timestamp', descending: true).snapshots().map(
      (snap) => snap.docs.map((d) => Attendance.fromMap(d.id, d.data())).toList()
    );
  }

  Future<void> addAttendance(Attendance a) {
    return _db.collection('attendances').add(a.toMap());
  }

  // dll...
}
