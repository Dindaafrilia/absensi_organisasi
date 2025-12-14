import 'package:cloud_firestore/cloud_firestore.dart';

class Member {
  final String id;
  final String name;
  final String email;
  final int role;

  Member({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
  });

  factory Member.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    // 🔥 FIX UTAMA DI SINI
    int parsedRole = 4; // default Anggota

    final rawRole = data['role'];

    if (rawRole is int) {
      parsedRole = rawRole;
    } else if (rawRole is String) {
      switch (rawRole.toLowerCase()) {
        case 'ketua':
          parsedRole = 1;
          break;
        case 'sekretaris':
          parsedRole = 2;
          break;
        case 'bendahara':
          parsedRole = 3;
          break;
        default:
          parsedRole = 4;
      }
    }

    return Member(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      role: parsedRole,
    );
  }
}
