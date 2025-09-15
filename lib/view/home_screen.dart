import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../TaskBloc/task_bloc.dart';
import '../TaskBloc/task_event.dart';
import '../TaskBloc/task_state.dart';
import 'add_edit_task_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TaskBloc()..add(LoadTasks()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Tasks')),
        body: BlocBuilder<TaskBloc, TaskState>(
          builder: (context, state) {
            if (state is TasksLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is TasksLoaded) {
              if (state.tasks.isEmpty) {
                return const Center(child: Text('No tasks yet'));
              }
              return ListView.separated(
                itemCount: state.tasks.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, i) {
                  final task = state.tasks[i];
                  return ListTile(
                    leading: Checkbox(
                      value: task.isDone,
                      onChanged: (_) {
                        context.read<TaskBloc>().add(ToggleTaskStatus(task.id));
                      },
                    ),
                    title: Text(task.title,
                        style: TextStyle(decoration: task.isDone ? TextDecoration.lineThrough : null)),
                    subtitle: Text(task.description),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        context.read<TaskBloc>().add(DeleteTask(task.id));
                      },
                    ),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => AddEditTaskScreen(task: task)),
                      );
                    },
                  );
                },
              );
            } else if (state is TasksError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox();
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await Navigator.push(context, MaterialPageRoute(builder: (_) => const AddEditTaskScreen()));
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
