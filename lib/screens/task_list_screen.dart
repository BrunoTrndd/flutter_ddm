import 'package:flutter/material.dart';
import 'package:flutter_ddm/models/task.dart';
import 'package:flutter_ddm/screens/add_edit_task_screen.dart';
import 'package:flutter_ddm/screens/task_detail_screen.dart';
import 'package:flutter_ddm/services/task_service.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tasks'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              final newTask = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddEditTaskScreen()),
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
              final updatedTask = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TaskDetailScreen(task: task)),
              );
              if (updatedTask != null) {
                _loadTasks();
              }
            },
          );
        },
      ),
    );
  }
}
