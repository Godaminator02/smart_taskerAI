import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/ai_suggestion_model.dart';
import '../models/task_model.dart';
import '../providers/task_provider.dart';
import '../widgets/ai_suggestion_card.dart';
import 'add_task_screen.dart';

class AIAssistScreen extends StatefulWidget {
  const AIAssistScreen({Key? key}) : super(key: key);

  @override
  State<AIAssistScreen> createState() => _AIAssistScreenState();
}

class _AIAssistScreenState extends State<AIAssistScreen> {
  int _selectedTabIndex = 0;
  bool _isLoadingPrioritization = false;
  bool _isLoadingTimeEstimate = false;
  bool _isLoadingTaskRewrite = false;

  // Time estimate fields
  final _timeEstimateTitleController = TextEditingController();
  final _timeEstimateDescController = TextEditingController();
  final List<String> _timeEstimateTags = [];
  final _timeEstimateTagController = TextEditingController();
  TimeEstimateResponse? _timeEstimateResponse;

  // Task rewrite fields
  final _taskRewriteTitleController = TextEditingController();
  final _taskRewriteDescController = TextEditingController();
  TaskRewriteResponse? _taskRewriteResponse;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getPrioritizationAdvice();
    });
  }

  @override
  void dispose() {
    _timeEstimateTitleController.dispose();
    _timeEstimateDescController.dispose();
    _timeEstimateTagController.dispose();
    _taskRewriteTitleController.dispose();
    _taskRewriteDescController.dispose();
    super.dispose();
  }

  Future<void> _getPrioritizationAdvice() async {
    setState(() {
      _isLoadingPrioritization = true;
    });

    try {
      await Provider.of<TaskProvider>(context, listen: false)
          .getPrioritizationAdvice();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingPrioritization = false;
        });
      }
    }
  }

  Future<void> _getTimeEstimateSuggestion() async {
    if (_timeEstimateTitleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a task title')),
      );
      return;
    }

    setState(() {
      _isLoadingTimeEstimate = true;
    });

    try {
      final response = await Provider.of<TaskProvider>(context, listen: false)
          .getTimeEstimateSuggestion(
        _timeEstimateTitleController.text,
        _timeEstimateDescController.text.isEmpty
            ? null
            : _timeEstimateDescController.text,
        _timeEstimateTags.isEmpty ? null : _timeEstimateTags,
      );

      setState(() {
        _timeEstimateResponse = response;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingTimeEstimate = false;
        });
      }
    }
  }

  Future<void> _getTaskRewriteSuggestion() async {
    if (_taskRewriteTitleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a task title')),
      );
      return;
    }

    setState(() {
      _isLoadingTaskRewrite = true;
    });

    try {
      final response = await Provider.of<TaskProvider>(context, listen: false)
          .getTaskRewriteSuggestion(
        _taskRewriteTitleController.text,
        _taskRewriteDescController.text.isEmpty
            ? null
            : _taskRewriteDescController.text,
      );

      setState(() {
        _taskRewriteResponse = response;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingTaskRewrite = false;
        });
      }
    }
  }

  void _addTimeEstimateTag() {
    final tag = _timeEstimateTagController.text.trim();
    if (tag.isNotEmpty && !_timeEstimateTags.contains(tag)) {
      setState(() {
        _timeEstimateTags.add(tag);
        _timeEstimateTagController.clear();
      });
    }
  }

  void _removeTimeEstimateTag(String tag) {
    setState(() {
      _timeEstimateTags.remove(tag);
    });
  }

  void _createTaskFromRewrite() {
    print('1${_taskRewriteResponse!.rewrittenTitle}');
    print(_taskRewriteResponse!.rewrittenDescription);
    if (_taskRewriteResponse == null) return;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddTaskScreen(
          task: Task(
            title: _taskRewriteResponse!.rewrittenTitle,
            description: _taskRewriteResponse!.rewrittenDescription,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final theme = Theme.of(context);

    // Create a map of task IDs to tasks for the prioritization card
    final Map<String, Task> taskMap = {};
    for (final task in taskProvider.tasks) {
      if (task.id != null) {
        taskMap[task.id!] = task;
      }
    }

    return DefaultTabController(
      length: 3,
      initialIndex: _selectedTabIndex,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('AI Assistant'),
        ),
        body: Column(
          children: [
            // Tabs
            TabBar(
              onTap: (index) {
                setState(() {
                  _selectedTabIndex = index;
                });
              },
              labelColor: theme.colorScheme.primary,
              unselectedLabelColor:
                  theme.colorScheme.onSurface.withOpacity(0.6),
              indicatorColor: theme.colorScheme.primary,
              tabs: [
                const Tab(
                  icon: Icon(Icons.sort),
                  text: 'Prioritize',
                ),
                const Tab(
                  icon: Icon(Icons.access_time),
                  text: 'Time Estimate',
                ),
                const Tab(
                  icon: Icon(Icons.edit_note),
                  text: 'Rewrite Task',
                ),
              ],
            ),

            // Tab content
            Expanded(
              child: IndexedStack(
                index: _selectedTabIndex,
                children: [
                  // Prioritization tab
                  _buildPrioritizationTab(taskProvider, taskMap, theme),

                  // Time estimate tab
                  _buildTimeEstimateTab(theme),

                  // Task rewrite tab
                  _buildTaskRewriteTab(theme),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrioritizationTab(
      TaskProvider taskProvider, Map<String, Task> taskMap, ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Task Prioritization',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Let AI analyze your tasks and suggest which ones to focus on based on deadlines, tags, and priorities.',
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed:
                _isLoadingPrioritization ? null : _getPrioritizationAdvice,
            icon: const Icon(Icons.refresh),
            label: const Text('Get Prioritization Advice'),
          ),
          const SizedBox(height: 24),
          if (_isLoadingPrioritization)
            const Center(child: CircularProgressIndicator())
          else if (taskProvider.prioritizationResponse != null)
            PrioritizationSuggestionCard(
              prioritization: taskProvider.prioritizationResponse!,
              taskMap: taskMap,
            )
          else
            const Center(
              child: Text('No prioritization data available.'),
            ),
        ],
      ),
    );
  }

  Widget _buildTimeEstimateTab(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Time Estimate Suggestion',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Get AI-powered time estimates for your tasks based on the description and tags.',
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _timeEstimateTitleController,
                  decoration: const InputDecoration(
                    labelText: 'Task Title',
                    hintText: 'Enter task title',
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _timeEstimateDescController,
                  decoration: const InputDecoration(
                    labelText: 'Description (optional)',
                    hintText: 'Enter task description',
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                Text(
                  'Tags (optional)',
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _timeEstimateTagController,
                        decoration: const InputDecoration(
                          hintText: 'Add a tag',
                        ),
                        onFieldSubmitted: (_) => _addTimeEstimateTag(),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: _addTimeEstimateTag,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: _timeEstimateTags.map((tag) {
                    return Chip(
                      label: Text(tag),
                      onDeleted: () => _removeTimeEstimateTag(tag),
                      backgroundColor:
                          theme.colorScheme.primary.withOpacity(0.7),
                      labelStyle: TextStyle(
                        color: theme.colorScheme.onPrimary,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _isLoadingTimeEstimate
                        ? null
                        : _getTimeEstimateSuggestion,
                    icon: const Icon(Icons.psychology),
                    label: const Text('Get Time Estimate'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          if (_isLoadingTimeEstimate)
            const Center(child: CircularProgressIndicator())
          else if (_timeEstimateResponse != null)
            TimeEstimateSuggestionCard(
              timeEstimate: _timeEstimateResponse!,
              onAccept: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => AddTaskScreen(
                      task: Task(
                        title: _timeEstimateTitleController.text,
                        description: _timeEstimateDescController.text.isEmpty
                            ? null
                            : _timeEstimateDescController.text,
                        tags: _timeEstimateTags.isEmpty
                            ? null
                            : _timeEstimateTags,
                        estimatedTime: _timeEstimateResponse!.estimatedTime,
                      ),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildTaskRewriteTab(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Task Rewrite Suggestion',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Let AI improve your vague task descriptions to make them more specific and actionable.',
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _taskRewriteTitleController,
                  decoration: const InputDecoration(
                    labelText: 'Task Title',
                    hintText: 'Enter a vague task title (e.g., "Do project")',
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _taskRewriteDescController,
                  decoration: const InputDecoration(
                    labelText: 'Description (optional)',
                    hintText: 'Enter task description',
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _isLoadingTaskRewrite
                        ? null
                        : _getTaskRewriteSuggestion,
                    icon: const Icon(Icons.psychology),
                    label: const Text('Get Rewrite Suggestion'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          if (_isLoadingTaskRewrite)
            const Center(child: CircularProgressIndicator())
          else if (_taskRewriteResponse != null)
            TaskRewriteSuggestionCard(
              taskRewrite: _taskRewriteResponse!,
              onAccept: _createTaskFromRewrite,
            ),
        ],
      ),
    );
  }
}
