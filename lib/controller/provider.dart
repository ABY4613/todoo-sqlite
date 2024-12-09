import 'package:flutter/material.dart';
import 'db_helper.dart';
import '../model/model_class.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  Future<void> fetchTasks() async {
    final data = await DBHelper().fetchTasks();
    _tasks = data.map((e) => Task.fromMap(e)).toList();
    notifyListeners();
  }

  Future<void> addTask(String title) async {
    final task = Task(title: title);
    await DBHelper().insertTask(task.toMap());
    await fetchTasks(); // Ensure tasks are re-fetched after adding
    notifyListeners(); // Notify listeners for UI update
  }

  Future<void> updateTask(Task task) async {
    await DBHelper().updateTask(task.toMap());
    await fetchTasks(); // Ensure tasks are re-fetched after update
    notifyListeners(); // Notify listeners for UI update
  }

  Future<void> deleteTask(int id) async {
    await DBHelper().deleteTask(id);
    await fetchTasks(); // Ensure tasks are re-fetched after deletion
    notifyListeners(); // Notify listeners for UI update
  }
}