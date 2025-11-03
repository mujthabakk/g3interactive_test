import 'personal_details_model_list.dart';

class SinglePersonnelDetailModel {
  final bool status;
  final PersonnelData data;

  SinglePersonnelDetailModel({
    required this.status,
    required this.data,
  });

  factory SinglePersonnelDetailModel.fromJson(Map<String, dynamic> json) {
    return SinglePersonnelDetailModel(
      status: json['status'] ?? false,
      data: PersonnelData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data.toJson(),
    };
  }
}
