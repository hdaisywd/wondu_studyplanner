// import 'dart:ffi';
// import 'dart:js_interop';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mytask/main.dart';
import 'package:mytask/search/search_task.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'network/task_service.dart';

late SharedPreferences prefs;

// 휴지통 페이지
class TrashCanPage extends StatefulWidget {
  const TrashCanPage({super.key});

  @override
  State<TrashCanPage> createState() => _TrashCanPageState();
}

class _TrashCanPageState extends State<TrashCanPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<TaskService>(
      builder: (context, taskService, child) {
        // taskService로 부터 taskList 가져오기
        List<Task> taskList =
            taskService.taskList.where((e) => e.isDeleted == true).toList();

        return Scaffold(
          drawer: Drawer(
            child: ListView(
              children: [
                UserAccountsDrawerHeader(
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: AssetImage('images/wondu.jpeg'),
                  ),
                  accountName: Text('원두네'),
                  accountEmail: Text('wondu@gmail.com'),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(159, 242, 170, 255),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0),
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.home),
                  iconColor: Colors.purple,
                  focusColor: Colors.purple,
                  title: Text('홈'),
                  onTap: () async {
                    // 아이템 클릭시
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => HomePage(),
                      ),
                    );
                  },
                  trailing: Icon(Icons.navigate_next),
                ),
                ListTile(
                  leading: Icon(Icons.category),
                  iconColor: Colors.purple,
                  focusColor: Colors.purple,
                  title: Text('카테고리'),
                  onTap: () {},
                  trailing: Icon(Icons.navigate_next),
                ),
                ListTile(
                  leading: Icon(
                    Icons.restore_from_trash,
                  ),
                  iconColor: Colors.purple,
                  focusColor: Color.fromARGB(159, 242, 170, 255),
                  title: Text('휴지통'),
                  onTap: () {
                    Navigator.pop(context);
                  },
                  trailing: Icon(Icons.navigate_next),
                ),
                ListTile(
                  leading: Icon(Icons.settings),
                  iconColor: Colors.purple,
                  focusColor: Colors.purple,
                  title: Text('설정'),
                  onTap: () {},
                  trailing: Icon(Icons.navigate_next),
                ),
              ],
            ),
          ),
          appBar: AppBar(
            title: Text('휴지통'),
            // title: Image.asset(
            //   'images/wondu_appbar_image.png',
            //   width: 150,
            // ),
            backgroundColor: Color.fromARGB(159, 255, 158, 190),
            centerTitle: true,
            actions: [
              IconButton(
                  onPressed: () => Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => SearchTask())),
                  icon: Icon(Icons.search)),
            ],
          ),
          body: taskList.isEmpty
              ? Center(child: Text("휴지통이 비어 있습니다."))
              : ListView.builder(
                  itemCount: taskList.length, // taskList 개수
                  itemBuilder: (context, index) {
                    Task task = taskList[index]; // index에 해당하는 task 가져오기
                    return ListTile(
                      // 메모 내용 (최대 3줄까지만 보여주도록)
                      leading: Icon(Icons.task),
                      title: Text(
                        "Task : ${task.content}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      subtitle: task.updatedAt == null
                          ? Text("Description : ${task.detail}")
                          : Text(
                              "Description : ${task.detail}\nDate : ${task.updatedAt.toString().substring(0, 16)}"),
                      isThreeLine: true,

                      onTap: () async {
                        void showConfirmDeleteDialog(
                            BuildContext context, TaskService taskService) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("휴지통에서 정말로 삭제하시겠습니까?"),
                                actions: [
                                  // 취소 버튼
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text("취소"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      taskService.unDeleteTask(index: index);
                                      Navigator.pop(context);
                                    },
                                    child: Text("복구"),
                                  ),
                                  // 확인 버튼
                                  TextButton(
                                    onPressed: () {
                                      taskService.deleteTask(index: index);
                                      Navigator.pop(context); // 팝업 닫기
                                    },
                                    child: Text(
                                      "삭제",
                                      style: TextStyle(color: Colors.pink),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        }

                        showConfirmDeleteDialog(context, taskService);
                        if (task.content.isEmpty) {
                          taskService.deleteTask(index: index);
                        }
                      },
                    );
                  },
                ),
        );
      },
    );
  }
}
