import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/task_model.dart';
import '../providers/task_provider.dart';
import '../theme/app_theme.dart';

class AddTaskScreen extends StatefulWidget {
  final Task? task;

  const AddTaskScreen({Key? key, this.task}) : super(key: key);

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _estimatedTimeController = TextEditingController();
  DateTime? _deadline;
  String _priority = 'Medium';
  final List<String> _tags = [];
  final _tagController = TextEditingController();
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    print('init${widget.task}');
    if (widget.task != null) {
      print('inside');
      // Edit mode - populate fields with existing task data
      _titleController.text = widget.task!.title ?? '';
      _descriptionController.text = widget.task!.description ?? '';
      _estimatedTimeController.text = widget.task!.estimatedTime ?? '';
      _deadline = widget.task!.deadline;
      _priority = widget.task!.priority;
      if (widget.task!.tags != null) {
        _tags.addAll(widget.task!.tags!);
      }
      _isCompleted = widget.task!.completed;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _estimatedTimeController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  void _addTag() {
    final tag = _tagController.text.trim();
    if (tag.isNotEmpty && !_tags.contains(tag)) {
      setState(() {
        _tags.add(tag);
        _tagController.clear();
      });
    }
  }

  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
    });
  }

  Future<void> _selectDeadline() async {
    DatePicker.showDateTimePicker(
      context,
      showTitleActions: true,
      minTime: DateTime.now(),
      onConfirm: (date) {
        setState(() {
          _deadline = date;
        });
      },
      currentTime: _deadline ?? DateTime.now(),
      locale: LocaleType.en,
    );
  }

  Future<void> _saveTask() async {
    if (_formKey.currentState!.validate()) {
      final taskProvider = Provider.of<TaskProvider>(context, listen: false);

      final task = Task(
        id: widget.task?.id,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        deadline: _deadline,
        tags: _tags.isEmpty ? null : _tags,
        priority: _priority,
        estimatedTime: _estimatedTimeController.text.trim(),
        completed: _isCompleted,
      );

      bool success;
      if (widget.task == null) {
        // Create new task
        final newTask = await taskProvider.createTask(task);
        success = newTask != null;
      } else {
        // Update existing task
        final updatedTask = await taskProvider.updateTask(task);
        success = updatedTask != null;
      }

      if (success && mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'Add Task' : 'Edit Task'),
        actions: [
          if (widget.task != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Delete Task'),
                    content: const Text(
                        'Are you sure you want to delete this task?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                );

                if (confirmed == true && mounted) {
                  await taskProvider.deleteTask(widget.task!.id!);
                  if (mounted) {
                    Navigator.pop(context);
                  }
                }
              },
            ),
        ],
      ),
      body: taskProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title field
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        hintText: 'Enter task title',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a title';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Description field
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        hintText: 'Enter task description (optional)',
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),

                    // Priority selection
                    Text(
                      'Priority',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    SegmentedButton<String>(
                      segments: [
                        ButtonSegment(
                          value: 'Low',
                          label: const Text('Low'),
                          icon: const Icon(
                            Icons.arrow_downward,
                          ),
                        ),
                        ButtonSegment(
                          value: 'Medium',
                          label: const Text('Medium'),
                          icon: const Icon(Icons.remove),
                        ),
                        ButtonSegment(
                          value: 'High',
                          label: const Text('High'),
                          icon: const Icon(Icons.arrow_upward),
                        ),
                      ],
                      selected: {_priority},
                      onSelectionChanged: (Set<String> selection) {
                        setState(() {
                          _priority = selection.first;
                        });
                      },
                    ),
                    const SizedBox(height: 16),

                    // Deadline selection
                    Text(
                      'Deadline',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        _deadline == null
                            ? 'No deadline set'
                            : 'Deadline: ${DateFormat('MMM d, yyyy - h:mm a').format(_deadline!)}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.calendar_today),
                            onPressed: _selectDeadline,
                          ),
                          if (_deadline != null)
                            IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                setState(() {
                                  _deadline = null;
                                });
                              },
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Estimated time
                    TextFormField(
                      controller: _estimatedTimeController,
                      decoration: const InputDecoration(
                        labelText: 'Estimated Time',
                        hintText: 'e.g., 2 hours, 30 minutes (optional)',
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Tags
                    Text(
                      'Tags',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _tagController,
                            decoration: const InputDecoration(
                              hintText: 'Add a tag',
                            ),
                            onFieldSubmitted: (_) => _addTag(),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: _addTag,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: _tags.map((tag) {
                        return Chip(
                          label: Text(tag),
                          onDeleted: () => _removeTag(tag),
                          backgroundColor:
                              theme.colorScheme.primary.withOpacity(0.7),
                          labelStyle: TextStyle(
                            color: theme.colorScheme.onPrimary,
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),

                    // Completed checkbox (only for edit mode)
                    if (widget.task != null)
                      CheckboxListTile(
                        title: const Text('Mark as completed'),
                        value: _isCompleted,
                        onChanged: (value) {
                          setState(() {
                            _isCompleted = value ?? false;
                          });
                        },
                        contentPadding: EdgeInsets.zero,
                      ),
                    const SizedBox(height: 24),

                    // Error message
                    if (taskProvider.error != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Text(
                          taskProvider.error!,
                          style: TextStyle(
                            color: theme.colorScheme.error,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                    // Save button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: taskProvider.isLoading ? null : _saveTask,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: Text(
                            widget.task == null ? 'Add Task' : 'Update Task',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
