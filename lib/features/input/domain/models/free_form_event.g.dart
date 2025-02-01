// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'free_form_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FreeFormEventImpl _$$FreeFormEventImplFromJson(Map<String, dynamic> json) =>
    _$FreeFormEventImpl(
      id: json['id'] as String,
      description: json['description'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );

Map<String, dynamic> _$$FreeFormEventImplToJson(_$FreeFormEventImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'timestamp': instance.timestamp.toIso8601String(),
    };
