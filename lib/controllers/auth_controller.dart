import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pinkypromise/providers/auth_providers.dart';
import 'package:pinkypromise/repos/custom_exception.dart';
import 'package:pinkypromise/repos/repos.dart';

final authControllerProvider = StateNotifierProvider<AuthController, User?>(
  (ref) => AuthController(ref.read),
);

final authExceptionProvider = StateProvider<CustomException?>((_) {
  return null;
});

class AuthController extends StateNotifier<User?> {
  final Reader _read;

  StreamSubscription<User?>? _authStateChangesSubscription;
  AuthController(this._read) : super(null) {
    _authStateChangesSubscription?.cancel();
    _authStateChangesSubscription =
        _read(authRepositoryProvider).authStateChanges.listen(
              (user) => state = user,
            );
  }

  Future<void> verifyPhone() async {
    try {
      await _read(authRepositoryProvider).signInWithPhone();
    } on CustomException catch (e) {
      _read(authExceptionProvider).state = e;
    }
  }

  Future<void> signIn() async {
    try {
      await _read(firebaseAuthProvider).signInWithCredential(
        PhoneAuthProvider.credential(
            verificationId: _read(verificationProvider).state,
            smsCode: _read(smsProvider).state),
      );
    } catch (e) {
      _read(authExceptionProvider).state =
          CustomException(message: e.toString());
    }
  }

  Future<void> signOut() async {
    await _read(authRepositoryProvider).signOut();
  }

  @override
  void dispose() {
    _authStateChangesSubscription?.cancel();
    super.dispose();
  }
}
