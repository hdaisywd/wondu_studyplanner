// 메모 생성 및 수정 페이지
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mytask/category/show_category.dart';
import 'package:provider/provider.dart';

import '../network/task_service.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key, required this.index});

  /* index int */
  final int index;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  /* 제목 텍스트 편집 컨트롤러 */
  TextEditingController contentController = TextEditingController();
  /* 날짜 텍스트 편집 컨트롤러 */
  TextEditingController dateInput = TextEditingController();
  /* 내용 텍스트 편집 컨트롤러 */
  TextEditingController detailController = TextEditingController();

  /* 선택된 아이콘 번호 변수 */
  int selectedIconNum = 7;

  var editButtonHidden = false;
  var categoryIsEnabled = false;
  DateTime dueDate = DateTime.now();

  /* valiation check */
  bool contentValidate = false;
  bool dueDateValidate = false;

  late final TaskService taskService;
  late final Task task;

  @override
  void initState() {
    super.initState();
    taskService = context.read<TaskService>();
    task = taskService.taskList[widget.index];

    contentController.text = task.content;
    dateInput.text = DateFormat('yyyy-MM-dd').format(task.dueDate);

    detailController.text = task.detail ?? '';
    selectedIconNum = task.category;
    dueDate = task.dueDate;
  }

  @override
  Widget build(BuildContext context) {
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
                        categoryIsEnabled = true;
                      });
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                    ),
                    child: Text('Edit'),
                  )
                : TextButton(
                    onPressed: () {
                      if (contentController.text != "" &&
                          dateInput.text != "") {
                        taskService.updateTask(
                            index: widget.index,
                            content: contentController.text,
                            dueDate: dueDate);
                        debugPrint(task.content);
                        debugPrint(task.dueDate.toString());
                        setState(() {
                          editButtonHidden = false;
                          categoryIsEnabled = false;
                        });
                      } else {
                        setState(() {
                          if (contentController.text == "") {
                            contentValidate = true;
                          }
                          if (dateInput.text == "") {
                            dueDateValidate = true;
                          }
                        });
                      }
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
                      errorText: contentValidate
                          ? 'please fill in the textfield'
                          : null),
                  onChanged: (value) {
                    setState(() {
                      contentController.text.isEmpty
                          ? contentValidate = true
                          : contentValidate = false;
                    });
                  },
                  // fix: 완료 누르면 타이틀 바뀌게
                  onEditingComplete: () {
                    setState(
                      () {},
                    );
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
                      errorText: dueDateValidate
                          ? 'please fill in the textfield'
                          : null),
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      // fix: initialDate = task.dueDate,
                      initialDate: taskService.taskList[widget.index].dueDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime(2100),
                    );

                    if (pickedDate != null) {
                      // log(pickedDate);
                      /// 사용자에게 민감한 정보가 그대로 로그에 나와서 문제가 될까봐 print보단 debugPrint,log를 사용하는 추세
                      String formattedDate =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                      debugPrint(formattedDate);
                      setState(
                        () {
                          dueDate = pickedDate;
                          dateInput.text = formattedDate;
                          // fix: task.dueDate = pickedDate;
                        },
                      );
                    } else {}
                    setState(() {
                      dateInput.text.isEmpty
                          ? dueDateValidate = true
                          : dueDateValidate = false;
                    });
                    // fix: onChanged 추가
                  },
                ),
                Container(height: 45.0),
                TextField(
                  enabled: editButtonHidden,
                  controller: detailController,
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
                    // fix: 상세 내용으로 변경
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
                    categoryIsEnabled: categoryIsEnabled,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showDeleteDialog(BuildContext context, TaskService taskService) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("정말로 삭제하시겠습니까?"),
          actions: [
            // 취소 버튼
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("취소"),
            ),
            // 확인 버튼
            TextButton(
              onPressed: () {
                taskService.deleteTask(index: widget.index);
                Navigator.pop(context); // 팝업 닫기
                Navigator.pop(context); // HomePage 로 가기
              },
              child: Text(
                "확인",
                style: TextStyle(color: Colors.pink),
              ),
            ),
          ],
        );
      },
    );
  }
}
