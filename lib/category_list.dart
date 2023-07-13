import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mytask/data/task_service.dart';
import '../etc/category_icon.dart';
import 'add&edit/detail_page.dart';
import 'etc/search_task.dart';

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
    List<Task> selectedTasks = categorizedTasks[selectedCategory] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'images/wondu_appbar_image.png',
          width: 150,
        ),
        backgroundColor: Color.fromARGB(159, 255, 158, 190),
        centerTitle: true,
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
                  CupertinoIcons.book,
                  changeIcon,
                ),
                CategoryIcon(
                  1,
                  selectedCategory,
                  CupertinoIcons.building_2_fill,
                  changeIcon,
                ),
                CategoryIcon(
                  2,
                  selectedCategory,
                  CupertinoIcons.sportscourt,
                  changeIcon,
                ),
                CategoryIcon(
                  3,
                  selectedCategory,
                  CupertinoIcons.gamecontroller,
                  changeIcon,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: selectedTasks.length,
              itemBuilder: (context, index) {
                Task task = selectedTasks[index];

                return ListTile(
                  title: Text(task.content),
                  subtitle: Text(task.dueDate.toString()),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailPage(index: taskService.taskList.indexOf(task)), // 수정된 부분
                      ),
                    );
                  },
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
