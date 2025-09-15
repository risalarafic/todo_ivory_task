import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../TaskBloc/task_bloc.dart';
import '../TaskBloc/task_event.dart';
import '../TaskBloc/task_state.dart';
import 'add_task_screen.dart';
import 'Widget/task_tile.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
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
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (route) => false,
                );
              },
              style: TextButton.styleFrom(foregroundColor: Colors.blue[400]),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TaskBloc>().add(LoadTasksFromAPI());
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        centerTitle: true,
        backgroundColor: Colors.blue[400],
        foregroundColor: Colors.white,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue[400],
              ),
              child: const Center(
                child: Text(
                  'Todo App',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home, color: Colors.blue),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout'),
              onTap: () {
                Navigator.pop(context);
                _logout(context);
              },
            ),
          ],
        ),
      ),
      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          if (state is TasksLoading) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<TaskBloc>().add(LoadTasksFromAPI());
              },
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.4),
                  const Center(child: CircularProgressIndicator()),
                ],
              ),
            );
          } else if (state is TasksLoaded) {
            if (state.allTasks.isEmpty) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<TaskBloc>().add(LoadTasksFromAPI());
                },
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                    const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.task_alt, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text('No tasks available', style: TextStyle(fontSize: 18, color: Colors.grey)),
                          SizedBox(height: 8),
                          Text('Add a new task to get started', style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
            return RefreshIndicator(
              onRefresh: () async {
                context.read<TaskBloc>().add(LoadTasksFromAPI());
              },
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: state.allTasks.length,
                itemBuilder: (context, i) {
                  final task = state.allTasks[i];
                  final isLocalTask = state.localTasks.any((t) => t.id == task.id);
                  return TaskTile(task: task, isLocalTask: isLocalTask);
                },
              ),
            );
          } else if (state is TasksError) {
            return RefreshIndicator(
              onRefresh: () async {
                context.read<TaskBloc>().add(LoadTasksFromAPI());
              },
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.4),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error, size: 64, color: Colors.red),
                        const SizedBox(height: 16),
                        Text(
                          state.message,
                          style: const TextStyle(fontSize: 16, color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider.value(
                value: context.read<TaskBloc>(),
                child: const AddTaskScreen(),
              ),
            ),
          );
        },
        backgroundColor: Colors.blue[400],
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}
