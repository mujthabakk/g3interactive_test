class ApiaryRoleModel {
  final int id;
  final String role;

  ApiaryRoleModel({
    required this.id,
    required this.role,
  });

  factory ApiaryRoleModel.fromJson(Map<String, dynamic> json) {
    return ApiaryRoleModel(
      id: json['id'] ?? 0,
      role: json['role'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'role': role,
    };
  }
}
