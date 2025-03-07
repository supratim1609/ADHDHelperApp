import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

// Model for Task
class Task {
  String description;
  String status;

  Task(this.description, {this.status = 'To Be Done'});

  // Convert Task to a Map (For Hive storage)
  Map<String, dynamic> toMap() => {
        'description': description,
        'status': status,
      };

  // Create Task from Map (For Hive retrieval)
  Task.fromMap(Map<String, dynamic> map)
      : description = map['description'],
        status = map['status'];
}

class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TextEditingController _taskController = TextEditingController();
  late Box _taskBox;
  final List<String> statuses = [
    'To Be Done',
    'In Progress',
    'Done',
    'Cancelled'
  ];

  @override
  void initState() {
    super.initState();
    _taskBox = Hive.box('taskBox');
  }

  // Fetch tasks from Hive
  List<Task> _getTasks() {
    return _taskBox.values.map<Task>((taskMap) {
      return Task.fromMap(Map<String, dynamic>.from(taskMap));
    }).toList();
  }

  // Add a new task
  void _addTask(String description) {
    if (description.isNotEmpty) {
      final newTask = Task(description);
      _taskBox.add(newTask.toMap());
      setState(() {});
    }
  }

  // Update task status dynamically
  void _updateTaskStatus(int index, String newStatus) {
    final task = _getTasks()[index]; // Get existing task
    final updatedTask = Task(task.description, status: newStatus);
    _taskBox.putAt(index, updatedTask.toMap()); // Update Hive storage
    setState(() {});
  }

  // Remove a task
  void _removeTask(int index) {
    _taskBox.deleteAt(index);
    setState(() {});
  }

  // Get border color based on task status
  Color _getBorderColor(String status) {
    switch (status) {
      case 'To Be Done':
        return Colors.yellowAccent;
      case 'In Progress':
        return Colors.blueAccent;
      case 'Done':
        return Colors.greenAccent;
      case 'Cancelled':
        return Colors.redAccent;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Task> tasks = _getTasks();

    return Container(
      color: Colors.black, // Keep the background black
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _taskController,
              style: TextStyle(color: Colors.white), // Text color white
              decoration: InputDecoration(
                labelText: 'Enter Task',
                labelStyle: TextStyle(color: Colors.white54),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white54),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.add, color: Colors.white),
                  onPressed: () {
                    _addTask(_taskController.text);
                    _taskController.clear();
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                Task task = tasks[index];
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black, // Background black
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: _getBorderColor(task.status), // Dynamic border
                      width: 2,
                    ),
                  ),
                  child: ListTile(
                    title: Text(
                      task.description,
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Row(
                      children: [
                        Text('Status: ',
                            style: TextStyle(color: Colors.white70)),
                        DropdownButton<String>(
                          dropdownColor: Colors.black, // Black dropdown
                          value: task.status,
                          items: statuses.map((status) {
                            return DropdownMenuItem(
                              value: status,
                              child: Text(status,
                                  style: TextStyle(color: Colors.white)),
                            );
                          }).toList(),
                          onChanged: (newStatus) {
                            if (newStatus != null) {
                              _updateTaskStatus(index, newStatus);
                            }
                          },
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () => _removeTask(index),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
