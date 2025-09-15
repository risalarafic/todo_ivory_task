import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/task_model.dart';

class ApiService {
  static const String baseUrl = 'https://dummyjson.com';
  static const String todosEndpoint = '/todos';


  static Future<List<Task>> fetchTodos() async {
    try {
      print('ApiService: Making request to $baseUrl$todosEndpoint');
      final response = await http.get(
        Uri.parse('$baseUrl$todosEndpoint'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      print('ApiService: Response status: ${response.statusCode}');
      print('ApiService: Response body length: ${response.body.length}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        print('ApiService: Parsed JSON data keys: ${data.keys.toList()}');

        final List<dynamic> todos = data['todos'] ?? [];
        print('ApiService: Found ${todos.length} todos in response');

        final List<Task> tasks = todos.map((json) => Task.fromApiJson(json)).toList();
        print('ApiService: Converted to ${tasks.length} Task objects');

        if (tasks.isNotEmpty) {
          print('ApiService: First task: ${tasks.first.title}');
        }

        return tasks;
      } else {
        print('ApiService: Error - Status code: ${response.statusCode}');
        throw Exception('Failed to load todos: ${response.statusCode}');
      }
    } catch (e) {
      print('ApiService: Exception: $e');
      throw Exception('Failed to load todos: $e');
    }
  }
}
