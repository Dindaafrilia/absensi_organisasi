class Attendance {
  final String memberId;
  final String memberName;
  final String status; // hadir, izin, sakit, alfa

  Attendance({
    required this.memberId,
    required this.memberName,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'memberId': memberId,
      'memberName': memberName,
      'status': status,
    };
  }
}
