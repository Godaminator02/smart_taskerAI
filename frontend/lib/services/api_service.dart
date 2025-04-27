import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/task_model.dart';
import '../models/ai_suggestion_model.dart';

class ApiService {
  // Task API calls
  Future<List<Task>> getTasks() async {
    final response = await http.get(
      Uri.parse(ApiConfig.tasks),
      headers: ApiConfig.headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Task.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load tasks: ${response.body}');
    }
  }

  Future<Task> createTask(Task task) async {
    final response = await http.post(
      Uri.parse(ApiConfig.tasks),
      headers: ApiConfig.headers,
      body: json.encode(task.toJson()),
    );

    if (response.statusCode == 201) {
      return Task.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create task: ${response.body}');
    }
  }

  Future<Task> getTask(String id) async {
    final response = await http.get(
      Uri.parse(ApiConfig.taskDetail(id)),
      headers: ApiConfig.headers,
    );

    if (response.statusCode == 200) {
      return Task.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load task: ${response.body}');
    }
  }

  Future<Task> updateTask(Task task) async {
    final response = await http.put(
      Uri.parse(ApiConfig.taskDetail(task.id ?? '')),
      headers: ApiConfig.headers,
      body: json.encode(task.toJson()),
    );

    if (response.statusCode == 200) {
      return Task.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update task: ${response.body}');
    }
  }

  Future<void> deleteTask(String id) async {
    final response = await http.delete(
      Uri.parse(ApiConfig.taskDetail(id)),
      headers: ApiConfig.headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete task: ${response.body}');
    }
  }

  Future<Task> toggleTaskCompletion(String id) async {
    final response = await http.put(
      Uri.parse(ApiConfig.toggleTask(id)),
      headers: ApiConfig.headers,
    );

    if (response.statusCode == 200) {
      return Task.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to toggle task completion: ${response.body}');
    }
  }

  // AI API calls
  Future<PrioritizationResponse> getPrioritizationAdvice() async {
    final response = await http.get(
      Uri.parse(ApiConfig.prioritize),
      headers: ApiConfig.headers,
    );

    if (response.statusCode == 200) {
      return PrioritizationResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to get prioritization advice: ${response.body}');
    }
  }

  Future<TimeEstimateResponse> getTimeEstimateSuggestion(
      String title, String? description, List<String>? tags) async {
    final response = await http.post(
      Uri.parse(ApiConfig.suggestTime),
      headers: ApiConfig.headers,
      body: json.encode({
        'title': title,
        'description': description,
        'tags': tags,
      }),
    );

    if (response.statusCode == 200) {
      return TimeEstimateResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to get time estimate: ${response.body}');
    }
  }

  Future<TaskRewriteResponse> getTaskRewriteSuggestion(
      String title, String? description) async {
    final response = await http.post(
      Uri.parse(ApiConfig.rewriteTask),
      headers: ApiConfig.headers,
      body: json.encode({
        'title': title,
        'description': description,
      }),
    );

    if (response.statusCode == 200) {
      return TaskRewriteResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception(
          'Failed to get task rewrite suggestion: ${response.body}');
    }
  }
}
