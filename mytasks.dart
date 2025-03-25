import 'package:flutter/material.dart';

class MyTasksScreen extends StatefulWidget {
  @override
  _MyTasksScreenState createState() => _MyTasksScreenState();
}

class _MyTasksScreenState extends State<MyTasksScreen> {
  List<Task> tasks = [
    Task(name: "Complete Flutter Assignment", completed: false),
    Task(name: "Read 10 pages of a book", completed: false),
    Task(name: "Workout for 30 minutes", completed: false),
  ];

  void toggleTaskCompletion(int index) {
    setState(() {
      tasks[index].completed = !tasks[index].completed;
    });
  }

  void addNewTask(String taskName) {
    if (taskName.isNotEmpty) {
      setState(() {
        tasks.add(Task(name: taskName, completed: false));
      });
    }
  }

  void deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[100],
      appBar: AppBar(
        backgroundColor: Colors.purple[300],
        title: Text("My Tasks"),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _buildAddTaskField(),
            SizedBox(height: 10),
            Expanded(child: _buildTaskList()),
          ],
        ),
      ),
    );
  }

  Widget _buildAddTaskField() {
    TextEditingController taskController = TextEditingController();
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: taskController,
            decoration: InputDecoration(
              hintText: "Enter a new task",
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ),
        SizedBox(width: 10),
        ElevatedButton(
          onPressed: () {
            addNewTask(taskController.text);
            taskController.clear();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.purple[600],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            minimumSize: Size(50, 50),
          ),
          child: Icon(Icons.add, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildTaskList() {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        return _buildTaskItem(tasks[index], index);
      },
    );
  }

  Widget _buildTaskItem(Task task, int index) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Icon(Icons.task, color: Colors.purple),
        title: Text(
          task.name,
          style: TextStyle(
            decoration: task.completed ? TextDecoration.lineThrough : TextDecoration.none,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(task.completed ? Icons.check_circle : Icons.circle_outlined,
                  color: task.completed ? Colors.green : Colors.grey),
              onPressed: () => toggleTaskCompletion(index),
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () => deleteTask(index),
            ),
          ],
        ),
      ),
    );
  }
}

class Task {
  String name;
  bool completed;
  Task({required this.name, this.completed = false});
}
