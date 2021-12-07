// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'friend_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Friend _$FriendFromJson(Map<String, dynamic> json) {
  return _Friend.fromJson(json);
}

/// @nodoc
class _$FriendTearOff {
  const _$FriendTearOff();

  _Friend call(
      {required String id, required String sender, bool accepted = false}) {
    return _Friend(
      id: id,
      sender: sender,
      accepted: accepted,
    );
  }

  Friend fromJson(Map<String, Object> json) {
    return Friend.fromJson(json);
  }
}

/// @nodoc
const $Friend = _$FriendTearOff();

/// @nodoc
mixin _$Friend {
  String get id => throw _privateConstructorUsedError;
  String get sender => throw _privateConstructorUsedError;
  bool get accepted => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FriendCopyWith<Friend> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FriendCopyWith<$Res> {
  factory $FriendCopyWith(Friend value, $Res Function(Friend) then) =
      _$FriendCopyWithImpl<$Res>;
  $Res call({String id, String sender, bool accepted});
}

/// @nodoc
class _$FriendCopyWithImpl<$Res> implements $FriendCopyWith<$Res> {
  _$FriendCopyWithImpl(this._value, this._then);

  final Friend _value;
  // ignore: unused_field
  final $Res Function(Friend) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? sender = freezed,
    Object? accepted = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      sender: sender == freezed
          ? _value.sender
          : sender // ignore: cast_nullable_to_non_nullable
              as String,
      accepted: accepted == freezed
          ? _value.accepted
          : accepted // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
abstract class _$FriendCopyWith<$Res> implements $FriendCopyWith<$Res> {
  factory _$FriendCopyWith(_Friend value, $Res Function(_Friend) then) =
      __$FriendCopyWithImpl<$Res>;
  @override
  $Res call({String id, String sender, bool accepted});
}

/// @nodoc
class __$FriendCopyWithImpl<$Res> extends _$FriendCopyWithImpl<$Res>
    implements _$FriendCopyWith<$Res> {
  __$FriendCopyWithImpl(_Friend _value, $Res Function(_Friend) _then)
      : super(_value, (v) => _then(v as _Friend));

  @override
  _Friend get _value => super._value as _Friend;

  @override
  $Res call({
    Object? id = freezed,
    Object? sender = freezed,
    Object? accepted = freezed,
  }) {
    return _then(_Friend(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      sender: sender == freezed
          ? _value.sender
          : sender // ignore: cast_nullable_to_non_nullable
              as String,
      accepted: accepted == freezed
          ? _value.accepted
          : accepted // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Friend extends _Friend with DiagnosticableTreeMixin {
  const _$_Friend(
      {required this.id, required this.sender, this.accepted = false})
      : super._();

  factory _$_Friend.fromJson(Map<String, dynamic> json) =>
      _$$_FriendFromJson(json);

  @override
  final String id;
  @override
  final String sender;
  @JsonKey(defaultValue: false)
  @override
  final bool accepted;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Friend(id: $id, sender: $sender, accepted: $accepted)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Friend'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('sender', sender))
      ..add(DiagnosticsProperty('accepted', accepted));
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _Friend &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.sender, sender) ||
                const DeepCollectionEquality().equals(other.sender, sender)) &&
            (identical(other.accepted, accepted) ||
                const DeepCollectionEquality()
                    .equals(other.accepted, accepted)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(sender) ^
      const DeepCollectionEquality().hash(accepted);

  @JsonKey(ignore: true)
  @override
  _$FriendCopyWith<_Friend> get copyWith =>
      __$FriendCopyWithImpl<_Friend>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_FriendToJson(this);
  }
}

abstract class _Friend extends Friend {
  const factory _Friend(
      {required String id, required String sender, bool accepted}) = _$_Friend;
  const _Friend._() : super._();

  factory _Friend.fromJson(Map<String, dynamic> json) = _$_Friend.fromJson;

  @override
  String get id => throw _privateConstructorUsedError;
  @override
  String get sender => throw _privateConstructorUsedError;
  @override
  bool get accepted => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$FriendCopyWith<_Friend> get copyWith => throw _privateConstructorUsedError;
}
