import 'package:flutter/material.dart';
import 'package:michro_flutter/features/shared/domain/models/event.dart';

class CalendarEventsManager extends ChangeNotifier {
  List<Event> _events = [];
  bool _isLoading = false;

  List<Event> get events => List.unmodifiable(_events);
  bool get isLoading => _isLoading;

  void setEvents(List<Event> events) {
    _events = events;
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void addEvent(Event event) {
    _events = [..._events, event];
    notifyListeners();
  }

  void updateEvent(Event event) {
    _events = _events.map((e) => e.id == event.id ? event : e).toList();
    notifyListeners();
  }

  void deleteEvent(String id) {
    _events = _events.where((e) => e.id != id).toList();
    notifyListeners();
  }
}
