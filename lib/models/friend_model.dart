import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'friend_model.freezed.dart';
part 'friend_model.g.dart';

@freezed
class Friend with _$Friend {
  const Friend._();
  const factory Friend({
    required String id,
    required String sender,
    @Default(false) bool accepted,
  }) = _Friend;

  factory Friend.fromJson(Map<String, dynamic> json) => _$FriendFromJson(json);

  factory Friend.fromDocument(DocumentSnapshot doc) {
    final data = doc.data()!;
    return Friend.fromJson(data as Map<String, dynamic>).copyWith(id: doc.id);
  }

  Map<String, dynamic> toDocument() => toJson()..remove('id');
}
