import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../TaskBloc/task_bloc.dart';
import '../TaskBloc/task_event.dart';
import '../models/task_model.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleCtrl;
  late TextEditingController _descCtrl;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController();
    _descCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final title = _titleCtrl.text.trim();
    final desc = _descCtrl.text.trim();
    final bloc = context.read<TaskBloc>();

    final newTask = Task(
      id: DateTime.now().millisecondsSinceEpoch,
      title: title,
      description: desc,
      isDone: false,
    );
    bloc.add(AddTask(newTask));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Task added successfully'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Task'),
        backgroundColor: Colors.blue[400],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleCtrl,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (v) => v == null || v.isEmpty ? 'Title is required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descCtrl,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[400],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Add Task',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
