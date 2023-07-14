import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:mytask/network/task_service.dart';
import 'package:mytask/view/detail_page.dart';
import 'view/edit_page.dart';

class CategoryTasksScreen extends StatefulWidget {
  const CategoryTasksScreen({Key? key}) : super(key: key);

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
  }

  @override
  Widget build(BuildContext context) {
    Map<int, List<Task>> categorizedTasks = taskService.getTasksByCategory();
    List<Task> selectedTasks =
        categorizedTasks[selectedCategory] ?? []; // isDeleted가 false인 것만 받아오기
    selectedTasks = selectedTasks.where((e) => e.isDeleted == false).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Category'),
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
            child: ListView.separated(
              itemCount: selectedTasks.length,
              itemBuilder: (context, index) {
                Task task = selectedTasks[index];

                return ListTile(
                  // 메모 고정 아이콘
                  leading: Icon(
                    getCategoryIcon(selectedTasks[index].category),
                  ),
                  // 메모 내용 (최대 3줄까지만 보여주도록)
                  title: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: task.content,
                          style: TextStyle(color: Colors.black)),
                        if (task.isPinned)
                          WidgetSpan(
                            child: 
                              Icon(CupertinoIcons.pin_fill, size:14),
                        ),
                      ]
                    ),
                  ),
                  // Text(
                  //   task.content,
                  //   maxLines: 3,
                  //   overflow: TextOverflow.ellipsis,
                  // ),
                  trailing: Text(
                    DateFormat('yy/MM/dd').format(task.dueDate),
                  ),
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
              separatorBuilder: (BuildContext context, int index) {
                return Divider(
                  thickness: 1,
                  height: 0,
                  endIndent: 0,
                  indent: 0,
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
