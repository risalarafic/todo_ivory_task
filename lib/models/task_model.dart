import 'package:equatable/equatable.dart';

class Task extends Equatable {
  final int id;
  final String title;
  final String description;
  final bool isDone;

  const Task({
    required this.id,
    required this.title,
    required this.description,
    required this.isDone,
  });

  Task copyWith({int? id, String? title, String? description, bool? isDone}) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isDone: isDone ?? this.isDone,
    );
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as int,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      isDone: json['isDone'] ?? false,
    );
  }

  factory Task.fromApiJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as int,
      title: json['todo'] ?? '',
      description: '',
      isDone: json['completed'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'isDone': isDone,
  };

  @override
  List<Object?> get props => [id, title, description, isDone];
}
