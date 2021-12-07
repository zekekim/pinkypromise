import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pinkypromise/models/friend_model.dart';
import 'package:pinkypromise/providers/providers.dart';
import 'package:pinkypromise/repos/custom_exception.dart';
import 'package:pinkypromise/repos/friend_repo.dart';

import 'auth_controller.dart';

final friendListController =
    StateNotifierProvider<FriendListController, List<Friend>>((ref) {
  final user = ref.watch(authControllerProvider);
  return FriendListController(ref.read, user?.uid);
});

class FriendListController extends StateNotifier<List<Friend>> {
  final Reader _read;
  final String? _userId;

  StreamSubscription<QuerySnapshot?>? _friendsStreamSubscription;

  FriendListController(this._read, this._userId) : super([]) {
    _friendsStreamSubscription?.cancel();
    _friendsStreamSubscription = _read(friendRepositoryProvider)
        .friendsStateChanges
        .listen((list) =>
            state = list.docs.map((doc) => Friend.fromDocument(doc)).toList());
  }

  Future<void> retrieveItems({bool isRefreshing = false}) async {
    try {
      final friends = await _read(friendRepositoryProvider)
          .retrieveFriends(userId: _userId!);
    } on CustomException catch (e, st) {
      //TODO:
    }
  }

  Future<void> sendRequest({required String friendId}) async {
    try {
      final friend = Friend(id: friendId, sender: _userId!, accepted: false);
      final itemId = await _read(friendRepositoryProvider).createRequest(
        userId: _userId!,
        friend: friend,
      );
    } on CustomException catch (e, st) {}
  }

  Future<void> acceptRequest({required String friendId}) async {
    try {
      final updatedFriend =
          Friend(id: friendId, sender: _userId!, accepted: true);
      await _read(friendRepositoryProvider).acceptRequest(
        userId: _userId!,
        friend: updatedFriend,
      );
    } on CustomException catch (e, st) {}
  }

  Future<void> deleteRequest({required String friendId}) async {
    try {
      await _read(friendRepositoryProvider).deleteRequest(
        userId: _userId!,
        friendId: friendId,
      );
    } on CustomException catch (e, st) {}
  }
}
