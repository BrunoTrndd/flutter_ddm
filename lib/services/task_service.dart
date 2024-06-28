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
}