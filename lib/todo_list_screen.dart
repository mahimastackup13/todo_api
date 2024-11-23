import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'todo_provider.dart';
import 'add_todo_screen.dart';
import 'edit_todo_screen.dart';

class TodoListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do List'),
      ),
      body: Consumer<TodoProvider>(
        builder: (ctx, todoProvider, _) {
          final todos = todoProvider.todos;

          return todos.isEmpty
              ? const Center(
                  child: Text('No Todos available. Add a new one!'),
                )
              : ListView.builder(
                  itemCount: todos.length,
                  itemBuilder: (ctx, i) {
                    final todo = todos[i];
                    return ListTile(
                      leading: GestureDetector(
                        onTap: () {
                          todoProvider.toggleComplete(todo.id);
                        },
                        child: Checkbox(
                          value: todo.isCompleted,
                          onChanged: (value) {
                            todoProvider.toggleComplete(todo.id);
                          },
                        ),
                      ),
                      title: Text(
                        todo.title,
                        style: TextStyle(
                          decoration: todo.isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (ctx) => EditTodoScreen(
                                    id: todo.id,
                                    currentTitle: todo.title,
                                  ),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              todoProvider.deleteTodo(todo.id);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (ctx) => AddTodoScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
