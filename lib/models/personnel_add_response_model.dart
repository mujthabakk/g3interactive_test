class PersonnelAddResponseModel {
  final bool status;
  final int id;
  final String message;

  PersonnelAddResponseModel({
    required this.status,
    required this.id,
    required this.message,
  });

  factory PersonnelAddResponseModel.fromJson(Map<String, dynamic> json) {
    return PersonnelAddResponseModel(
      status: json['status'] ?? false,
      id: json['id'] ?? 0,
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'id': id,
      'message': message,
    };
  }
}
