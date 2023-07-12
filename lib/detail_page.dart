// 메모 생성 및 수정 페이지
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mytask/show_category.dart';
import 'package:provider/provider.dart';

import 'task_service.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key, required this.index});

  final int index;

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  TextEditingController contentController = TextEditingController();
  TextEditingController dateInput = TextEditingController();
  // fix: dueDate 컨트롤러 생성?
  TextEditingController detailController = TextEditingController();
  int selectedIconNum = 7;

  @override
  Widget build(BuildContext context) {
    TaskService taskService = context.read<TaskService>();
    Task task = taskService.taskList[widget.index];

    contentController.text = task.content;
    // fix: 날짜 추가
    //dateInput.text = ??;
    detailController.text = task.detail ?? '';
    selectedIconNum = task.category;

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
            IconButton(
              onPressed: () {
                // 삭제 버튼 클릭시
                showDeleteDialog(context, taskService);
              },
              icon: Icon(Icons.delete),
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
                    taskService.updateTask(index: widget.index, content: value);
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
                      print(pickedDate);
                      String formattedDate =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                      print(formattedDate);
                      setState(
                        () {
                          dateInput.text = formattedDate;
                          // fix: task.dueDate = pickedDate;
                        },
                      );
                    } else {}
                    // fix: onChanged 추가
                  },
                ),
                Container(height: 45.0),
                TextField(
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

// class ShowCategory extends StatefulWidget {
//   ShowCategory({
//     super.key,
//     required this.selectedIconNum,
//     required this.taskService,
//     required this.index,
//   });

//   int selectedIconNum;
//   TaskService taskService;
//   int index;

//   @override
//   State<ShowCategory> createState() => _ShowCategoryState();
// }

// class _ShowCategoryState extends State<ShowCategory> {
//   void changeIcon(int num) {
//     setState(() {
//       widget.selectedIconNum = num;
//       widget.taskService.updateCategory(
//           index: widget.index, category: widget.selectedIconNum);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             //버튼에 자신의 번호, 선택되어 있는 번호, 아이콘, setState를 넘겨줌
//             CategoryIcon(
//                 0, widget.selectedIconNum, CupertinoIcons.book, changeIcon),
//             CategoryIcon(1, widget.selectedIconNum,
//                 CupertinoIcons.building_2_fill, changeIcon),
//             CategoryIcon(2, widget.selectedIconNum, CupertinoIcons.sportscourt,
//                 changeIcon),
//             CategoryIcon(3, widget.selectedIconNum,
//                 CupertinoIcons.gamecontroller, changeIcon),
//           ],
//         ),
//         Container(height: 10.0),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceAround,
//           children: [
//             //버튼에 자신의 번호, 선택된 번호, 아이콘, setState를 넘겨줌
//             CategoryIcon(
//                 4, widget.selectedIconNum, CupertinoIcons.cart, changeIcon),
//             CategoryIcon(
//                 5, widget.selectedIconNum, CupertinoIcons.bus, changeIcon),
//             CategoryIcon(
//                 6, widget.selectedIconNum, CupertinoIcons.bandage, changeIcon),
//             CategoryIcon(7, widget.selectedIconNum,
//                 CupertinoIcons.square_favorites_alt, changeIcon),
//           ],
//         ),
//       ],
//     );
//   }
// }
