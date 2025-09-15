import 'package:equatable/equatable.dart';
import '../models/task_model.dart';

abstract class TaskState extends Equatable {
  const TaskState();
  @override
  List<Object?> get props => [];
}

class TasksLoading extends TaskState {}

class TasksLoaded extends TaskState {
  final List<Task> apiTasks;
  final List<Task> localTasks;
  final List<Task> allTasks;

  const TasksLoaded({
    required this.apiTasks,
    required this.localTasks,
    required this.allTasks,
  });

  @override
  List<Object?> get props => [apiTasks, localTasks, allTasks];
}

class TasksError extends TaskState {
  final String message;
  const TasksError(this.message);
  @override
  List<Object?> get props => [message];
}
