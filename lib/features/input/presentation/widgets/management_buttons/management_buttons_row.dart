import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:michro_flutter/core/theme/app_theme.dart';
import 'management_button.dart';
import 'package:michro_flutter/features/restrictions/data/repositories/restriction_repository.dart';
import 'package:michro_flutter/features/restrictions/domain/models/restriction.dart';

class ManagementButtonsRow extends StatelessWidget {
  const ManagementButtonsRow({super.key});

  @override
  Widget build(BuildContext context) => _buildButtonsRow(context);

  Widget _buildButtonsRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildRemindersButton(context),
          _buildGoalsButton(context),
          _buildRestrictionsButton(context),
        ],
      ),
    );
  }

  Widget _buildRemindersButton(BuildContext context) {
    return ManagementButton(
      icon: Icons.notifications_active,
      label: 'Reminders',
      color: AppTheme.primary[700]!,
      onTap: () => _showRemindersDialog(context),
    );
  }

  Widget _buildGoalsButton(BuildContext context) {
    return ManagementButton(
      icon: Icons.track_changes,
      label: 'Goals',
      color: AppTheme.primary[700]!,
      onTap: () => _showGoalsDialog(context),
    );
  }

  Widget _buildRestrictionsButton(BuildContext context) {
    return ManagementButton(
      icon: Icons.block,
      label: 'Restrictions',
      color: AppTheme.primary[700]!,
      onTap: () => _showRestrictionsDialog(context),
    );
  }

  void _showComingSoonSnackBar(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature management coming soon'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  Future<void> _showRestrictionsDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => const RestrictionsDialog(),
    );
  }

  Future<void> _showGoalsDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => const GoalsDialog(),
    );
  }

  Future<void> _showRemindersDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (context) => const RemindersDialog(),
    );
  }
}

class RestrictionsDialog extends StatefulWidget {
  const RestrictionsDialog({super.key});

  @override
  State<RestrictionsDialog> createState() => _RestrictionsDialogState();
}

class _RestrictionsDialogState extends State<RestrictionsDialog> {
  final List<Restriction> _restrictions = [
    Restriction(
      id: '1',
      title: 'Halal',
      description: 'Only consume Halal food',
      type: RestrictionType.food,
      createdAt: DateTime.now(),
    ),
    Restriction(
      id: '2',
      title: 'Seafood Allergy',
      description: 'Allergic to all types of seafood',
      type: RestrictionType.food,
      createdAt: DateTime.now(),
    ),
  ];

  Future<void> _addRestriction(Restriction restriction) async {
    setState(() {
      _restrictions.add(restriction);
    });
  }

  Future<void> _toggleRestriction(Restriction restriction) async {
    final index = _restrictions.indexWhere((r) => r.id == restriction.id);
    if (index != -1) {
      setState(() {
        _restrictions[index] = restriction.copyWith(
          isActive: !restriction.isActive,
        );
      });
    }
  }

