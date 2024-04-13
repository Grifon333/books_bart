class User {
  String uid;
  String? name;
  String email;
  String? phoneNumber;
  String sighInMethod;

  User({
    required this.uid,
    required this.name,
    required this.email,
    required this.phoneNumber,
    required this.sighInMethod,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uid: json['uid'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      sighInMethod: json['sign_in_method'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phone_number': phoneNumber,
      'sign_in_method': sighInMethod,
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
          sighInMethod == other.sighInMethod;

  @override
  int get hashCode =>
      uid.hashCode ^
      name.hashCode ^
      email.hashCode ^
      phoneNumber.hashCode ^
      sighInMethod.hashCode;

  @override
  String toString() {
    return 'UID: $uid\nName: $name\nEmail: $email\nPhone number: $phoneNumber\nSign in method: $sighInMethod';
  }
}
