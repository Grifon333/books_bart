import 'package:equatable/equatable.dart';

enum UserRole { customer, manager }

class User extends Equatable {
  final String uid;
  final String? name;
  final String email;
  final String? phoneNumber;
  final String? photoUrl;
  final UserRole role;

  const User({
    required this.uid,
    required this.name,
    required this.email,
    this.phoneNumber,
    this.photoUrl,
  }) : role = email == '201173@nuos.edu.ua'
            ? UserRole.manager
            : UserRole.customer;

  const User._()
      : uid = 'none',
        name = null,
        email = 'none',
        phoneNumber = null,
        photoUrl = null,
        role = UserRole.customer;

  const factory User.anonymous() = User._;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uid: json['uid'],
      name: json['name'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      photoUrl: json['url_photo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phone_number': phoneNumber,
      'url_photo': photoUrl,
    };
  }

  @override
  String toString() {
    return 'UID: $uid\n'
        'Name: $name\n'
        'Email: $email\n'
        'Phone number: $phoneNumber\n'
        'Photo URL: $photoUrl\n'
        'Role: ${role.name}';
  }

  @override
  List<Object?> get props => [uid, name, email, phoneNumber, photoUrl, role];

  User copyWith({
    String? uid,
    String? name,
    String? email,
    String? phoneNumber,
    String? photoUrl,
  }) {
    return User(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }
}