  Future<void> _deleteRestriction(String id) async {
    setState(() {
      _restrictions.removeWhere((r) => r.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'My Restrictions',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _restrictions.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      itemCount: _restrictions.length,
                      itemBuilder: (context, index) {
                        final restriction = _restrictions[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: Icon(
                              _getIconForType(restriction.type),
                              color: restriction.isActive
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.grey,
                            ),
                            title: Text(
                              restriction.title,
                              style: TextStyle(
                                decoration: restriction.isActive
                                    ? null
                                    : TextDecoration.lineThrough,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(restriction.description),
                                const SizedBox(height: 4),
                                Text(
                                  restriction.type.label,
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    restriction.isActive
                                        ? Icons.check_circle
                                        : Icons.check_circle_outline,
                                  ),
                                  onPressed: () =>
                                      _toggleRestriction(restriction),
                                  color: restriction.isActive
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.grey,
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline),
                                  onPressed: () =>
                                      _deleteRestriction(restriction.id),
                                  color: Theme.of(context).colorScheme.error,
                                ),
                              ],
                            ),
                            isThreeLine: true,
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => _AddRestrictionDialog(
                    onAdd: _addRestriction,
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Restriction'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.list_alt,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No Restrictions Added',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the + button to add a restriction',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForType(RestrictionType type) {
    return switch (type) {
      RestrictionType.food => Icons.restaurant,
      RestrictionType.activity => Icons.directions_run,
      RestrictionType.medication => Icons.medication,
      RestrictionType.lifestyle => Icons.person,
    };
  }
}

class _AddRestrictionDialog extends StatefulWidget {
  final Function(Restriction) onAdd;

  const _AddRestrictionDialog({required this.onAdd});

  @override
  State<_AddRestrictionDialog> createState() => _AddRestrictionDialogState();
}

class _AddRestrictionDialogState extends State<_AddRestrictionDialog> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  RestrictionType _selectedType = RestrictionType.food;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _handleAdd() {
    if (_titleController.text.isEmpty || _descriptionController.text.isEmpty) {
      return;
    }

    final restriction = Restriction(
      id: DateTime.now().toString(),
      title: _titleController.text,
      description: _descriptionController.text,
      type: _selectedType,
      createdAt: DateTime.now(),
    );

    widget.onAdd(restriction);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Restriction'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                hintText: 'Enter restriction title',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Enter restriction description',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<RestrictionType>(
              value: _selectedType,
              decoration: const InputDecoration(
                labelText: 'Type',
              ),
              items: RestrictionType.values.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type.label),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedType = value;
                  });
                }
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _handleAdd,
          child: const Text('Add'),
        ),
      ],
    );
  }
}

class Goal {
  final String id;
  final String title;
  final String description;
  final DateTime createdAt;
  final bool isActive;

  const Goal({
    required this.id,
    required this.title,
    required this.description,
    required this.createdAt,
    this.isActive = true,
  });

  Goal copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? createdAt,
    bool? isActive,
  }) {
    return Goal(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
    );
  }
}

class GoalsDialog extends StatefulWidget {
  const GoalsDialog({super.key});

  @override
  State<GoalsDialog> createState() => _GoalsDialogState();
}

class _GoalsDialogState extends State<GoalsDialog> {
  final List<Goal> _goals = [
    Goal(
      id: '1',
      title: 'Prevent Hair Loss',
      description:
          'Take necessary supplements and maintain a healthy diet to prevent hair loss',
      createdAt: DateTime(2025, 1, 1),
    ),
  ];

  Future<void> _addGoal(Goal goal) async {
    setState(() {
      _goals.add(goal);
    });
  }

  Future<void> _toggleGoal(Goal goal) async {
    final index = _goals.indexWhere((g) => g.id == goal.id);
    if (index != -1) {
      setState(() {
        _goals[index] = goal.copyWith(
          isActive: !goal.isActive,
        );
      });
    }
  }

  Future<void> _deleteGoal(String id) async {
    setState(() {
      _goals.removeWhere((g) => g.id == id);
    });
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'My Health Goals',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _goals.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      itemCount: _goals.length,
                      itemBuilder: (context, index) {
                        final goal = _goals[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: Icon(
                              Icons.track_changes,
                              color: goal.isActive
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.grey,
                            ),
                            title: Text(
                              goal.title,
                              style: TextStyle(
                                decoration: goal.isActive
                                    ? null
                                    : TextDecoration.lineThrough,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(goal.description),
                                const SizedBox(height: 4),
                                Text(
                                  'Added on ${_formatDate(goal.createdAt)}',
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    goal.isActive
                                        ? Icons.check_circle
                                        : Icons.check_circle_outline,
                                  ),
                                  onPressed: () => _toggleGoal(goal),
                                  color: goal.isActive
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.grey,
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline),
                                  onPressed: () => _deleteGoal(goal.id),
                                  color: Theme.of(context).colorScheme.error,
                                ),
                              ],
                            ),
                            isThreeLine: true,
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => _AddGoalDialog(
                    onAdd: _addGoal,
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Goal'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.track_changes,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No Goals Added',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the + button to add a goal',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
        ],
      ),
    );
  }
}

class _AddGoalDialog extends StatefulWidget {
  final Function(Goal) onAdd;

  const _AddGoalDialog({required this.onAdd});

  @override
  State<_AddGoalDialog> createState() => _AddGoalDialogState();
}

class _AddGoalDialogState extends State<_AddGoalDialog> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _handleAdd() {
    if (_titleController.text.isEmpty || _descriptionController.text.isEmpty) {
      return;
    }

