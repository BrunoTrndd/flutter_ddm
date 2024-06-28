import 'package:flutter/material.dart';
import 'package:flutter_ddm/models/task.dart';
import 'package:flutter_ddm/services/task_service.dart';
import 'package:flutter_ddm/screens/add_edit_task_screen.dart';
import 'package:flutter_ddm/screens/task_detail_screen.dart';
import 'package:flutter_ddm/widgets/task_item.dart';

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<Task> _tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final tasks = await TaskService.getTasks();
    setState(() {
      _tasks = tasks;
    });
  }

  void _removeTask(String taskId) {
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
            icon: const Icon(Icons.add),
            onPressed: () async {
              final newTask = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddEditTaskScreen()),
              );
              if (newTask != null) {
                _loadTasks();
              }
            },
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
                  _loadTasks();
                } else if (result is String) {
                  _removeTask(result);
                }
              }
            },
          );
        },
      ),
    );
  }
}