class User {
  String uid;
  String? name;
  String email;
  String? phoneNumber;
  String sighInMethod;
  String? urlPhoto;

  User({
    required this.uid,
    required this.name,
    required this.email,
    this.phoneNumber,
    required this.sighInMethod,
    this.urlPhoto,
  });

  factory User.anonymous() {
    return User(uid: 'none', name: null, email: 'none', sighInMethod: 'none');
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uid: json['uid'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      sighInMethod: json['sign_in_method'],
      urlPhoto: json['url_photo'],
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
          urlPhoto == other.urlPhoto;

  @override
  int get hashCode =>
      uid.hashCode ^
      name.hashCode ^
      email.hashCode ^
      phoneNumber.hashCode ^
      sighInMethod.hashCode ^
      urlPhoto.hashCode;

  @override
  String toString() {
    return 'UID: $uid\nName: $name\nEmail: $email\nPhone number: $phoneNumber\nSign in method: $sighInMethod\nUrl photo: $urlPhoto';
  }
}
