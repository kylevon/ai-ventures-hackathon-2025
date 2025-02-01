import 'package:flutter/material.dart';
import '../widgets/calendar_widget.dart';
import '../../domain/models/calendar_event.dart';
import '../controllers/calendar_controller.dart';
import '../dialogs/delete_event_dialog.dart';
import '../dialogs/edit_event_dialog.dart';
import '../dialogs/add_event_dialog.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late final CalendarController _controller;
  List<CalendarEvent> _events = [];
  bool _isSyncing = false;

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  void _initializeController() {
    _controller = CalendarController(
      onEventsChanged: (events) => setState(() => _events = events),
      onSyncStateChanged: (isSyncing) => setState(() => _isSyncing = isSyncing),
    );
    _controller.loadInitialEvents();
  }

  Future<void> _handleEventDeletion(
      CalendarEvent event, BuildContext dialogContext) async {
    final confirmed = await showDeleteEventDialog(context);
    if (confirmed == true && mounted) {
      await _controller.deleteEvent(event.id);
      Navigator.of(dialogContext).pop();
      _showSuccessMessage('Event deleted successfully');
    }
  }

  Future<void> _handleEventUpdate(CalendarEvent event) async {
    await _controller.updateEvent(event);
    _showSuccessMessage('Event updated successfully');
  }

  Future<void> _handleEventAdd(CalendarEvent event) async {
    await _controller.addEvent(event);
    _showSuccessMessage('Event added successfully');
  }

  void _showSuccessMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildCalendar(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('Food Calendar'),
      actions: [
        if (_isSyncing)
          const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          )
        else
          IconButton(
            icon: const Icon(Icons.sync),
            onPressed: _controller.syncWithServer,
            tooltip: 'Sync with server',
          ),
        IconButton(
          icon: const Icon(Icons.filter_list),
          onPressed: () {
            // TODO: Implement filter functionality
          },
        ),
      ],
    );
  }

  Widget _buildCalendar() {
    return CalendarWidget(
      events: _events,
      onDaySelected: (_) {},
      onEventTap: _showEditDialog,
      onAddEvent: _showAddDialog,
    );
  }

  void _showEditDialog(CalendarEvent event) {
    showDialog(
      context: context,
      builder: (dialogContext) => EditEventDialog(
        event: event,
        onSave: _handleEventUpdate,
        onDelete: () => _handleEventDeletion(event, dialogContext),
      ),
    );
  }

  void _showAddDialog(DateTime selectedDay) {
    showDialog(
      context: context,
      builder: (context) => AddEventDialog(
        selectedDate: selectedDay,
        onSave: _handleEventAdd,
      ),
    );
  }
}
