
import 'package:ahmet/ikinciSayfa.dart';
import 'package:flutter/material.dart';
import 'package:ahmet/items.dart';
import 'package:ahmet/products.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:ahmet/taskmodel.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

int priorityDefault = 0;

class _HomeState extends State<Home> {
  DateTime? selectedDeadline;

  List<Task> tasks = [
    Task(title: "Görev 1", isChecked: false, priority: 1, deadline: DateTime(2025, 8, 11)),
    Task(title: "Görev 2", isChecked: false, priority: 3, deadline: DateTime(2025, 8, 19)),
    Task(title: "Görev 3", isChecked: false, priority: 2, deadline: DateTime(2025, 10, 30)),
    Task(title: "Görev 4", isChecked: false, priority: 3, deadline: DateTime(2025, 12, 2)),
  ]..sort((a, b) => b.priority.compareTo(a.priority));

  List<Task> showTasks = [];
  var text = TextEditingController();
  

  @override
  void initState() {
    super.initState();
    loadTasks();
  }



  Future <void> navigationAddTask() async {
    final newTask = await Navigator.push(context, MaterialPageRoute(builder: (context) => AddTaskPage()),
    );

    if (newTask != null){
      setState(() {
        tasks.add(newTask);
        showTasks=List.from(tasks);
        showTasks.sort((a, b) => b.priority.compareTo(a.priority));
      });
      saveTasks();
    }
    saveTasks();
  } 


  void filterTasksBySelectedDate() {
  setState(() {
    if (selectedDeadline != null) {
      showTasks = tasks.where((task) =>
        task.deadline.isAfter(selectedDeadline!)
      ).toList();
    } else {
      showTasks = List.from(tasks);
    }
    showTasks.sort((a, b) => b.priority.compareTo(a.priority));
  });
}


 Future<void> saveTasks() async {
  final prefs = await SharedPreferences.getInstance();
  final taskListJson = tasks.map((t) => t.toJson()).toList();
  await prefs.setString('tasks', jsonEncode(taskListJson));
}

Future<void> loadTasks() async {
  final prefs = await SharedPreferences.getInstance();
  final savedData = prefs.getString('tasks');
  if (savedData != null) {
    final List<dynamic> decoded = jsonDecode(savedData);
    tasks = decoded.map((e) => Task.fromJson(e as Map<String, dynamic>)).toList();
  }
  setState(() {
    showTasks = List.from(tasks);
    showTasks.sort((a, b) => b.priority.compareTo(a.priority));
  });
}


/*

void addTask(String newTask) {
  setState(() {
    tasks.add(
      Task(
        title: newTask,
        isChecked: false,
        priority: priorityDefault,
        deadline: selectedDeadline ?? DateTime.now(),
      ),
    );

    showTasks = tasks.where((task) => 
      !task.deadline.isBefore(DateTime.now())
    ).toList();

    showTasks.sort((a, b) => b.priority.compareTo(a.priority));

    

    saveTasks();
  });
}


*/



  void deleteTask(int index) {
    setState(() {
      final taskToRemove = showTasks[index];
      tasks.remove(taskToRemove);
      showTasks = List.from(tasks);
      saveTasks();
    });
  }

  void toggleTask(int index) {
    setState(() {
      final task = showTasks[index];
      final originalIndex = tasks.indexOf(task);
      if (originalIndex != -1) {
        tasks[originalIndex].isChecked = !tasks[originalIndex].isChecked;
      }
      showTasks = List.from(tasks);
      saveTasks();
    });
  }

  void searchTask(String textSearched) {
    setState(() {
      final q = textSearched.toLowerCase();
      if (q.isEmpty) {
        showTasks = List.from(tasks);
      } else {
        showTasks = tasks.where((t) => t.title.toLowerCase().contains(q)).toList();
      }
    });
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now.subtract(const Duration(days: 7)),
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked != null && picked != selectedDeadline) {
      setState(() {
        selectedDeadline = picked;
      });
    }
    filterTasksBySelectedDate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("To Do List"),
        backgroundColor: Colors.brown[500],
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () => selectDate(context),
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.brown[300],
              borderRadius: BorderRadius.circular(20),
            ),
            child: TextField(
              controller: text,
              decoration: const InputDecoration(
                icon: Icon(Icons.search),
                hintText: "Search",
                border: InputBorder.none,
              ),
              onChanged: searchTask,
            ),
          ),
          Expanded(
            child: Items(
              tasks: showTasks,
              onDelete: deleteTask,
              onCheckToggle: toggleTask,
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
  onPressed: navigationAddTask,
  child: Icon(Icons.add),
),

    );
  }
}
