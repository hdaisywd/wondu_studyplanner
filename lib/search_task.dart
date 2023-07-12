import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mytask/detail_page.dart';
import 'package:mytask/task_service.dart';
import 'package:provider/provider.dart';

class SearchTask extends StatefulWidget {
  const SearchTask({
    super.key,
  });

  @override
  State<SearchTask> createState() => _SearchTaskState();
}

class _SearchTaskState extends State<SearchTask> {
  TextEditingController searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Consumer<TaskService>(
      builder: (context, taskService, child) {
        List<Task> taskList = taskService.taskList;
        //List<Task> searchedList = taskService.searchedList ?? taskList;

        return Scaffold(
          appBar: AppBar(
            title: Container(
              width: double.infinity,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              child: TextField(
                controller: searchController
                  ..selection = TextSelection.fromPosition(
                      TextPosition(offset: searchController.text.length)),
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: IconButton(
                    onPressed: () {
                      searchController.text = '';
                    },
                    icon: Icon(Icons.clear),
                  ),
                  hintText: 'Search...',
                  border: InputBorder.none,
                ),
                // onChanged: (value) {
                //   taskService.updateTask(index: widget.index, content: value);
                // },
                onEditingComplete: () {
                  setState(
                    () {},
                  );
                  FocusScope.of(context).unfocus();
                },
              ),
            ),
          ),
          // fix: 변경된 레이아웃으로 수정
          body: taskList.isEmpty
              ? Center(child: Text("메모를 작성해 주세요"))
              : ListView.builder(
                  itemCount: taskList.length, // taskList 개수 만큼 보여주기
                  itemBuilder: (context, index) {
                    Task task = taskList[index]; // index에 해당하는 task 가져오기
                    return ListTile(
                      // 메모 고정 아이콘
                      leading: IconButton(
                        icon: Icon(task.isPinned
                            ? CupertinoIcons.pin_fill
                            : CupertinoIcons.pin),
                        onPressed: () {
                          taskService.updatePinTask(index: index);
                        },
                      ),
                      // 메모 내용 (최대 3줄까지만 보여주도록)
                      title: Text(
                        task.content,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Text(task.updatedAt == null
                          ? ""
                          : task.updatedAt.toString().substring(0, 16)),
                      onTap: () async {
                        // 아이템 클릭시
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailPage(
                              index: index,
                            ),
                          ),
                        );
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
