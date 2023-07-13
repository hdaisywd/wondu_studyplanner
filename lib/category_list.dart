import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mytask/data/task_service.dart';
import '../etc/category_icon.dart';
import 'add&edit/detail_page.dart';
import 'add&edit/edit_page.dart';

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
    if (!categories.contains(selectedCategory)) {
      selectedCategory =
          categories.isNotEmpty ? categories[0] : selectedCategory;
    }
    setState(() {}); // 초기화된 selectedCategory로 화면을 다시 빌드하여 새로고침
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
            padding: EdgeInsets.all(8.0),
            child: GridView.count(
              shrinkWrap: true,
              crossAxisCount: 4,
              children: [
                for (int category in categories)
                  GestureDetector(
                    onTap: () {
                      changeIcon(category);
                    },
                    child: Container(
                      width: 20.0,
                      height: 16.0,
                      padding: EdgeInsets.all(1.0),
                      decoration: BoxDecoration(
                        color: category == selectedCategory
                            ? Colors.grey
                            : Colors.white,
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Icon(
                        getCategoryIcon(category),
                        size: 20.0,
                        color: category == selectedCategory
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
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
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditPage(
                          index: taskService.taskList.indexOf(task),
                        ),
                      ),
                    );

                    setState(() {});
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  IconData getCategoryIcon(int category) {
    switch (category) {
      case 0:
        return CupertinoIcons.book;
      case 1:
        return CupertinoIcons.building_2_fill;
      case 2:
        return CupertinoIcons.sportscourt;
      case 3:
        return CupertinoIcons.gamecontroller;
      case 4:
        return CupertinoIcons.cart;
      case 5:
        return CupertinoIcons.bus;
      case 6:
        return CupertinoIcons.bandage;
      default:
        return CupertinoIcons.square_favorites_alt;
    }
  }

  void changeIcon(int num) {
    setState(() {
      selectedCategory = num;
    });
  }
}
