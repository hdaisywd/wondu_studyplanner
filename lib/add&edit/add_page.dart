// 메모 생성 및 수정 페이지
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mytask/etc/show_category.dart';
import 'package:provider/provider.dart';

import '../data/task_service.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key, required this.index});

  /* index Int */
  final int index;

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  /* 제목 텍스트 편집 컨트롤러 */
  TextEditingController contentController = TextEditingController();
  /* 날짜 텍스트 편집 컨트롤러 */
  TextEditingController dateInput = TextEditingController();
  /* 내용 텍스트 편집 컨트롤러 */
  TextEditingController addController = TextEditingController();

  /* 선택된 아이콘 번호 변수 */
  var selectedIconNum = 7;
  DateTime selectedDateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    TaskService taskService = context.read<TaskService>();
    Task task = taskService.taskList[widget.index];

    // contentController.text = task.content;
    // fix: 날짜 추가
    //dateInput.text = ??;
    // addController.text = task.detail ?? '';
    // selectedIconNum = task.category;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(159, 255, 158, 190),
          leading: TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
            ),

            /// 뒤로 가기 버튼 클릭 시
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
          title: Text(
            /// 상단 중앙 제목
            "Add Task",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          actions: [
            TextButton(
              onPressed: () {
                // save 버튼 클릭 시 -> task 항목 추가, 뷰 pop
                if (contentController.text != "" && dateInput.text != "") {
                  /// 제목과 날짜 필수 처리
                  Navigator.pop(context);
                  taskService.createTask(
                      content: contentController.text,
                      dueDate: selectedDateTime,
                      detail: addController.text,
                      category: selectedIconNum);
                  debugPrint(contentController.text);
                  debugPrint((dateInput.value).toString());
                  debugPrint(addController.text);
                  debugPrint(selectedIconNum.toString());
                }
              },
              style: TextButton.styleFrom(foregroundColor: Colors.white),
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
                  controller: contentController
                    ..selection = TextSelection.fromPosition(
                        TextPosition(offset: contentController.text.length)),
                  decoration: InputDecoration(
                    icon: Icon(CupertinoIcons.paw),
                    labelText: "Task",
                  ),
                  onChanged: (value) {
                    /// title 값 전달
                    // taskService.updateTask(index: widget.index, content: value);
                  },
                  // fix: 완료 누르면 타이틀 바뀌게 -> xx
                  onEditingComplete: () {
                    FocusScope.of(context).unfocus();
                  },
                ),
                Container(height: 25.0),
                TextField(
                  controller: dateInput,
                  decoration: InputDecoration(
                    icon: Icon(Icons.calendar_today),
                    labelText: "Due Date",
                  ),
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      // fix: initialDate = task.dueDate,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );

                    if (pickedDate != null) {
                      // print(pickedDate);
                      selectedDateTime = pickedDate;
                      String formattedDate =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                      debugPrint(formattedDate);
                      dateInput.text =
                          formattedDate; // dateinput text 변경(String)
                      // fix: task.dueDate = pickedDate;
                    } else {}
                    // fix: onChanged 추가
                  },
                ),
                Container(height: 45.0),
                TextField(
                  controller: addController,
                  decoration: InputDecoration(
                    // fix: icon 상단 고정
                    icon: Icon(CupertinoIcons.text_append),
                    labelText: "Description",
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 8,
                  onChanged: (value) {
                    /// description 값 전달
                    // fix: 상세 내용으로 변경
                    // taskService.updateDetail(
                    //     index: widget.index, Add: value);
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
