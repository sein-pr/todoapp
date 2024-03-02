import 'package:flutter/material.dart';

import 'task.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DayByDay',
      theme: ThemeData(
        primaryColor: Color(0xFF6C22A6),
        hintColor: Color(0xFF6962AD),
        scaffoldBackgroundColor: Color(0xFF83C0C1),
        fontFamily: 'Segoe UI',
      ),
      home: const MyHomePage(title: 'DayByDay'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Task> tasks = [];
  final TextEditingController _textEditingController = TextEditingController();

  void addTask(String title) {
    setState(() {
      tasks.add(Task(title: title));
    });
  }

  void toggleTask(int index) {
    setState(() {
      tasks[index].completed = !tasks[index].completed;
    });
  }

  void deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Pending Tasks',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                if (!tasks[index].completed) {
                  return Dismissible(
                    key: Key(tasks[index].title),
                    onDismissed: (direction) {
                      setState(() {
                        tasks[index].completed = true;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Task completed!'),
                        duration: Duration(seconds: 2),
                      ));
                    },
                    background: Container(color: Colors.red),
                    child: ListTile(
                      title: Text(
                        tasks[index].title,
                        style: TextStyle(color: Colors.black),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => deleteTask(index),
                      ),
                    ),
                  );
                } else {
                  return SizedBox.shrink();
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Completed Tasks',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                if (tasks[index].completed) {
                  return Dismissible(
                    key: Key(tasks[index].title),
                    onDismissed: (direction) => deleteTask(index),
                    background: Container(color: Colors.red),
                    child: ListTile(
                      title: Text(
                        tasks[index].title,
                        style: TextStyle(color: Colors.black),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => deleteTask(index),
                      ),
                    ),
                  );
                } else {
                  return SizedBox.shrink();
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Add Task"),
                content: TextField(
                  controller: _textEditingController,
                  decoration: InputDecoration(hintText: "Enter your task"),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _textEditingController.clear();
                    },
                    child: Text("Cancel"),
                  ),
                  TextButton(
                    onPressed: () {
                      addTask(_textEditingController.text);
                      Navigator.of(context).pop();
                      _textEditingController.clear();
                    },
                    child: Text("Add"),
                  ),
                ],
              );
            },
          );
        },
        label: Text('Add Task'),
        icon: Icon(Icons.add),
      ),
    );
  }
}
