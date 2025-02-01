import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/clock_view.dart';
import 'package:michro_flutter/features/shared/domain/models/event.dart';
import '../controllers/clock_controller.dart';

class ClockScreen extends ConsumerStatefulWidget {
  const ClockScreen({super.key});

  @override
  ConsumerState<ClockScreen> createState() => _ClockScreenState();
}

class _ClockScreenState extends ConsumerState<ClockScreen> {
  List<Event> _events = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    final controller = ref.read(clockControllerProvider);
    final events = await controller.loadEvents();
    setState(() {
      _events = events;
      _isLoading = false;
    });
  }

  Future<void> _handleEventAdded(Event event) async {
    final controller = ref.read(clockControllerProvider);
    final newEvent = await controller.addEvent(event);
    setState(() {
      _events = [..._events, newEvent];
    });
  }

  Future<void> _handleEventUpdated(Event event) async {
    final controller = ref.read(clockControllerProvider);
    final updatedEvent = await controller.updateEvent(event);
    setState(() {
      _events =
          _events.map((e) => e.id == event.id ? updatedEvent : e).toList();
    });
  }

  Future<void> _handleEventDeleted(String id) async {
    final controller = ref.read(clockControllerProvider);
    await controller.deleteEvent(id);
    setState(() {
      _events = _events.where((e) => e.id != id).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ClockView(
      events: _events,
      radius: 150,
      onEventAdded: _handleEventAdded,
      onEventUpdated: _handleEventUpdated,
      onEventDeleted: _handleEventDeleted,
    );
  }
}
