import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'todo_provider.dart';

class AddTodoScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add To-Do'),
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
                      todoProvider.addTodo(_controller.text);
                      Navigator.of(context).pop(); // Return to the main screen
                    }
                  },
                  child: const Text('Add To-Do'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
