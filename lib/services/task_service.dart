import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_ddm/models/task.dart';
import 'dart:convert';

class TaskService {
  static const String _tasksKey = 'tasks';

  static Future<List<Task>> getTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksData = prefs.getString(_tasksKey);
    if (tasksData == null) {
      return [];
    }
    final List<dynamic> tasksJson = jsonDecode(tasksData);
    return tasksJson.map((json) => Task.fromJson(json)).toList();
  }

  static Future<void> saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = jsonEncode(tasks.map((task) => task.toJson()).toList());
    await prefs.setString(_tasksKey, tasksJson);
  }

  static Future<void> deleteTask(String taskId) async {
    final prefs = await SharedPreferences.getInstance();
    final tasksData = prefs.getString(_tasksKey);
    if (tasksData == null) return;
    final List<dynamic> tasksJson = jsonDecode(tasksData);
    final tasks = tasksJson.map((json) => Task.fromJson(json)).toList();
    tasks.removeWhere((task) => task.id == taskId);
    final updatedTasksJson = jsonEncode(tasks.map((task) => task.toJson()).toList());
    await prefs.setString(_tasksKey, updatedTasksJson);
  }

  static Future<void> updateTask(Task updatedTask) async {
    final prefs = await SharedPreferences.getInstance();
    final tasksData = prefs.getString(_tasksKey);
    if (tasksData == null) return;
    final List<dynamic> tasksJson = jsonDecode(tasksData);
    final tasks = tasksJson.map((json) => Task.fromJson(json)).toList();
    final index = tasks.indexWhere((task) => task.id == updatedTask.id);
    if (index != -1) {
      tasks[index] = updatedTask;
    }
    final updatedTasksJson = jsonEncode(tasks.map((task) => task.toJson()).toList());
    await prefs.setString(_tasksKey, updatedTasksJson);
  }
}