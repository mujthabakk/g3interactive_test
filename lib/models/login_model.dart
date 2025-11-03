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
      accessToken: json['access_token'] ?? '',
      refreshToken: json['refresh_token'] ?? '',
      expiresInSec: (json['expires_in_sec'] ?? 0).toDouble(),
      user: User.fromJson(json['user'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'expires_in_sec': expiresInSec,
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
      roleId: json['role_id']?.toString() ?? '',
      role: json['role'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'],
      profileImageUrl: json['profile_image_url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'role_id': roleId,
      'role': role,
      'first_name': firstName,
      'last_name': lastName,
      'profile_image_url': profileImageUrl,
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
