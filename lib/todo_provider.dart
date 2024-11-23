import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'todo_model.dart';

class TodoProvider with ChangeNotifier {
  final String baseUrl =
      'https://crudcrud.com/api/0624bcddb1c147339a32e44bb63e8bbb/todos';
  List<Todo> _todos = [];

  List<Todo> get todos => _todos;

  ///.................................................................... Fetch Todos from API.......................................///

  Future<void> fetchTodos() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        _todos = data.map((item) => Todo.fromJson(item)).toList();
        notifyListeners();
      }
    } catch (e) {
      print('Error fetching todos: $e');
    }
  }

  /// ....................................................................Add a new Todo..........................................///

  Future<void> addTodo(String title) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'title': title, 'isCompleted': false}),
      );
      if (response.statusCode == 201) {
        final newTodo = Todo.fromJson(json.decode(response.body));
        _todos.add(newTodo);
        notifyListeners();
      }
    } catch (e) {
      print('Error adding todo: $e');
    }
  }

  /// ....................................................................Edit a Todo...................................................///

  Future<void> updateTodo(String id, String newTitle) async {
    final todoIndex = _todos.indexWhere((todo) => todo.id == id);
    if (todoIndex == -1) return;

    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(
            {'title': newTitle, 'isCompleted': _todos[todoIndex].isCompleted}),
      );
      if (response.statusCode == 200) {
        _todos[todoIndex] = Todo(
          id: id,
          title: newTitle,
          isCompleted: _todos[todoIndex].isCompleted,
        );
        notifyListeners();
      }
    } catch (e) {
      print('Error updating todo: $e');
    }
  }

  /// .....................................................................Delete a Todo......................................................... ///

  Future<void> deleteTodo(String id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));
      if (response.statusCode == 200 || response.statusCode == 204) {
        _todos.removeWhere((todo) => todo.id == id);
        notifyListeners();
      }
    } catch (e) {
      print('Error deleting todo: $e');
    }
  }

  ///......................................................................toggle..............................................................///

  Future<void> toggleComplete(String id) async {
    final todoIndex = _todos.indexWhere((todo) => todo.id == id);
    if (todoIndex == -1) return;

    final currentTodo = _todos[todoIndex];
    final updatedIsCompleted = !currentTodo.isCompleted;

    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(
            {'title': currentTodo.title, 'isCompleted': updatedIsCompleted}),
      );
      if (response.statusCode == 200) {
        _todos[todoIndex] = Todo(
          id: id,
          title: currentTodo.title,
          isCompleted: updatedIsCompleted,
        );
        notifyListeners();
      }
    } catch (e) {
      print('Error toggling completion status: $e');
    }
  }
}
