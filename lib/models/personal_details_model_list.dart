class PersonalDetailsModel {
  final bool status;
  final List<PersonnelData> data;

  PersonalDetailsModel({
    required this.status,
    required this.data,
  });

  factory PersonalDetailsModel.fromJson(Map<String, dynamic> json) {
    return PersonalDetailsModel(
      status: json['status'] ?? false,
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => PersonnelData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}

class PersonnelData {
  final int id;
  final String firstName;
  final dynamic lastName;
  final String address;
  final String? latitude;
  final String? longitude;
  final String? suburb;
  final String? state;
  final String? postcode;
  final String? country;
  final String? contactNumber;
  final String? additionalNotes;
  final String status;
  final String roleIds;
  final String createdBy;
  final String? updatedBy;
  final List<RoleDetail> roleDetails;
  final List<String> apiaryRoleArray;

  PersonnelData({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.suburb,
    required this.state,
    required this.postcode,
    required this.country,
    required this.contactNumber,
    required this.additionalNotes,
    required this.status,
    required this.roleIds,
    required this.createdBy,
    required this.updatedBy,
    required this.roleDetails,
    required this.apiaryRoleArray,
  });

  factory PersonnelData.fromJson(Map<String, dynamic> json) {
    return PersonnelData(
      id: json['id'] ?? 0,
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'],
      address: json['address'] ?? '',
      latitude: json['latitude'],
      longitude: json['longitude'],
      suburb: json['suburb'],
      state: json['state'],
      postcode: json['postcode'],
      country: json['country'],
      contactNumber: json['contact_number'],
      additionalNotes: json['additional_notes'],
      status: json['status'] ?? '',
      roleIds: json['role_ids'] ?? '',
      createdBy: json['created_by'] ?? '',
      updatedBy: json['updated_by'],
      roleDetails: (json['role_details'] as List<dynamic>?)
              ?.map((e) => RoleDetail.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      apiaryRoleArray: (json['apiary_role_array'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'suburb': suburb,
      'state': state,
      'postcode': postcode,
      'country': country,
      'contact_number': contactNumber,
      'additional_notes': additionalNotes,
      'status': status,
      'role_ids': roleIds,
      'created_by': createdBy,
      'updated_by': updatedBy,
      'role_details': roleDetails.map((e) => e.toJson()).toList(),
      'apiary_role_array': apiaryRoleArray,
    };
  }

  PersonnelData copyWith({
    int? id,
    String? firstName,
    dynamic lastName,
    String? address,
    String? latitude,
    String? longitude,
    String? suburb,
    String? state,
    String? postcode,
    String? country,
    String? contactNumber,
    String? additionalNotes,
    String? status,
    String? roleIds,
    String? createdBy,
    String? updatedBy,
    List<RoleDetail>? roleDetails,
    List<String>? apiaryRoleArray,
  }) {
    return PersonnelData(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      suburb: suburb ?? this.suburb,
      state: state ?? this.state,
      postcode: postcode ?? this.postcode,
      country: country ?? this.country,
      contactNumber: contactNumber ?? this.contactNumber,
      additionalNotes: additionalNotes ?? this.additionalNotes,
      status: status ?? this.status,
      roleIds: roleIds ?? this.roleIds,
      createdBy: createdBy ?? this.createdBy,
      updatedBy: updatedBy ?? this.updatedBy,
      roleDetails: roleDetails ?? this.roleDetails,
      apiaryRoleArray: apiaryRoleArray ?? this.apiaryRoleArray,
    );
  }
}

class RoleDetail {
  final int id;
  final String role;

  RoleDetail({
    required this.id,
    required this.role,
  });

  factory RoleDetail.fromJson(Map<String, dynamic> json) {
    return RoleDetail(
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

  RoleDetail copyWith({
    int? id,
    String? role,
  }) {
    return RoleDetail(
      id: id ?? this.id,
      role: role ?? this.role,
    );
  }
}
