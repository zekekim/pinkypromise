import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pinkypromise/providers/providers.dart';

import 'custom_exception.dart';

abstract class AuthRepository {
  Stream<User?> get authStateChanges;
  Future<void> signInAnonymously();
  User? getCurrentUser();
  Future<void> signOut();
}

final authRepositoryProvider = Provider<AuthRepositoryImpl>(
  (ref) => AuthRepositoryImpl(
    (ref.read),
  ),
);

class AuthRepositoryImpl implements AuthRepository {
  final Reader _read;

  AuthRepositoryImpl(this._read);

  @override
  User? getCurrentUser() {
    try {
      return _read(firebaseAuthProvider).currentUser;
    } on Exception catch (e) {
      throw CustomException(message: e.toString());
    }
  }

  @override
  Stream<User?> get authStateChanges =>
      _read(firebaseAuthProvider).authStateChanges();

  @override
  Future<void> signInAnonymously() async {
    try {
      await _read(firebaseAuthProvider).signInAnonymously();
    } on Exception catch (e) {
      throw CustomException(message: e.toString());
    }
  }

  Future<void> signInWithPhone() async {
    try {
      await _read(firebaseAuthProvider).verifyPhoneNumber(
        codeAutoRetrievalTimeout: (String verificationId) async {
          //TODO: Implement
        },
        codeSent: (String verificationId, int? forceResendingToken) async {
          _read(verificationProvider).state = verificationId;
        },
        phoneNumber: _read(phoneNumberProvider).state,
        verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
          await _read(firebaseAuthProvider)
              .signInWithCredential(phoneAuthCredential);
        },
        verificationFailed: (FirebaseAuthException error) async {
          throw CustomException(message: error.toString());
        },
      );
    } on Exception catch (e) {
      throw CustomException(message: e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    await _read(firebaseAuthProvider).signOut();
    try {
      await signInAnonymously();
    } on Exception catch (e) {
      throw CustomException(message: e.toString());
    }
  }
}
