import 'package:flutter/cupertino.dart';
import 'package:mytask/data/task_service.dart';

import 'category_icon.dart';

class ShowCategory extends StatefulWidget {
  ShowCategory({
    super.key,
    required this.selectedIconNum,
    required this.taskService,
    required this.index,
  });

  int selectedIconNum;
  TaskService taskService;
  int index;

  @override
  State<ShowCategory> createState() => _ShowCategoryState();
}

class _ShowCategoryState extends State<ShowCategory> {
  void changeIcon(int num) {
    setState(() {
      widget.selectedIconNum = num;
      debugPrint(widget.selectedIconNum.toString());
      widget.taskService.updateCategory(
          index: widget.index, category: widget.selectedIconNum);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            //버튼에 자신의 번호, 선택되어 있는 번호, 아이콘, setState를 넘겨줌
            CategoryIcon(
                0, widget.selectedIconNum, CupertinoIcons.book, changeIcon),
            CategoryIcon(1, widget.selectedIconNum,
                CupertinoIcons.building_2_fill, changeIcon),
            CategoryIcon(2, widget.selectedIconNum, CupertinoIcons.sportscourt,
                changeIcon),
            CategoryIcon(3, widget.selectedIconNum,
                CupertinoIcons.gamecontroller, changeIcon),
          ],
        ),
        Container(height: 10.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            //버튼에 자신의 번호, 선택된 번호, 아이콘, setState를 넘겨줌
            CategoryIcon(
                4, widget.selectedIconNum, CupertinoIcons.cart, changeIcon),
            CategoryIcon(
                5, widget.selectedIconNum, CupertinoIcons.bus, changeIcon),
            CategoryIcon(
                6, widget.selectedIconNum, CupertinoIcons.bandage, changeIcon),
            CategoryIcon(7, widget.selectedIconNum,
                CupertinoIcons.square_favorites_alt, changeIcon),
          ],
        ),
      ],
    );
  }
}
