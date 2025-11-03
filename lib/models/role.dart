class Role {
  final String id;
  final String name;
  final String description;

  Role({
    required this.id,
    required this.name,
    required this.description,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }

  // Predefined roles
  static final List<Role> predefinedRoles = [
    Role(
      id: '1',
      name: 'Colony Owner',
      description: 'Owner of the colony',
    ),
    Role(
      id: '2',
      name: 'Land Owner/Occupier',
      description: 'Owner or occupier of the land',
    ),
    Role(
      id: '3',
      name: 'Chem Applicator',
      description: 'Chemical applicator specialist',
    ),
    Role(
      id: '4',
      name: 'Manager',
      description: 'General manager',
    ),
  ];
}
