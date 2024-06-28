import 'package:flutter/material.dart';
import 'package:flutter_ddm/models/task.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;

  const TaskItem({super.key, required this.task, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(task.title),
      subtitle: Text('Due Date: ${task.dueDate.toLocal()}'.split(' ')[0]),
      trailing: Icon(task.isCompleted ? Icons.check_circle : Icons.circle),
      onTap: onTap,
    );
  }
}
