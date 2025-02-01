import 'package:flutter/material.dart';
import '../widgets/calendar_widget.dart';
import '../../domain/models/calendar_event.dart';
import '../../data/services/mock_food_service.dart';
import '../../data/services/food_cache_service.dart';
import '../../domain/models/food_event.dart';
import '../widgets/food_event_form.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final _foodService = MockFoodService();
  final _cacheService = FoodCacheService();
  List<CalendarEvent> _events = [];
  bool _isSyncing = false;

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    if (_cacheService.needsSync()) {
      await _syncWithServer();
    } else {
      setState(() {
        _events = _cacheService.getAllEvents();
      });
      print('Loaded ${_events.length} events from cache');
    }
  }

  Future<void> _syncWithServer() async {
    setState(() => _isSyncing = true);
    try {
      await _foodService.fetchEvents();
      setState(() {
        _events = _cacheService.getAllEvents();
      });
      print('Synced ${_events.length} events from server');
    } catch (e) {
      print('Error syncing with server: $e');
      // If sync fails, use cached data if available
      setState(() {
        _events = _cacheService.getAllEvents();
      });
      print('Falling back to ${_events.length} cached events');
    } finally {
      setState(() => _isSyncing = false);
    }
  }

  void _handleDaySelected(DateTime selectedDay) {
    // No longer showing nutritional summary
  }

  void _handleEventTap(CalendarEvent event) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppBar(
              title: const Text('Edit Food Event'),
              automaticallyImplyLeading: false,
              actions: [
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Delete Event'),
                        content: const Text(
                            'Are you sure you want to delete this event?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            style: TextButton.styleFrom(
                              foregroundColor:
                                  Theme.of(context).colorScheme.error,
                            ),
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    );

                    if (confirmed == true && mounted) {
                      try {
                        await _foodService.deleteEvent(event.id!);
                        setState(() {
                          _events = _cacheService.getAllEvents();
                        });
                        if (mounted) {
                          Navigator.of(context).pop(); // Close the edit dialog
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Event deleted successfully')),
                          );
                        }
                      } catch (e) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error deleting event: $e')),
                          );
                        }
                      }
                    }
                  },
                  tooltip: 'Delete event',
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            Expanded(
              child: FoodEventForm(
                event: event,
                selectedDate: event.startDate,
                onSave: (updatedEvent) async {
                  try {
                    await _foodService.updateEvent(updatedEvent);
                    setState(() {
                      _events = _cacheService.getAllEvents();
                    });
                    if (mounted) {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Event updated successfully')),
                      );
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error updating event: $e')),
                      );
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleAddEvent(DateTime selectedDay) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppBar(
              title: const Text('Add Food Event'),
              automaticallyImplyLeading: false,
              actions: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            Expanded(
              child: FoodEventForm(
                selectedDate: selectedDay,
                onSave: (newEvent) async {
                  try {
                    await _foodService.addEvent(newEvent);
                    setState(() {
                      _events = _cacheService.getAllEvents();
                    });
                    if (mounted) {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Event added successfully')),
                      );
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error adding event: $e')),
                      );
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Calendar'),
        actions: [
          if (_isSyncing)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                ),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.sync),
              onPressed: _syncWithServer,
              tooltip: 'Sync with server',
            ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: Implement filter functionality
            },
          ),
        ],
      ),
      body: CalendarWidget(
        events: _events,
        onDaySelected: _handleDaySelected,
        onEventTap: _handleEventTap,
        onAddEvent: _handleAddEvent,
      ),
    );
  }
}
