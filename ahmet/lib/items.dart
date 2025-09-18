import 'package:flutter/material.dart';
import 'package:ahmet/taskmodel.dart';

class Items extends StatelessWidget {
  final List<Task> tasks; // Map yerine Task listesi
  final Function(int) onDelete;
  final Function(int) onCheckToggle;

  const Items({
    super.key,
    required this.tasks,
    required this.onDelete,
    required this.onCheckToggle,
  });

  Color getPriorityColor(int p) {
    switch (p) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }


  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];

        return buildItem(
          task.title,
          task.isChecked,
          task.priority,
          task.deadline,
          () => onCheckToggle(index),
          () => onDelete(index),
        );
      },
    );
  }

  Widget buildItem(
    String title,
    bool isChecked,
    int priority,
    DateTime deadline,
    VoidCallback onCheckToggle,
    VoidCallback onDelete,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.brown[900],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Text(
            priority.toString(),
            style: TextStyle(
              fontSize: 20,
              color: getPriorityColor(priority),
            ),
          ),
          IconButton(
            icon: Icon(
              isChecked ? Icons.check_box : Icons.check_box_outline_blank,
              color: Colors.deepPurple,
            ),
            onPressed: onCheckToggle,
          ),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 23,
                color: Colors.white,
                decoration: isChecked ? TextDecoration.lineThrough : null,
              ),
            ),
          ),
          Text(
            deadline.toString().split(' ')[0],
            style: TextStyle(
              fontSize: 17,
              color: Colors.green[800],
            ),
          ),
          const SizedBox(width: 10, height: 1),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: onDelete,
            child: const Text("-"),
          ),
        ],
      ),
    );
  }
}
