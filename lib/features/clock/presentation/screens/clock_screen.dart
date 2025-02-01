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
    print('Clock Screen loaded ${events.length} events:');
    for (final event in events) {
      print('- ${event.title} at ${event.date.hour}:${event.date.minute}');
    }
    setState(() {
      _events = events;
      _isLoading = false;
    });
  }

  void _handleEventTap(Event event) {
    // Handle event tap if needed
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ClockView(
      events: _events,
      onEventTap: _handleEventTap,
    );
  }
}
