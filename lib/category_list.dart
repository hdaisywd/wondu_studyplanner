import 'package:flutter/material.dart';
import 'package:mytask/data/task_service.dart';

class CategoryTasksScreen extends StatelessWidget {
  final TaskService taskService = TaskService();

  @override
  Widget build(BuildContext context) {
    Map<int, List<Task>> categorizedTasks = taskService.getTasksByCategory();

    return Scaffold(
      appBar: AppBar(
        title: Text('Category Tasks'),
      ),
      body: ListView.builder(
        itemCount: categorizedTasks.length,
        itemBuilder: (context, index) {
          int category = categorizedTasks.keys.elementAt(index);
          List<Task> tasks = categorizedTasks[category]!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Category $category',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  Task task = tasks[index];

                  return ListTile(
                    title: Text(task.content),
                    subtitle: Text(task.dueDate.toString()),
                    // Add more details or customization as needed
                  );
                },
              ),
              Divider(), // Add a divider between categories
            ],
          );
        },
      ),
    );
  }
}
