import 'package:equatable/equatable.dart';
import '../models/task_model.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();
  @override
  List<Object?> get props => [];
}

class LoadTasks extends TaskEvent {}

class AddTask extends TaskEvent {
  final Task task;
  const AddTask(this.task);
  @override
  List<Object?> get props => [task];
}

class UpdateTask extends TaskEvent {
  final Task task;
  const UpdateTask(this.task);
  @override
  List<Object?> get props => [task];
}

class DeleteTask extends TaskEvent {
  final int id;
  const DeleteTask(this.id);
  @override
  List<Object?> get props => [id];
}

class ToggleTaskStatus extends TaskEvent {
  final int id;
  const ToggleTaskStatus(this.id);
  @override
  List<Object?> get props => [id];
}
