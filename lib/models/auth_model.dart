class LoginModel {
  final bool status;
  final String accessToken;
  final String refreshToken;
  final double expiresInSec;
  final User user;

  LoginModel({
    required this.status,
    required this.accessToken,
    required this.refreshToken,
    required this.expiresInSec,
    required this.user,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      status: json['status'] ?? false,
      accessToken: json['accessToken'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
      expiresInSec: (json['expiresInSec'] ?? 0).toDouble(),
      user: User.fromJson(json['user'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'expiresInSec': expiresInSec,
      'user': user.toJson(),
    };
  }

  LoginModel copyWith({
    bool? status,
    String? accessToken,
    String? refreshToken,
    double? expiresInSec,
    User? user,
  }) {
    return LoginModel(
      status: status ?? this.status,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      expiresInSec: expiresInSec ?? this.expiresInSec,
      user: user ?? this.user,
    );
  }
}

class User {
  final int id;
  final String roleId;
  final String role;
  final String firstName;
  final dynamic lastName;
  final String profileImageUrl;

  User({
    required this.id,
    required this.roleId,
    required this.role,
    required this.firstName,
    required this.lastName,
    required this.profileImageUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      roleId: json['roleId'] ?? '',
      role: json['role'] ?? '',
      firstName: json['firstName'] ?? '',
      lastName: json['lastName'],
      profileImageUrl: json['profileImageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'roleId': roleId,
      'role': role,
      'firstName': firstName,
      'lastName': lastName,
      'profileImageUrl': profileImageUrl,
    };
  }

  User copyWith({
    int? id,
    String? roleId,
    String? role,
    String? firstName,
    dynamic lastName,
    String? profileImageUrl,
  }) {
    return User(
      id: id ?? this.id,
      roleId: roleId ?? this.roleId,
      role: role ?? this.role,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }
}
