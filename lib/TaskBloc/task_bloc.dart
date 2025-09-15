import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/db_helper.dart';
import '../services/api_service.dart';
import '../models/task_model.dart';
import 'task_event.dart';
import 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  TaskBloc() : super(TasksLoading()) {
    on<LoadTasks>(_onLoadTasks);
    on<LoadTasksFromAPI>(_onLoadTasksFromAPI);
    on<AddTask>(_onAddTask);
    on<UpdateTask>(_onUpdateTask);
    on<DeleteTask>(_onDeleteTask);
    on<ToggleTaskStatus>(_onToggleTaskStatus);
  }

  Future<void> _onLoadTasks(LoadTasks event, Emitter<TaskState> emit) async {
    emit(TasksLoading());
    try {
      final localTasks = await _dbHelper.getAllTasks();
      final apiTasks = <Task>[];
      emit(TasksLoaded(
        apiTasks: apiTasks,
        localTasks: localTasks,
        allTasks: localTasks,
      ));
    } catch (e) {
      emit(TasksError(e.toString()));
    }
  }

  Future<void> _onLoadTasksFromAPI(LoadTasksFromAPI event, Emitter<TaskState> emit) async {
    print('TaskBloc: Starting _onLoadTasksFromAPI');
    emit(TasksLoading());
    try {
      // Fetch tasks from API
      print('TaskBloc: Fetching tasks from API...');
      final apiTasks = await ApiService.fetchTodos();
      print('TaskBloc: Fetched ${apiTasks.length} tasks from API');

      // Store API tasks in local database (they will be added if not already present)
      print('TaskBloc: Storing API tasks in database...');
      for (final task in apiTasks) {
        await _dbHelper.insertTask(task);
      }
      print('TaskBloc: Stored API tasks in database');

      // Now get all tasks from local database (which includes both API and user tasks)
      print('TaskBloc: Loading all tasks from database...');
      final allTasksFromDb = await _dbHelper.getAllTasks();
      print('TaskBloc: Loaded ${allTasksFromDb.length} total tasks from database');

      // Separate API tasks and local user tasks
      final localUserTasks = <Task>[];
      final apiTaskIds = apiTasks.map((t) => t.id).toSet();

      for (final task in allTasksFromDb) {
        if (!apiTaskIds.contains(task.id)) {
          localUserTasks.add(task);
        }
      }

      // Create ordered list: Local tasks first, then API tasks
      final allTasks = <Task>[];
      allTasks.addAll(localUserTasks); // Local tasks at the top
      allTasks.addAll(apiTasks);       // API tasks at the bottom

      print('TaskBloc: API tasks: ${apiTasks.length}, Local tasks: ${localUserTasks.length}, All tasks: ${allTasks.length}');

      emit(TasksLoaded(
        apiTasks: apiTasks,
        localTasks: localUserTasks,
        allTasks: allTasks,
      ));
    } catch (e) {
      print('TaskBloc: Error in _onLoadTasksFromAPI: $e');
      emit(TasksError('Failed to load tasks: ${e.toString()}'));
    }
  }

  Future<void> _onAddTask(AddTask event, Emitter<TaskState> emit) async {
    try {
      await _dbHelper.insertTask(event.task);

      // Get all tasks from database
      final allTasksFromDb = await _dbHelper.getAllTasks();

      // Get API tasks for reference
      final apiTasks = await ApiService.fetchTodos();

      // Separate local user tasks
      final localUserTasks = <Task>[];
      final apiTaskIds = apiTasks.map((t) => t.id).toSet();

      for (final task in allTasksFromDb) {
        if (!apiTaskIds.contains(task.id)) {
          localUserTasks.add(task);
        }
      }

      // Create ordered list: Local tasks first, then API tasks
      final allTasks = <Task>[];
      allTasks.addAll(localUserTasks); // Local tasks at the top
      allTasks.addAll(apiTasks);       // API tasks at the bottom

      emit(TasksLoaded(
        apiTasks: apiTasks,
        localTasks: localUserTasks,
        allTasks: allTasks,
      ));
    } catch (e) {
      emit(TasksError(e.toString()));
    }
  }

  Future<void> _onUpdateTask(UpdateTask event, Emitter<TaskState> emit) async {
    try {
      await _dbHelper.updateTask(event.task);

      // Get all tasks from database
      final allTasksFromDb = await _dbHelper.getAllTasks();

      // Get API tasks for reference
      final apiTasks = await ApiService.fetchTodos();

      // Separate local user tasks
      final localUserTasks = <Task>[];
      final apiTaskIds = apiTasks.map((t) => t.id).toSet();

      for (final task in allTasksFromDb) {
        if (!apiTaskIds.contains(task.id)) {
          localUserTasks.add(task);
        }
      }

      // Create ordered list: Local tasks first, then API tasks
      final allTasks = <Task>[];
      allTasks.addAll(localUserTasks); // Local tasks at the top
      allTasks.addAll(apiTasks);       // API tasks at the bottom

      emit(TasksLoaded(
        apiTasks: apiTasks,
        localTasks: localUserTasks,
        allTasks: allTasks,
      ));
    } catch (e) {
      emit(TasksError(e.toString()));
    }
  }

  Future<void> _onDeleteTask(DeleteTask event, Emitter<TaskState> emit) async {
    try {
      await _dbHelper.deleteTask(event.id);

      final allTasksFromDb = await _dbHelper.getAllTasks();

      final apiTasks = await ApiService.fetchTodos();

      final localUserTasks = <Task>[];
      final apiTaskIds = apiTasks.map((t) => t.id).toSet();

      for (final task in allTasksFromDb) {
        if (!apiTaskIds.contains(task.id)) {
          localUserTasks.add(task);
        }
      }

      final allTasks = <Task>[];
      allTasks.addAll(localUserTasks);
      allTasks.addAll(apiTasks);

      emit(TasksLoaded(
        apiTasks: apiTasks,
        localTasks: localUserTasks,
        allTasks: allTasks,
      ));
    } catch (e) {
      emit(TasksError(e.toString()));
    }
  }

  Future<void> _onToggleTaskStatus(ToggleTaskStatus event, Emitter<TaskState> emit) async {
    try {
      final current = state;
      if (current is TasksLoaded) {
        final task = current.allTasks.firstWhere((t) => t.id == event.id);
        final updatedTask = task.copyWith(isDone: !task.isDone);
        await _dbHelper.updateTask(updatedTask);

        final allTasksFromDb = await _dbHelper.getAllTasks();

        final apiTasks = await ApiService.fetchTodos();

        final localUserTasks = <Task>[];
        final apiTaskIds = apiTasks.map((t) => t.id).toSet();

        for (final task in allTasksFromDb) {
          if (!apiTaskIds.contains(task.id)) {
            localUserTasks.add(task);
          }
        }

        final allTasks = <Task>[];
        allTasks.addAll(localUserTasks);
        allTasks.addAll(apiTasks);

        emit(TasksLoaded(
          apiTasks: apiTasks,
          localTasks: localUserTasks,
          allTasks: allTasks,
        ));
      }
    } catch (e) {
      emit(TasksError(e.toString()));
    }
  }
}
