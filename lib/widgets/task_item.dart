import 'package:flutter/material.dart';
import 'package:flutter_ddm/models/task.dart';
import 'package:intl/intl.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;

  const TaskItem({super.key, required this.task, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        task.title,
        style: TextStyle(
          decoration: task.isCompleted ? TextDecoration.lineThrough : null,
        ),
      ),
      subtitle: task.isCompleted
          ? null
          : Text('Due Date: ${DateFormat('yyyy-MM-dd').format(task.dueDate)}'),
      trailing: Icon(task.isCompleted ? Icons.check_circle : Icons.circle),
      onTap: onTap,
    );
  }
}