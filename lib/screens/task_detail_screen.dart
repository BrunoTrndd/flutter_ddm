import 'package:flutter/material.dart';
import 'package:flutter_ddm/models/task.dart';
import 'package:flutter_ddm/services/task_service.dart';
import 'package:flutter_ddm/screens/add_edit_task_screen.dart';
import 'package:intl/intl.dart';

class TaskDetailScreen extends StatelessWidget {
  final Task task;

  const TaskDetailScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
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
            icon: const Icon(Icons.delete),
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
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Due Date: ${DateFormat('yyyy-MM-dd').format(task.dueDate)}'),
            const SizedBox(height: 16),
            Text(task.description),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await _markTaskAsCompleted(context);
              },
              child: const Text('Mark as Completed'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteTask(BuildContext context) async {
    await TaskService.deleteTask(task.id);
    Navigator.pop(context, task.id);
  }

  Future<void> _markTaskAsCompleted(BuildContext context) async {
    final updatedTask = Task(
      id: task.id,
      title: task.title,
      description: task.description,
      dueDate: task.dueDate,
      isCompleted: true,
    );
    await TaskService.updateTask(updatedTask);
    Navigator.pop(context, updatedTask);
  }
}