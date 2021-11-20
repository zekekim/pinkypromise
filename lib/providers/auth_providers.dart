import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pinkypromise/repos/repos.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>(
  (ref) => FirebaseAuth.instance,
);
final firestoreProvider = Provider<FirebaseFirestore>(
  (ref) => FirebaseFirestore.instance,
);

final phoneNumberProvider = StateProvider<String>((ref) {
  return '';
});
final smsProvider = StateProvider<String>((ref) {
  return '';
});

final verificationProvider = StateProvider<String>((ref) {
  return '';
});
