import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_ddm/models/task.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';

class TaskService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static const String _tasksKey = 'tasks';

  // Obtém tarefas do armazenamento local
  static Future<List<Task>> getTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksData = prefs.getString(_tasksKey);
    if (tasksData == null) {
      return [];
    }
    final List<dynamic> tasksJson = jsonDecode(tasksData);
    return tasksJson.map((json) => Task.fromJson(json)).toList();
  }

  // Salva tarefas no armazenamento local
  static Future<void> saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = jsonEncode(tasks.map((task) => task.toJson()).toList());
    await prefs.setString(_tasksKey, tasksJson);
  }

  // Exclui uma tarefa do armazenamento local
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

  // Atualiza ou adiciona uma tarefa no armazenamento local
  static Future<void> updateTask(Task updatedTask) async {
    final prefs = await SharedPreferences.getInstance();
    final tasksData = prefs.getString(_tasksKey);
    List<Task> tasks = [];
    if (tasksData != null) {
      final List<dynamic> tasksJson = jsonDecode(tasksData);
      tasks = tasksJson.map((json) => Task.fromJson(json)).toList();
    }
    final index = tasks.indexWhere((task) => task.id == updatedTask.id);
    if (index != -1) {
      tasks[index] = updatedTask;
    } else {
      tasks.add(updatedTask);
    }
    await saveTasks(tasks);
  }

  // Sincroniza tarefas com o backend
  static Future<void> syncWithRemote(String userId) async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return;
    }

    // Obtenha tarefas locais
    final localTasks = await getTasks();

    // Simula a obtenção de tarefas do backend
    final remoteTasks = await _fetchRemoteTasks(userId);

    // Mescla as tarefas locais e remotas
    final mergedTasks = _mergeTasks(localTasks, remoteTasks);

    // Salva as tarefas mescladas no armazenamento local
    await saveTasks(mergedTasks);

    // Envia as tarefas locais mescladas para o backend
    await _sendTasksToRemote(userId, mergedTasks);
  }

  // Função para mesclar tarefas locais e remotas
  static List<Task> _mergeTasks(List<Task> localTasks, List<Task> remoteTasks) {
    final Map<String, Task> taskMap = { for (var task in remoteTasks) task.id: task };

    for (var localTask in localTasks) {
      taskMap[localTask.id] = localTask;
    }

    return taskMap.values.toList();
  }

  // Obter tarefas remotas do Firestore
  static Future<List<Task>> _fetchRemoteTasks(String userId) async {
    final snapshot = await _db.collection('users').doc(userId).collection('tasks').get();
    return snapshot.docs.map((doc) => Task.fromJson(doc.data())).toList();
  }

  // Enviar tarefas locais para o Firestore
  static Future<void> _sendTasksToRemote(String userId, List<Task> tasks) async {
    final batch = _db.batch();
    final userTasksCollection = _db.collection('users').doc(userId).collection('tasks');
    for (var task in tasks) {
      final taskRef = userTasksCollection.doc(task.id);
      batch.set(taskRef, task.toJson());
    }
    await batch.commit();
  }
}