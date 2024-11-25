import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'todo_provider.dart';

class EditTodoScreen extends StatelessWidget {
  final String id;
  final String currentTitle;

  EditTodoScreen({required this.id, required this.currentTitle});

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _controller.text = currentTitle;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit To-Do'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'To-Do Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Consumer<TodoProvider>(
              builder: (context, todoProvider, child) {
                return ElevatedButton(
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      todoProvider.updateTodo(id, _controller.text);
                      Navigator.of(context).pop(); 
                    }
                  },
                  child: const Text('Update To-Do'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
