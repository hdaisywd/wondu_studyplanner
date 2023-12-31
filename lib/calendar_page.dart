import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:mytask/view/detail_page.dart';
import 'package:provider/provider.dart';

import 'network/task_service.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<TaskService>(
      builder: (context, taskService, child) {
        // taskService로 부터 taskList 가져오기
        List<Task> taskList = taskService.taskList;
        bool isChecked = false;
        DateTime now = DateTime.now();
        List<Task> notTodayList = taskList
            .where((e) =>
                DateTime(e.dueDate.year, e.dueDate.month, e.dueDate.day)
                    .isAfter(DateTime(now.year, now.month, now.day)) &&
                e.isDeleted == false)
            .toList();

        return Scaffold(
          appBar: AppBar(
            title: Text('Calendar'),
            backgroundColor: Color.fromARGB(159, 255, 158, 190),
            centerTitle: true,
          ),
          body: notTodayList.isEmpty
              ? Center(child: Text("메모를 작성해 주세요"))
              : ListView.separated(
                  itemCount: notTodayList.length, // taskList 개수 만큼 보여주기
                  itemBuilder: (context, index) {
                    Task task = notTodayList[index]; // index에 해당하는 task 가져오기
                    isChecked = task.isChecked;
                    return Slidable(
                        key: UniqueKey(), // 트리에서 삭제 문제 해결
                        startActionPane: ActionPane(
                          motion: const ScrollMotion(),
                          children: [
                            SlidableAction(
                              //onPressed:
                              onPressed: (context) {
                                taskService.updatePinTask(
                                    index: taskList.indexOf(task));
                              },
                              backgroundColor: Color(0xFF21B7CA),
                              foregroundColor: Colors.white,
                              icon: Icons.push_pin,
                            ),
                          ],
                        ),
                        endActionPane: ActionPane(
                          // swipe from right to left
                          motion: ScrollMotion(),
                          // dismissible: DismissiblePane(onDismissed: () {
                          //   taskService.deleteTask(index: index); // 리스트에서 밀어서 삭제
                          // }),
                          children: [
                            SlidableAction(
                                autoClose: false,
                                flex: 2,
                                onPressed: (context) {
                                  taskService.updateDeleteTask(
                                      index: taskList.indexOf(task));
                                },
                                backgroundColor: Color(0xFFFE4A49),
                                foregroundColor: Colors.white,
                                icon: Icons.delete,
                                label: 'Delete'),
                          ],
                        ),
                        child: ListTile(
                          tileColor: isChecked
                              ? const Color.fromARGB(255, 198, 198, 198)
                              : null,
                          leading: Checkbox(
                            value: isChecked,
                            onChanged: (value) {
                              setState(() {
                                {
                                  isChecked = value!;
                                  taskService.updateCheckTask(
                                      index: taskList.indexOf(task));
                                }
                              });
                            },
                            activeColor: Colors.grey,
                            checkColor: Colors.black,
                          ),
                          // leading: task.isPinned
                          //     ? Icon(CupertinoIcons.pin_fill)
                          //     : null,
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
                                        Icon(CupertinoIcons.pin_fill, size: 14),
                                  ),
                              ],
                            ),
                          ),
                          trailing: Text(
                            DateFormat('yy/MM/dd').format(task.dueDate),
                          ),

                          onTap: () async {
                            // 아이템 클릭시
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => DetailPage(
                                  index: taskList.indexOf(task),
                                ),
                              ),
                            );
                            if (task.content.isEmpty) {
                              taskService.deleteTask(
                                  index: taskList.indexOf(task));
                            }
                          },
                        ));
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider(
                      thickness: 1,
                      height: 0,
                      indent: 0,
                      endIndent: 0,
                    );
                  },
                ),
        );
      },
    );
  }
}
