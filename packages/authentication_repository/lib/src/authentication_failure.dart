part of 'authentication_repository.dart';

class SignUpWithEmailAndPasswordFailure implements Exception {
  final String message;

  const SignUpWithEmailAndPasswordFailure([
    this.message = 'An unknown exception occurred.',
  ]);

  factory SignUpWithEmailAndPasswordFailure.fromCode(String code) {
    return _messageByCode.containsKey(code)
        ? SignUpWithEmailAndPasswordFailure(_messageByCode[code]!)
        : const SignUpWithEmailAndPasswordFailure();
  }
}

class LogInWithEmailAndPasswordFailure implements Exception {
  final String message;

  const LogInWithEmailAndPasswordFailure([
    this.message = 'An unknown exception occurred.',
  ]);

  factory LogInWithEmailAndPasswordFailure.fromCode(String code) {
    return _messageByCode.containsKey(code)
        ? LogInWithEmailAndPasswordFailure(_messageByCode[code]!)
        : const LogInWithEmailAndPasswordFailure();
  }
}

class LogInWithGoogleFailure implements Exception {
  final String message;

  const LogInWithGoogleFailure([
    this.message = 'An unknown exception occurred.',
  ]);

  factory LogInWithGoogleFailure.fromCode(String code) {
    return _messageByCode.containsKey(code)
        ? LogInWithGoogleFailure(_messageByCode[code]!)
        : const LogInWithGoogleFailure();
  }
}

class LogOutFailure implements Exception {
  const LogOutFailure();
}

class UpdateDisplayNameFailure implements Exception {
  const UpdateDisplayNameFailure();
}

class UpdatePasswordFailure implements Exception {
  final String message;

  const UpdatePasswordFailure([
    this.message = 'An unknown exception occurred.',
  ]);

  factory UpdatePasswordFailure.fromCode(String code) {
    return _messageByCode.containsKey(code)
        ? UpdatePasswordFailure(_messageByCode[code]!)
        : const UpdatePasswordFailure();
  }
}

class UpdatePhoneNumberFailure implements Exception {
  final String message;

  const UpdatePhoneNumberFailure([
    this.message = 'An unknown exception occurred.',
  ]);

  factory UpdatePhoneNumberFailure.fromCode(String code) {
    return _messageByCode.containsKey(code)
        ? UpdatePhoneNumberFailure(_messageByCode[code]!)
        : const UpdatePhoneNumberFailure();
  }
}

class UpdatePhotoURLFailure implements Exception {
  const UpdatePhotoURLFailure();
}

const Map<String, String> _messageByCode = {
  'invalid-email': 'Email is not valid or badly formatted.',
  'user-disabled':
      'This user has been disabled. Please contact support for help.',
  'email-already-in-use': 'An account already exists for that email.',
  'operation-not-allowed': 'Operation is not allowed.  Please contact support.',
  'weak-password': 'Please enter a stronger password.',
  'user-not-found': 'Email is not found, please create an account.',
  'wrong-password': 'Incorrect password, please try again.',
  'account-exists-with-different-credential':
      'Account exists with different credentials.',
  'invalid-credential': 'The credential received is malformed or has expired.',
  'invalid-verification-code':
      'The credential verification code received is invalid.',
  'invalid-verification-id':
      'The credential verification ID received is invalid.',
};
