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
      eventType: $enumDecode(_$EventTypeEnumMap, json['eventType']),
    );

Map<String, dynamic> _$$FreeFormEventImplToJson(_$FreeFormEventImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'description': instance.description,
      'timestamp': instance.timestamp.toIso8601String(),
      'eventType': _$EventTypeEnumMap[instance.eventType]!,
    };

const _$EventTypeEnumMap = {
  EventType.exercise: 'exercise',
  EventType.sleep: 'sleep',
  EventType.food: 'food',
  EventType.liquids: 'liquids',
  EventType.period: 'period',
  EventType.bowelMovement: 'bowelMovement',
  EventType.heartRate: 'heartRate',
  EventType.appointments: 'appointments',
  EventType.mood: 'mood',
  EventType.symptoms: 'symptoms',
  EventType.misc: 'misc',
  EventType.pills: 'pills',
};
