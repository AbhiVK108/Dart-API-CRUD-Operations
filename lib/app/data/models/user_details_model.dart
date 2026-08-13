class UserDetails {
  final String? id;
  final String name;
  final String email;
  final String phone;

  const UserDetails({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
  });

  // JSON -> Dart Object
  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      id: json['_id']?.toString(),
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
    );
  }

  // Dart Object -> JSON
  //
  // Important:
  // We do NOT send _id because CrudCrud manages _id.
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
    };
  }

  // Useful when updating only some values locally.
  UserDetails copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
  }) {
    return UserDetails(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
    );
  }

  @override
  String toString() {
    return 'UserDetails(id: $id, name: $name, email: $email, phone: $phone)';
  }
}