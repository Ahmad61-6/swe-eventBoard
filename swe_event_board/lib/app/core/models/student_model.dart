class Student {
  final String id;
  final String email;
  final String? studentId;
  final String? department;
  final String firstName;
  final String lastName;
  late final String? profilePicUrl;

  Student({
    required this.id,
    required this.email,
    this.studentId,
    this.department,
    required this.firstName,
    required this.lastName,
    this.profilePicUrl,
  });
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'student_id': studentId,
      'department': department,
      'first_name': firstName,
      'last_name': lastName,
      'profile_pic_url': profilePicUrl,
    };
  }

  Student copyWith({
    String? firstName,
    String? lastName,
    String? studentId,
    String? department,
    String? profilePicUrl,
  }) {
    return Student(
      id: this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      studentId: studentId ?? this.studentId,
      department: department ?? this.department,
      profilePicUrl: profilePicUrl ?? this.profilePicUrl,
      email: this.email,
    );
  }

  factory Student.fromMap(Map<String, dynamic> map) => Student(
    id: map['id'],
    email: map['email'],
    studentId: map['student_id'],
    department: map['department'],
    firstName: map['first_name'],
    lastName: map['last_name'],
    profilePicUrl: map['profile_pic_url'],
  );
}
