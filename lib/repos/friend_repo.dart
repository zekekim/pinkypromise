import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pinkypromise/controllers/auth_controller.dart';
import 'package:pinkypromise/models/friend_model.dart';
import 'package:pinkypromise/providers/providers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pinkypromise/repos/custom_exception.dart';

abstract class BaseFriendRepository {
  Future<List<Friend>> retrieveFriends({required String userId});
  Future<String> createRequest(
      {required String userId, required Friend friend});
  Future<void> acceptRequest({required String userId, required Friend friend});
  Future<void> deleteRequest(
      {required String userId, required String friendId});
}

final friendRepositoryProvider =
    Provider<FriendRepository>((ref) => FriendRepository(ref.read));

class FriendRepository implements BaseFriendRepository {
  final Reader _read;
  const FriendRepository(this._read);

  Stream<QuerySnapshot> get friendsStateChanges {
    try {
      final user = _read(authControllerProvider);
      return _read(firestoreProvider)
          .collection('users')
          .doc(user?.uid)
          .collection('friends')
          .snapshots();
    } on FirebaseException catch (e) {
      throw CustomException(message: e.message);
    }
  }

  @override
  Future<String> createRequest(
      {required String userId, required Friend friend}) async {
    try {
      await _read(firestoreProvider)
          .collection('users')
          .doc(userId)
          .collection('friends')
          .doc(friend.id)
          .set(friend.toDocument());
      await _read(firestoreProvider)
          .collection('users')
          .doc(friend.id)
          .collection('friends')
          .doc(userId)
          .set(friend.toDocument());
      return friend.id;
    } on FirebaseException catch (e) {
      throw CustomException(message: e.message);
    }
  }

  @override
  Future<void> deleteRequest(
      {required String userId, required String friendId}) async {
    try {
      await _read(firestoreProvider)
          .collection('users')
          .doc(userId)
          .collection('friends')
          .doc(friendId)
          .delete();
      await _read(firestoreProvider)
          .collection('users')
          .doc(friendId)
          .collection('friends')
          .doc(userId)
          .delete();
    } on FirebaseException catch (e) {
      throw CustomException(message: e.message);
    }
  }

  @override
  Future<List<Friend>> retrieveFriends({required String userId}) async {
    try {
      final snap = await _read(firestoreProvider)
          .doc(userId)
          .collection('friends')
          .get();
      return snap.docs.map((doc) => Friend.fromDocument(doc)).toList();
    } on FirebaseException catch (e) {
      throw CustomException(message: e.message);
    }
  }

  @override
  Future<void> acceptRequest(
      {required String userId, required Friend friend}) async {
    try {
      await _read(firestoreProvider)
          .collection('users')
          .doc(userId)
          .collection('friends')
          .doc(friend.id)
          .update({
        "accepted": true,
      });
      await _read(firestoreProvider)
          .collection('users')
          .doc(friend.id)
          .collection('friends')
          .doc(userId)
          .update({
        "accepted": true,
      });
    } on FirebaseException catch (e) {
      throw CustomException(message: e.message);
    }
  }
}
