import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/constants/event_types.dart';

part 'free_form_event.freezed.dart';
part 'free_form_event.g.dart';

@freezed
class FreeFormEvent with _$FreeFormEvent {
  const factory FreeFormEvent({
    required String id,
    required String description,
    required DateTime timestamp,
    required EventType eventType,
  }) = _FreeFormEvent;

  factory FreeFormEvent.fromJson(Map<String, dynamic> json) =>
      _$FreeFormEventFromJson(json);
}
