import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('User', () {
    const uid = 'mock-uid';
    const name = 'mock-name';
    const email = 'mock-email';

    test('user value equality', () {
      expect(
        User(uid: uid, name: name, email: email),
        equals(User(uid: uid, name: name, email: email)),
      );
    });
  });
}
