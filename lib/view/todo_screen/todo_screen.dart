// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoo/controller/provider.dart';
import 'package:todoo/model/model_class.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    return Scaffold(
      backgroundColor: Colors.lightGreenAccent,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Center(
            child: const Text('TODO LISTS',
                style: TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ))),
      ),
      body: ListView.builder(
        itemCount: taskProvider.tasks.length,
        itemBuilder: (context, index) {
          final task = taskProvider.tasks[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 100,
              color: Colors.greenAccent,
              child: Center(
                child: ListTile(
                  title: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _showEditTaskDialog(context, task),

                      ),
                      Checkbox(
                        value: task.isCompleted,
                        onChanged: (value) {
                          taskProvider.updateTask(
                            Task(
                                id: task.id,
                                title: task.title,
                                isCompleted: value!),
                          );
                        },
                      ),
                      Text(
                        task.title,
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          decoration: task.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      Spacer(),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => taskProvider.deleteTask(task.id!),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () => _showAddTaskDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

   _showAddTaskDialog(BuildContext context) {
    final taskController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Add Task',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        content: TextField(
          controller: taskController,
          autofocus: true, // Focuses the TextField when dialog opens
          decoration: const InputDecoration(
            hintText: 'Enter task title',
            hintStyle: TextStyle(color: Colors.white),
          ),
        ),
        actions: [
          ElevatedButton(
           style: ElevatedButton.styleFrom(
              backgroundColor: Colors.lightGreen, 
              foregroundColor: Colors.black,
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.greenAccent, 
              foregroundColor: Colors.black,
            ),
            onPressed: () {
              final taskTitle = taskController.text.trim();
              if (taskTitle.isNotEmpty) {
                Provider.of<TaskProvider>(context, listen: false)
                    .addTask(taskTitle);
                Navigator.pop(context);
              } else {
                // Show a Snackbar if the task title is empty
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter a task title!')),
                );
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
 _showEditTaskDialog(BuildContext context, Task task) {
    final taskController = TextEditingController(text: task.title);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Task'),
        backgroundColor: Colors.green,
        content: TextField(
          style: TextStyle(color: Colors.white),
          controller: taskController,
          decoration: const InputDecoration(hintText: 'Enter new task title'),
        ),
        actions: [
          ElevatedButton(
           style: ElevatedButton.styleFrom(
              backgroundColor: Colors.lightGreen, 
              foregroundColor: Colors.black,
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
             
          ),
          ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.greenAccent, 
              foregroundColor: Colors.black,
            ),
            onPressed: () {
              Provider.of<TaskProvider>(context, listen: false).updateTask(
                Task(
                  id: task.id,
                  title: taskController.text,
                  isCompleted: task.isCompleted,
                ),
              );
              Navigator.pop(context);
            },
            child: const Text('Update'),
          ),
        ],
      ));}
