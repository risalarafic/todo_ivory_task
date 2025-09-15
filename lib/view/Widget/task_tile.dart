import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../TaskBloc/task_bloc.dart';
import '../../TaskBloc/task_event.dart';
import '../../models/task_model.dart';
import '../add_edit_task_screen.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  const TaskTile({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(task.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        color: Colors.red,
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) {
        context.read<TaskBloc>().add(DeleteTask(task.id));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Task deleted')),
        );
      },
      child: ListTile(
        leading: Checkbox(
          value: task.isDone,
          onChanged: (_) {
            context.read<TaskBloc>().add(ToggleTaskStatus(task.id));
          },
        ),
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.isDone ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: task.description.isNotEmpty ? Text(task.description) : null,
        trailing: const Icon(Icons.edit, color: Colors.blue),
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddEditTaskScreen(task: task)),
          );
        },
      ),
    );
  }
}
