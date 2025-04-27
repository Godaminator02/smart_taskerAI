import 'package:flutter/foundation.dart';
import '../models/task_model.dart';
import '../models/ai_suggestion_model.dart';
import '../services/api_service.dart';

class TaskProvider with ChangeNotifier {
  final ApiService _apiService;
  List<Task> _tasks = [];
  bool _isLoading = false;
  String? _error;
  PrioritizationResponse? _prioritizationResponse;

  TaskProvider({required ApiService apiService}) : _apiService = apiService;

  // Getters
  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;
  String? get error => _error;
  PrioritizationResponse? get prioritizationResponse => _prioritizationResponse;

  // Fetch all tasks
  Future<void> fetchTasks() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _tasks = await _apiService.getTasks();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  // Create a new task
  Future<Task?> createTask(Task task) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final newTask = await _apiService.createTask(task);
      _tasks.add(newTask);
      _isLoading = false;
      notifyListeners();
      return newTask;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  // Update a task
  Future<Task?> updateTask(Task task) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final updatedTask = await _apiService.updateTask(task);
      final index = _tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        _tasks[index] = updatedTask;
      }
      // print(updatedTask);
      _isLoading = false;

      notifyListeners();
      return updatedTask;
    } catch (e) {
      print(e);
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  // Delete a task
  Future<bool> deleteTask(String id) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _apiService.deleteTask(id);
      _tasks.removeWhere((task) => task.id == id);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Toggle task completion
  Future<bool> toggleTaskCompletion(String id) async {
    _error = null;
    notifyListeners();

    try {
      final updatedTask = await _apiService.toggleTaskCompletion(id);
      final index = _tasks.indexWhere((t) => t.id == id);
      if (index != -1) {
        _tasks[index] = updatedTask;
      }
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  // Get today's tasks
  List<Task> getTodayTasks() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));

    return _tasks.where((task) {
      if (task.deadline == null) return false;
      final taskDate = DateTime(
          task.deadline!.year, task.deadline!.month, task.deadline!.day);
      return taskDate.compareTo(today) >= 0 && taskDate.compareTo(tomorrow) < 0;
    }).toList();
  }

  // Get AI prioritization advice
  Future<void> getPrioritizationAdvice() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _prioritizationResponse = await _apiService.getPrioritizationAdvice();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
    }
  }

  // Get AI time estimate suggestion
  Future<TimeEstimateResponse> getTimeEstimateSuggestion(
      String title, String? description, List<String>? tags) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response =
          await _apiService.getTimeEstimateSuggestion(title, description, tags);
      _isLoading = false;
      notifyListeners();
      return response;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  // Get AI task rewrite suggestion
  Future<TaskRewriteResponse> getTaskRewriteSuggestion(
      String title, String? description) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response =
          await _apiService.getTaskRewriteSuggestion(title, description);
      _isLoading = false;
      notifyListeners();
      return response;
    } catch (e) {
      _isLoading = false;
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
