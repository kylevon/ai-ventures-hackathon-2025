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
      onTap: () => _showComingSoonSnackBar(context, 'Reminders'),
    );
  }

  Widget _buildGoalsButton(BuildContext context) {
    return ManagementButton(
      icon: Icons.track_changes,
      label: 'Goals',
      color: AppTheme.primary[700]!,
      onTap: () => _showComingSoonSnackBar(context, 'Goals'),
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
