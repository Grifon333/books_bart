/// ROLE:
/// customer
/// manager

class User {
  String uid;
  String? name;
  String email;
  String? phoneNumber;
  String sighInMethod;
  String? urlPhoto;
  String role;

  User({
    required this.uid,
    required this.name,
    required this.email,
    this.phoneNumber,
    required this.sighInMethod,
    this.urlPhoto,
    required this.role,
  });

  factory User.anonymous() {
    return User(
      uid: 'none',
      name: null,
      email: 'none',
      sighInMethod: 'none',
      role: 'customer',
    );
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uid: json['uid'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      sighInMethod: json['sign_in_method'],
      urlPhoto: json['url_photo'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phone_number': phoneNumber,
      'sign_in_method': sighInMethod,
      'url_photo': urlPhoto,
      'role': role,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          uid == other.uid &&
          name == other.name &&
          email == other.email &&
          phoneNumber == other.phoneNumber &&
          sighInMethod == other.sighInMethod &&
          urlPhoto == other.urlPhoto &&
          role == other.role;

  @override
  int get hashCode =>
      uid.hashCode ^
      name.hashCode ^
      email.hashCode ^
      phoneNumber.hashCode ^
      sighInMethod.hashCode ^
      urlPhoto.hashCode ^
      role.hashCode;

  @override
  String toString() {
    return 'UID: $uid\n'
        'Name: $name\n'
        'Email: $email\n'
        'Phone number: $phoneNumber\n'
        'Sign in method: $sighInMethod\n'
        'Url photo: $urlPhoto\n'
        'Role: $role';
  }
}
