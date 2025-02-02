import 'package:freezed_annotation/freezed_annotation.dart';
import 'event.dart';

part 'exercise_event.freezed.dart';
part 'exercise_event.g.dart';

@freezed
class ExerciseEvent extends Event with _$ExerciseEvent {
  const factory ExerciseEvent({
    required String id,
    required String title,
    required String description,
    required DateTime date,
    required String activity,
    required int duration,
    required String intensity,
  }) = _ExerciseEvent;

  factory ExerciseEvent.fromJson(Map<String, dynamic> json) =>
      _$ExerciseEventFromJson(json);
}
