

class User {
  String uid;
  String? name;
  String? email;
  String? phoneNumber;

  User({
    required this.uid,
    required this.name,
    required this.email,
    required this.phoneNumber,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uid: json['uid'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phone_number'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phone_number': phoneNumber,
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
          phoneNumber == other.phoneNumber;

  @override
  int get hashCode =>
      uid.hashCode ^ name.hashCode ^ email.hashCode ^ phoneNumber.hashCode;

  @override
  String toString() {
    return 'UID: $uid\nName: $name\nEmail: $email\nPhone number: $phoneNumber';
  }
}
