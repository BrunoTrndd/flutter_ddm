import 'package:flutter/material.dart';
import 'package:flutter_ddm/models/task.dart';
import 'package:flutter_ddm/services/task_service.dart';
import 'package:flutter_ddm/screens/add_edit_task_screen.dart';

class TaskDetailScreen extends StatelessWidget {
  final Task task;

  TaskDetailScreen({required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () async {
              final updatedTask = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddEditTaskScreen(task: task)),
              );
              if (updatedTask != null) {
                Navigator.pop(context, updatedTask);
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              await _deleteTask(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(task.description),
            SizedBox(height: 20),
            Text('Due Date: ${task.dueDate.toLocal()}'.split(' ')[0]),
            SizedBox(height: 20),
            Text('Completed: ${task.isCompleted ? 'Yes' : 'No'}'),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteTask(BuildContext context) async {
    final tasks = await TaskService.getTasks();
    tasks.removeWhere((t) => t.id == task.id);
    await TaskService.saveTasks(tasks);
    Navigator.pop(context);
  }
}
