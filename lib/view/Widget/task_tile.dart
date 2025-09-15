import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../TaskBloc/task_bloc.dart';
import '../../TaskBloc/task_event.dart';
import '../../models/task_model.dart';
import '../edit_task_screen.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final bool isLocalTask;
  const TaskTile({super.key, required this.task, this.isLocalTask = false});

  void _showDeleteConfirmation(BuildContext context, Task task) {
    final taskBloc = context.read<TaskBloc>();
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return BlocProvider.value(
          value: taskBloc,
          child: AlertDialog(
            backgroundColor: Colors.white,
            title: const Text('Delete Task'),
            content: Text('Are you sure you want to delete "${task.title}"?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                },
                style: TextButton.styleFrom(foregroundColor: Colors.grey[600]),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  taskBloc.add(DeleteTask(task.id));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Task deleted')),
                  );
                },
                style: TextButton.styleFrom(foregroundColor: Colors.blue[400]),
                child: const Text('Delete'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Checkbox(
          value: task.isDone,
          onChanged: (_) {
            context.read<TaskBloc>().add(ToggleTaskStatus(task.id));
          },
          activeColor: Colors.green,
          checkColor: Colors.white,
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                task.title,
                style: TextStyle(
                  decoration: task.isDone ? TextDecoration.lineThrough : null,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        subtitle: task.description.isNotEmpty ? Text(task.description) : null,
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            _showDeleteConfirmation(context, task);
          },
        ),
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<TaskBloc>(),
                child: EditTaskScreen(task: task),
              ),
            ),
          );
        },
      ),
    );
  }
}
