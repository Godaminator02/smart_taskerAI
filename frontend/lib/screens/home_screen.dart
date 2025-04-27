import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task_model.dart';
import '../providers/task_provider.dart';
import '../widgets/task_card.dart';
import 'add_task_screen.dart';
import 'ai_assist_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool _showCompletedTasks = false;
  String? _selectedTag;
  String? _selectedPriority;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchTasks();
    });
  }

  Future<void> _fetchTasks() async {
    await Provider.of<TaskProvider>(context, listen: false).fetchTasks();
  }

  void _navigateToAddTask() {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (context) => const AddTaskScreen(),
          ),
        )
        .then((_) => _fetchTasks());
  }

  void _navigateToAIAssist() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AIAssistScreen(),
      ),
    );
  }

  void _toggleShowCompletedTasks() {
    setState(() {
      _showCompletedTasks = !_showCompletedTasks;
    });
  }

  void _setSelectedTag(String? tag) {
    setState(() {
      _selectedTag = tag == _selectedTag ? null : tag;
    });
  }

  void _setSelectedPriority(String? priority) {
    setState(() {
      _selectedPriority = priority == _selectedPriority ? null : priority;
    });
  }

  List<Task> _getFilteredTasks(List<Task> tasks) {
    return tasks.where((task) {
      // Filter by completion status
      if (!_showCompletedTasks && task.completed) {
        return false;
      }

      // Filter by tag
      if (_selectedTag != null &&
          (task.tags == null || !task.tags!.contains(_selectedTag))) {
        return false;
      }

      // Filter by priority
      if (_selectedPriority != null && task.priority != _selectedPriority) {
        return false;
      }

      return true;
    }).toList();
  }

  Set<String> _getAllTags(List<Task> tasks) {
    final Set<String> tags = {};
    for (final task in tasks) {
      if (task.tags != null) {
        tags.addAll(task.tags!);
      }
    }
    return tags;
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final theme = Theme.of(context);

    final List<Task> allTasks = taskProvider.tasks;
    final List<Task> filteredTasks = _getFilteredTasks(allTasks);
    final Set<String> allTags = _getAllTags(allTasks);

    // Determine which tasks to show based on the selected tab
    List<Task> tasksToShow;
    if (_selectedIndex == 0) {
      // Today's tasks
      tasksToShow = _getFilteredTasks(taskProvider.getTodayTasks());
    } else {
      // All tasks
      tasksToShow = filteredTasks;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedIndex == 0 ? 'Today\'s Tasks' : 'All Tasks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchTasks,
            tooltip: 'Refresh Tasks',
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.task_alt,
                      size: 40,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Smart Tasker',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'AI-Powered Task Manager',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.today),
              title: const Text('Today\'s Tasks'),
              selected: _selectedIndex == 0,
              onTap: () {
                setState(() {
                  _selectedIndex = 0;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.list),
              title: const Text('All Tasks'),
              selected: _selectedIndex == 1,
              onTap: () {
                setState(() {
                  _selectedIndex = 1;
                });
                Navigator.pop(context);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.psychology),
              title: const Text('AI Assistant'),
              onTap: () {
                Navigator.pop(context);
                _navigateToAIAssist();
              },
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Filters',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SwitchListTile(
              title: const Text('Show Completed Tasks'),
              value: _showCompletedTasks,
              onChanged: (value) {
                setState(() {
                  _showCompletedTasks = value;
                });
              },
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text('Priority'),
            ),
            Wrap(
              spacing: 8,
              children: ['Low', 'Medium', 'High'].map((priority) {
                return FilterChip(
                  label: Text(priority),
                  selected: _selectedPriority == priority,
                  onSelected: (selected) {
                    _setSelectedPriority(priority);
                  },
                );
              }).toList(),
            ),
            if (allTags.isNotEmpty) ...[
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text('Tags'),
              ),
              Wrap(
                spacing: 8,
                children: allTags.map((tag) {
                  return FilterChip(
                    label: Text(tag),
                    selected: _selectedTag == tag,
                    onSelected: (selected) {
                      _setSelectedTag(tag);
                    },
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
      body: taskProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : tasksToShow.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        size: 80,
                        color: theme.colorScheme.primary.withOpacity(0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No tasks found',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color:
                              theme.colorScheme.onBackground.withOpacity(0.5),
                        ),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton.icon(
                        onPressed: _navigateToAddTask,
                        icon: const Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        label: const Text('Add Task'),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _fetchTasks,
                  child: ListView.builder(
                    padding: const EdgeInsets.only(bottom: 80),
                    itemCount: tasksToShow.length,
                    itemBuilder: (context, index) {
                      final task = tasksToShow[index];
                      return TaskCard(
                        task: task,
                        onTap: () {
                          Navigator.of(context)
                              .push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      AddTaskScreen(task: task),
                                ),
                              )
                              .then((_) => _fetchTasks());
                        },
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddTask,
        tooltip: 'Add Task',
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.today),
            label: 'Today',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.list),
            label: 'All Tasks',
          ),
        ],
      ),
    );
  }
}
