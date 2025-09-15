import 'package:equatable/equatable.dart';
import '../models/task_model.dart';

abstract class TaskState extends Equatable {
  const TaskState();
  @override
  List<Object?> get props => [];
}

class TasksLoading extends TaskState {}

class TasksLoaded extends TaskState {
  final List<Task> tasks;
  const TasksLoaded(this.tasks);
  @override
  List<Object?> get props => [tasks];
}

class TasksError extends TaskState {
  final String message;
  const TasksError(this.message);
  @override
  List<Object?> get props => [message];
}
