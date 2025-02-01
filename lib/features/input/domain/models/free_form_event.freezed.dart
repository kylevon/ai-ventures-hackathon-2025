// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'free_form_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FreeFormEvent _$FreeFormEventFromJson(Map<String, dynamic> json) {
  return _FreeFormEvent.fromJson(json);
}

/// @nodoc
mixin _$FreeFormEvent {
  String get id => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;

  /// Serializes this FreeFormEvent to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FreeFormEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FreeFormEventCopyWith<FreeFormEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FreeFormEventCopyWith<$Res> {
  factory $FreeFormEventCopyWith(
          FreeFormEvent value, $Res Function(FreeFormEvent) then) =
      _$FreeFormEventCopyWithImpl<$Res, FreeFormEvent>;
  @useResult
  $Res call({String id, String description, DateTime timestamp});
}

/// @nodoc
class _$FreeFormEventCopyWithImpl<$Res, $Val extends FreeFormEvent>
    implements $FreeFormEventCopyWith<$Res> {
  _$FreeFormEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FreeFormEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? description = null,
    Object? timestamp = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$FreeFormEventImplCopyWith<$Res>
    implements $FreeFormEventCopyWith<$Res> {
  factory _$$FreeFormEventImplCopyWith(
          _$FreeFormEventImpl value, $Res Function(_$FreeFormEventImpl) then) =
      __$$FreeFormEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String description, DateTime timestamp});
}

/// @nodoc
class __$$FreeFormEventImplCopyWithImpl<$Res>
    extends _$FreeFormEventCopyWithImpl<$Res, _$FreeFormEventImpl>
    implements _$$FreeFormEventImplCopyWith<$Res> {
  __$$FreeFormEventImplCopyWithImpl(
      _$FreeFormEventImpl _value, $Res Function(_$FreeFormEventImpl) _then)
      : super(_value, _then);

  /// Create a copy of FreeFormEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? description = null,
    Object? timestamp = null,
  }) {
    return _then(_$FreeFormEventImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FreeFormEventImpl implements _FreeFormEvent {
  const _$FreeFormEventImpl(
      {required this.id, required this.description, required this.timestamp});

  factory _$FreeFormEventImpl.fromJson(Map<String, dynamic> json) =>
      _$$FreeFormEventImplFromJson(json);

  @override
  final String id;
  @override
  final String description;
  @override
  final DateTime timestamp;

  @override
  String toString() {
    return 'FreeFormEvent(id: $id, description: $description, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FreeFormEventImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, description, timestamp);

  /// Create a copy of FreeFormEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FreeFormEventImplCopyWith<_$FreeFormEventImpl> get copyWith =>
      __$$FreeFormEventImplCopyWithImpl<_$FreeFormEventImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FreeFormEventImplToJson(
      this,
    );
  }
}

abstract class _FreeFormEvent implements FreeFormEvent {
  const factory _FreeFormEvent(
      {required final String id,
      required final String description,
      required final DateTime timestamp}) = _$FreeFormEventImpl;

  factory _FreeFormEvent.fromJson(Map<String, dynamic> json) =
      _$FreeFormEventImpl.fromJson;

  @override
  String get id;
  @override
  String get description;
  @override
  DateTime get timestamp;

  /// Create a copy of FreeFormEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FreeFormEventImplCopyWith<_$FreeFormEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
