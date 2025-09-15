import 'package:bloc/bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/task_model.dart';
import 'task_event.dart';
import 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  static const String _storageKey = 'tasks_v1';

  TaskBloc() : super(TasksLoading()) {
    on<LoadTasks>(_onLoadTasks);
    on<AddTask>(_onAddTask);
    on<UpdateTask>(_onUpdateTask);
    on<DeleteTask>(_onDeleteTask);
    on<ToggleTaskStatus>(_onToggleTaskStatus);
  }

  Future<void> _onLoadTasks(LoadTasks event, Emitter<TaskState> emit) async {
    emit(TasksLoading());
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_storageKey);
      if (raw == null) {
        emit(const TasksLoaded([]));
      } else {
        final List list = jsonDecode(raw);
        final tasks = list.map((e) => Task.fromJson(e)).toList().cast<Task>();
        emit(TasksLoaded(tasks));
      }
    } catch (e) {
      emit(TasksError(e.toString()));
    }
  }

  Future<void> _saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = jsonEncode(tasks.map((t) => t.toJson()).toList());
    await prefs.setString(_storageKey, raw);
  }

  Future<void> _onAddTask(AddTask event, Emitter<TaskState> emit) async {
    final current = state;
    if (current is TasksLoaded) {
      final tasks = List<Task>.from(current.tasks)..insert(0, event.task);
      await _saveTasks(tasks);
      emit(TasksLoaded(tasks));
    }
  }

  Future<void> _onUpdateTask(UpdateTask event, Emitter<TaskState> emit) async {
    final current = state;
    if (current is TasksLoaded) {
      final tasks = current.tasks.map((t) => t.id == event.task.id ? event.task : t).toList();
      await _saveTasks(tasks);
      emit(TasksLoaded(tasks));
    }
  }

  Future<void> _onDeleteTask(DeleteTask event, Emitter<TaskState> emit) async {
    final current = state;
    if (current is TasksLoaded) {
      final tasks = current.tasks.where((t) => t.id != event.id).toList();
      await _saveTasks(tasks);
      emit(TasksLoaded(tasks));
    }
  }

  Future<void> _onToggleTaskStatus(ToggleTaskStatus event, Emitter<TaskState> emit) async {
    final current = state;
    if (current is TasksLoaded) {
      final tasks = current.tasks.map((t) {
        if (t.id == event.id) return t.copyWith(isDone: !t.isDone);
        return t;
      }).toList();
      await _saveTasks(tasks);
      emit(TasksLoaded(tasks));
    }
  }
}
