import 'package:flutter/material.dart';
import 'package:flutter_ddm/models/task.dart';
import 'package:flutter_ddm/screens/profile_screen.dart';
import 'package:flutter_ddm/services/task_service.dart';
import 'package:flutter_ddm/screens/add_edit_task_screen.dart';
import 'package:flutter_ddm/screens/task_detail_screen.dart';
import 'package:flutter_ddm/widgets/task_item.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<Task> _tasks = [];
  late String _userId;

  @override
  void initState() {
    super.initState();
    _initUser();
  }

  Future<void> _initUser() async {
    final prefs = await SharedPreferences.getInstance();
    _userId = prefs.getString('token')!;
    _checkConnectivity();
    _loadTasks();
  }

  void _checkConnectivity() {
    final Connectivity connectivity = Connectivity();
    connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      if (result != ConnectivityResult.none) {
        TaskService.syncWithRemote(_userId);
      }
    });
  }

  Future<void> _loadTasks() async {
    final tasks = await TaskService.getTasks();
    setState(() {
      _tasks = tasks;
    });
  }

  void _removeTask(String taskId) async {
    await TaskService.deleteTask(taskId);
    setState(() {
      _tasks.removeWhere((task) => task.id == taskId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_rounded),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen())),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          final task = _tasks[index];
          return TaskItem(
            task: task,
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TaskDetailScreen(task: task)),
              );
              if (result != null) {
                if (result is Task) {
                  await TaskService.updateTask(result);  // Atualiza a tarefa no armazenamento local
                  _loadTasks();
                } else if (result is String) {
                  _removeTask(result);
                }
              }
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final newTask = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddEditTaskScreen()),
          );
          if (newTask != null) {
            await TaskService.updateTask(newTask);
            _loadTasks();
          }
        },
      ),
    );
  }
}