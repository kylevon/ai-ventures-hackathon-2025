import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/models/restriction.dart';
import '../../data/repositories/restriction_repository.dart';

class RestrictionsPage extends StatefulWidget {
  const RestrictionsPage({super.key});

  @override
  State<RestrictionsPage> createState() => _RestrictionsPageState();
}

class _RestrictionsPageState extends State<RestrictionsPage> {
  late final RestrictionRepository _repository;
  List<Restriction> _restrictions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeRepository();
  }

  Future<void> _initializeRepository() async {
    final prefs = await SharedPreferences.getInstance();
    _repository = RestrictionRepository(prefs);
    await _loadRestrictions();

    // Add default restrictions if none exist
    if (_restrictions.isEmpty) {
      await _addDefaultRestrictions();
    }
  }

  Future<void> _addDefaultRestrictions() async {
    // Add medication timing restriction
    await _addRestriction(
      Restriction(
        id: DateTime.now().toString(),
        title: 'Metformin Schedule',
        description: 'Take Metformin between 7:30 AM and 8:50 AM',
        type: RestrictionType.medication,
        createdAt: DateTime.now(),
      ),
    );

    // Add symptom monitoring restrictions
    final symptoms = {
      'Headache': '16:00',
      'Dizziness': '15:45',
      'Nausea': '11:30',
      'Brain Fog': '13:15',
      'Fatigue': '14:30',
    };

    for (final symptom in symptoms.entries) {
      await _addRestriction(
        Restriction(
          id: DateTime.now().toString(),
          title: 'Monitor ${symptom.key}',
          description:
              'Pay attention to ${symptom.key.toLowerCase()} symptoms around ${symptom.value}',
          type: RestrictionType.lifestyle,
          createdAt: DateTime.now(),
        ),
      );
    }
  }

  Future<void> _loadRestrictions() async {
    setState(() {
      _isLoading = true;
    });

    final restrictions = await _repository.getRestrictions();
    setState(() {
      _restrictions = restrictions;
      _isLoading = false;
    });
  }

  Future<void> _addRestriction(Restriction restriction) async {
    await _repository.addRestriction(restriction);
    await _loadRestrictions();
  }

  Future<void> _toggleRestriction(Restriction restriction) async {
    final updatedRestriction = restriction.copyWith(
      isActive: !restriction.isActive,
    );
    await _repository.updateRestriction(updatedRestriction);
    await _loadRestrictions();
  }

  Future<void> _deleteRestriction(String id) async {
    await _repository.deleteRestriction(id);
    await _loadRestrictions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Restrictions'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _restrictions.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _restrictions.length,
                  itemBuilder: (context, index) {
                    final restriction = _restrictions[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
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
                                color: Theme.of(context).colorScheme.primary,
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
                              onPressed: () => _toggleRestriction(restriction),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => _AddRestrictionDialog(
              onAdd: _addRestriction,
            ),
          );
        },
        child: const Icon(Icons.add),
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
