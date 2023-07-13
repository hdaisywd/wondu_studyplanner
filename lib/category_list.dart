import 'package:flutter/material.dart';
import 'package:mytask/data/task_service.dart';
import '../etc/category_icon.dart';

class CategoryTasksScreen extends StatefulWidget {
  @override
  _CategoryTasksScreenState createState() => _CategoryTasksScreenState();
}

class _CategoryTasksScreenState extends State<CategoryTasksScreen> {
  final TaskService taskService = TaskService();
  late List<int> categories;
  int selectedCategory = 7; // Default selected category

  @override
  void initState() {
    super.initState();
    categories = taskService.getCategories();
  }

  @override
  Widget build(BuildContext context) {
    Map<int, List<Task>> categorizedTasks = taskService.getTasksByCategory();

    return Scaffold(
      appBar: AppBar(
        title: Text('Category Tasks'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CategoryIcon(
                  0,
                  selectedCategory,
                  Icons.book,
                  changeIcon,
                ),
                CategoryIcon(
                  1,
                  selectedCategory,
                  Icons.book,
                  changeIcon,
                ),
                CategoryIcon(
                  2,
                  selectedCategory,
                  Icons.sports_basketball,
                  changeIcon,
                ),
                CategoryIcon(
                  3,
                  selectedCategory,
                  Icons.games,
                  changeIcon,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: categorizedTasks[selectedCategory]?.length ?? 0,
              itemBuilder: (context, index) {
                Task task = categorizedTasks[selectedCategory]![index];

                return ListTile(
                  title: Text(task.content),
                  subtitle: Text(task.dueDate.toString()),
                  // Add more details or customization as needed
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void changeIcon(int num) {
    setState(() {
      selectedCategory = num;
    });
  }
}
