import 'package:freezed_annotation/freezed_annotation.dart';

part 'free_form_event.freezed.dart';
part 'free_form_event.g.dart';

@freezed
class FreeFormEvent with _$FreeFormEvent {
  const factory FreeFormEvent({
    required String id,
    required String description,
    required DateTime timestamp,
  }) = _FreeFormEvent;

  factory FreeFormEvent.fromJson(Map<String, dynamic> json) =>
      _$FreeFormEventFromJson(json);
}
