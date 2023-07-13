import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mytask/etc/show_category.dart';
import 'package:provider/provider.dart';

import '../data/task_service.dart';

class EditPage extends StatefulWidget {
  const EditPage({Key? key, required this.index}) : super(key: key);

  /* index int */
  final int index;

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  /* 제목 텍스트 편집 컨트롤러 */
  TextEditingController contentController = TextEditingController();
  /* 날짜 텍스트 편집 컨트롤러 */
  TextEditingController dateInput = TextEditingController();
  /* 내용 텍스트 편집 컨트롤러 */
  TextEditingController detailController = TextEditingController();

  /* 선택된 아이콘 번호 변수 */
  int selectedIconNum = 7;

  var editButtonHidden = false;
  DateTime dueDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    TaskService taskService = context.read<TaskService>();
    Task task = taskService.taskList[widget.index];

    contentController.text = task.content;
    // fix: 날짜 추가
    dateInput.text = DateFormat('yyyy-MM-dd').format(task.dueDate);
    detailController.text = task.detail ?? '';
    selectedIconNum = task.category;
    dueDate = task.dueDate;
  }

  @override
  Widget build(BuildContext context) {
    TaskService taskService = context.read<TaskService>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Image.asset(
            'images/wondu_appbar_image.png',
            width: 150,
          ),
          centerTitle: true,
          backgroundColor: Color.fromARGB(159, 255, 158, 190),
          leading: TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
            ),
            onPressed: () => Navigator.pop(context),
            child: Row(
              //mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.chevron_left),
                Text('목록'),
              ],
            ),
          ),
          leadingWidth: 65,
          actions: [
            !editButtonHidden
                ? TextButton(
                    onPressed: () {
                      setState(() {
                        editButtonHidden = true;
                      });
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                    ),
                    child: Text('Edit'),
                  )
                : TextButton(
                    onPressed: () {
                      setState(() {
                        editButtonHidden = false;
                      });
                      taskService.updateTask(
                          index: widget.index,
                          content: contentController.text,
                          dueDate: dueDate);
                      Navigator.pop(context, true); // 수정된 데이터 반환
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                    ),
                    child: Text('Save'),
                  )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 25),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  enabled: editButtonHidden,
                  controller: contentController
                    ..selection = TextSelection.fromPosition(
                        TextPosition(offset: contentController.text.length)),
                  decoration: InputDecoration(
                    icon: Icon(CupertinoIcons.paw),
                    labelText: "Task",
                  ),
                  onChanged: (value) {
                    taskService.updateTask(
                        index: widget.index, content: value, dueDate: dueDate);
                  },
                  // fix: 완료 누르면 타이틀 바뀌게
                  onEditingComplete: () {
                    setState(() {});
                    FocusScope.of(context).unfocus();
                  },
                ),
                Container(height: 25.0),
                TextField(
                  enabled: editButtonHidden,
                  controller: dateInput,
                  decoration: InputDecoration(
                    icon: Icon(Icons.calendar_today),
                    labelText: "Due Date",
                  ),
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: dueDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );

                    if (pickedDate != null) {
                      String formattedDate =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                      setState(() {
                        dueDate = pickedDate;
                        dateInput.text = formattedDate;
                      });
                    }
                  },
                ),
                Container(height: 45.0),
                TextField(
                  enabled: editButtonHidden,
                  controller: detailController,
                  decoration: InputDecoration(
                    icon: Icon(CupertinoIcons.text_append),
                    labelText: "Description",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 8,
                  onChanged: (value) {
                    taskService.updateDetail(
                        index: widget.index, detail: value);
                  },
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 35, vertical: 80),
                  child: ShowCategory(
                    selectedIconNum: selectedIconNum,
                    taskService: taskService,
                    index: widget.index,
                    onChanged: (val) => selectedIconNum = val,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
