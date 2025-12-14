import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/member.dart';

class MemberProvider extends ChangeNotifier {
  final CollectionReference _memberCollection =
      FirebaseFirestore.instance.collection('members');

  List<Member> _members = [];
  List<Member> get members => _members;

  Future<void> fetchMembers() async {
    final snapshot = await _memberCollection.get();
    _members = snapshot.docs
        .map((doc) => Member.fromFirestore(doc))
        .toList();
    notifyListeners();
  }

  Future<void> addMember(String name, String email, int role) async {
    await _memberCollection.add({
      'name': name,
      'email': email,
      'role': role,
      'createdAt': Timestamp.now(),
    });

    await fetchMembers();
  }

  Future<void> deleteMember(String id) async {
    await _memberCollection.doc(id).delete();
    _members.removeWhere((m) => m.id == id);
    notifyListeners();
  }
}
