// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Friend _$$_FriendFromJson(Map<String, dynamic> json) => _$_Friend(
      id: json['id'] as String,
      sender: json['sender'] as String,
      accepted: json['accepted'] as bool? ?? false,
    );

Map<String, dynamic> _$$_FriendToJson(_$_Friend instance) => <String, dynamic>{
      'id': instance.id,
      'sender': instance.sender,
      'accepted': instance.accepted,
    };
