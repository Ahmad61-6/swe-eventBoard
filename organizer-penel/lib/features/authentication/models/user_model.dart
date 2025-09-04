import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yt_ecommerce_admin_panel/utils/constants/enums.dart';
import 'package:yt_ecommerce_admin_panel/utils/formatters/formatter.dart';

class UserModel {
  final String? id;
  String orgName;
  String email;
  String phone;
  String profileImage;
  AppRole role;
  DateTime? createdAt;
  DateTime? updatedAt;

  UserModel({
    this.id,
    this.orgName = '',
    required this.email,
    this.phone = '',
    this.profileImage = '',
    this.role = AppRole.user,
    this.createdAt,
    this.updatedAt,
  });
  factory UserModel.empty() {
    return UserModel(
      id: null,
      orgName: '',
      email: '',
      phone: '',
      profileImage: '',
      role: AppRole.user,
      createdAt: null,
      updatedAt: null,
    );
  }

  String get orgNameToDisplay => orgName;
  String get formattedDate => TFormatter.formatDate(createdAt);
  String get formattedUpdatedAtDate => TFormatter.formatDate(updatedAt);
  String get formattedPhoneNo => TFormatter.formatPhoneNumber(phone);

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orgName': orgName,
      'email': email,
      'phone': phone,
      'profileImage': profileImage,
      'role': role.name, // enum as string
      'createdAt': createdAt, // keep as-is (nullable)
      'updatedAt': DateTime.now(), // set to "now" without mutating the field
    };
  }

  factory UserModel.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data();
    if (data != null) {
      final roleStr =
          data.containsKey('role') ? (data['role'] as String?) : null;

      return UserModel(
        id: document.id,
        orgName: data.containsKey('orgName')
            ? (data['orgName'] ?? '') as String
            : '',
        email: data.containsKey('email') ? (data['email'] ?? '') as String : '',
        phone: data.containsKey('phone') ? (data['phone'] ?? '') as String : '',
        profileImage: data.containsKey('profileImage')
            ? (data['profileImage'] ?? '') as String
            : '',
        role: roleStr == AppRole.admin.name ? AppRole.admin : AppRole.user,
        createdAt: data.containsKey('createdAt')
            ? (data['createdAt'] is Timestamp
                ? (data['createdAt'] as Timestamp).toDate()
                : data['createdAt'] as DateTime?)
            : DateTime.now(),
        updatedAt: data.containsKey('updatedAt')
            ? (data['updatedAt'] is Timestamp
                ? (data['updatedAt'] as Timestamp).toDate()
                : data['updatedAt'] as DateTime?)
            : DateTime.now(),
      );
    } else {
      return UserModel(email: '');
    }
  }
}