    final goal = Goal(
      id: DateTime.now().toString(),
      title: _titleController.text,
      description: _descriptionController.text,
      createdAt: DateTime.now(),
    );

    widget.onAdd(goal);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Goal'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                hintText: 'Enter goal title',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Enter goal description',
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _handleAdd,
          child: const Text('Add'),
        ),
      ],
    );
  }
}

class Reminder {
  final String id;
  final String title;
  final String description;
  final TimeOfDay time;
  final bool isActive;

  const Reminder({
    required this.id,
    required this.title,
    required this.description,
    required this.time,
    this.isActive = true,
  });

  Reminder copyWith({
    String? id,
    String? title,
    String? description,
    TimeOfDay? time,
    bool? isActive,
  }) {
    return Reminder(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      time: time ?? this.time,
      isActive: isActive ?? this.isActive,
    );
  }
}

class RemindersDialog extends StatefulWidget {
  const RemindersDialog({super.key});

  @override
  State<RemindersDialog> createState() => _RemindersDialogState();
}

class _RemindersDialogState extends State<RemindersDialog> {
  final List<Reminder> _reminders = [
    Reminder(
      id: '1',
      title: 'Take Metformin',
      description: 'Take your daily Metformin medication',
      time: const TimeOfDay(hour: 8, minute: 0),
    ),
  ];

  Future<void> _addReminder(Reminder reminder) async {
    setState(() {
      _reminders.add(reminder);
    });
  }

  Future<void> _toggleReminder(Reminder reminder) async {
    final index = _reminders.indexWhere((r) => r.id == reminder.id);
    if (index != -1) {
      setState(() {
        _reminders[index] = reminder.copyWith(
          isActive: !reminder.isActive,
        );
      });
    }
  }

  Future<void> _deleteReminder(String id) async {
    setState(() {
      _reminders.removeWhere((r) => r.id == id);
    });
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'My Reminders',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _reminders.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      itemCount: _reminders.length,
                      itemBuilder: (context, index) {
                        final reminder = _reminders[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: Icon(
                              Icons.alarm,
                              color: reminder.isActive
                                  ? Theme.of(context).colorScheme.primary
                                  : Colors.grey,
                            ),
                            title: Text(
                              reminder.title,
                              style: TextStyle(
                                decoration: reminder.isActive
                                    ? null
                                    : TextDecoration.lineThrough,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(reminder.description),
                                const SizedBox(height: 4),
                                Text(
                                  'Time: ${_formatTime(reminder.time)}',
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    reminder.isActive
                                        ? Icons.check_circle
                                        : Icons.check_circle_outline,
                                  ),
                                  onPressed: () => _toggleReminder(reminder),
                                  color: reminder.isActive
                                      ? Theme.of(context).colorScheme.primary
                                      : Colors.grey,
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline),
                                  onPressed: () => _deleteReminder(reminder.id),
                                  color: Theme.of(context).colorScheme.error,
                                ),
                              ],
                            ),
                            isThreeLine: true,
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => _AddReminderDialog(
                    onAdd: _addReminder,
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Reminder'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.alarm,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No Reminders Added',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the + button to add a reminder',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
        ],
      ),
    );
  }
}

class _AddReminderDialog extends StatefulWidget {
  final Function(Reminder) onAdd;

  const _AddReminderDialog({required this.onAdd});

  @override
  State<_AddReminderDialog> createState() => _AddReminderDialogState();
}

class _AddReminderDialogState extends State<_AddReminderDialog> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  TimeOfDay _selectedTime = TimeOfDay.now();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  void _handleAdd() {
    if (_titleController.text.isEmpty || _descriptionController.text.isEmpty) {
      return;
    }

    final reminder = Reminder(
      id: DateTime.now().toString(),
      title: _titleController.text,
      description: _descriptionController.text,
      time: _selectedTime,
    );

    widget.onAdd(reminder);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Reminder'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                hintText: 'Enter reminder title',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Enter reminder description',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Time'),
              subtitle: Text(_formatTime(_selectedTime)),
              trailing: const Icon(Icons.access_time),
              onTap: _selectTime,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _handleAdd,
          child: const Text('Add'),
        ),
      ],
    );
  }
}
