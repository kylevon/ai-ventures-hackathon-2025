import 'package:flutter/material.dart';
import '../../../shared/presentation/widgets/section_nav_bar.dart';
import 'calendar_screen.dart';
import '../widgets/clock_view.dart';
import '../../../nutrition_dashboard/presentation/pages/nutrition_dashboard_page.dart';
import '../../data/services/mock_event_service.dart';
import '../../domain/models/calendar_event.dart';

class CalendarSectionScreen extends StatefulWidget {
  const CalendarSectionScreen({super.key});

  @override
  State<CalendarSectionScreen> createState() => _CalendarSectionScreenState();
}

class _CalendarSectionScreenState extends State<CalendarSectionScreen> {
  final _eventService = MockEventService();
  List<CalendarEvent> _events = [];
  bool _isLoading = true;
  int _selectedTopIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    setState(() => _isLoading = true);
    try {
      // First try to fetch from server to sync
      await _eventService.fetchEvents();
      // Then get from cache to ensure both views use the same data
      final events = _eventService.getCachedEvents();
      if (mounted) {
        setState(() {
          _events = events;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          // Even if server sync fails, try to get cached events
          _events = _eventService.getCachedEvents();
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to sync with server')),
        );
      }
    }
  }

  void _onTopDestinationSelected(int index) {
    setState(() {
      _selectedTopIndex = index;
    });
  }

  Widget _buildCurrentView() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    switch (_selectedTopIndex) {
      case 0:
        return CalendarScreen(
          onEventsChanged: (events) {
            setState(() => _events = events);
          },
        );
      case 1:
        return ClockView(
          events: _events,
          onEventAdded: (event) async {
            await _eventService.addEvent(event);
            _loadEvents(); // Refresh both views
          },
          onEventUpdated: (event) async {
            await _eventService.updateEvent(event);
            _loadEvents(); // Refresh both views
          },
          onEventDeleted: (eventId) async {
            await _eventService.deleteEvent(eventId);
            _loadEvents(); // Refresh both views
          },
        );
      case 2:
        return const NutritionDashboardPage();
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Habits'),
        actions: [
          if (_eventService.needsSync())
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadEvents,
            tooltip: 'Sync with server',
          ),
        ],
      ),
      body: Column(
        children: [
          SectionNavBar(
            selectedIndex: _selectedTopIndex,
            onDestinationSelected: _onTopDestinationSelected,
          ),
          Expanded(
            child: _buildCurrentView(),
          ),
        ],
      ),
    );
  }
}
