import 'package:flutter/material.dart';
import '../widgets/calendar_widget.dart';
import '../widgets/event_details_dialog.dart';
import '../widgets/food_event_form.dart';
import '../../domain/models/calendar_event.dart';
import '../../data/services/mock_event_service.dart';
import 'package:logging/logging.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final _eventService = MockEventService();
  final _logger = Logger('CalendarScreen');
  List<CalendarEvent> _events = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    if (_isLoading) return;
    _logger.info('Loading events from cache...');
    setState(() => _isLoading = true);
    try {
      final events = _eventService.getCachedEvents();
      if (mounted) {
        setState(() => _events = events);
        _logger.info('Loaded ${events.length} events from cache');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _handleEventTap(CalendarEvent event) {
    showDialog(
      context: context,
      builder: (context) => EventDetailsDialog(
        event: event,
        onDelete: () async {
          _logger.info('Deleting event: ${event.id}');
          await _eventService.deleteEvent(event.id);
          if (context.mounted) {
            Navigator.of(context).pop();
            await _loadEvents(); // Refresh from cache
            _logger.info('Event deleted and view refreshed');
          }
        },
        onUpdate: (updatedEvent) async {
          _logger.info('Updating event: ${event.id}');
          await _eventService.updateEvent(updatedEvent);
          if (context.mounted) {
            Navigator.of(context).pop();
            await _loadEvents(); // Refresh from cache
            _logger.info('Event updated and view refreshed');
          }
        },
      ),
    );
  }

  void _showAddDialog(DateTime selectedDay) {
    showDialog<CalendarEvent>(
      context: context,
      builder: (context) => Dialog(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: FoodEventForm(
                  selectedDate: selectedDay,
                  onSave: (newEvent) async {
                    await _eventService.addEvent(newEvent);
                    if (context.mounted) {
                      Navigator.of(context).pop(newEvent);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    ).then((newEvent) {
      if (newEvent != null) {
        _loadEvents(); // Refresh from cache
      }
    });
  }

  Future<void> _handleSync() async {
    if (_isLoading) return;
    _logger.info('Syncing with server...');
    setState(() => _isLoading = true);
    try {
      final events = await _eventService.fetchEvents();
      if (mounted) {
        setState(() => _events = events);
        _logger.info('Synced ${events.length} events from server');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Calendar synced')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: CalendarWidget(
            events: _events,
            onDaySelected: null,
            onEventTap: _handleEventTap,
            onAddEvent: _showAddDialog,
          ),
        ),
        Positioned(
          right: 16,
          bottom: 16,
          child: FloatingActionButton(
            onPressed: _isLoading ? null : _handleSync,
            tooltip: 'Sync Calendar',
            child: _isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Icon(Icons.sync),
          ),
        ),
      ],
    );
  }
}
