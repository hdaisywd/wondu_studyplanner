import 'package:flutter/cupertino.dart';
import 'package:mytask/data/task_service.dart';

import 'category_icon.dart';

class ShowCategory extends StatefulWidget {
  const ShowCategory({
    super.key,
    required this.selectedIconNum,
    required this.taskService,
    required this.index,
    required this.onChanged,
  });

  final int selectedIconNum, index;
  final TaskService taskService;
  final void Function(int val) onChanged;

  @override
  State<ShowCategory> createState() => _ShowCategoryState();
}

class _ShowCategoryState extends State<ShowCategory> {
  late int selectedIconNum, index;
  late final TaskService taskService;

  @override
  void initState() {
    super.initState();
    setState(() {
      selectedIconNum = widget.selectedIconNum;
      index = widget.index;
      taskService = widget.taskService;
    });
  }

  void changeIcon(int num) {
    setState(() {
      selectedIconNum = num;
      widget.onChanged(num);
      widget.taskService.updateCategory(
        index: index,
        category: selectedIconNum,
      );
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
              0,
              selectedIconNum,
              CupertinoIcons.book,
              changeIcon,
            ),
            CategoryIcon(
              1,
              selectedIconNum,
              CupertinoIcons.building_2_fill,
              changeIcon,
            ),
            CategoryIcon(
              2,
              selectedIconNum,
              CupertinoIcons.sportscourt,
              changeIcon,
            ),
            CategoryIcon(
              3,
              selectedIconNum,
              CupertinoIcons.gamecontroller,
              changeIcon,
            ),
          ],
        ),
        Container(height: 10.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            //버튼에 자신의 번호, 선택된 번호, 아이콘, setState를 넘겨줌
            CategoryIcon(
              4,
              selectedIconNum,
              CupertinoIcons.cart,
              changeIcon,
            ),
            CategoryIcon(
              5,
              selectedIconNum,
              CupertinoIcons.bus,
              changeIcon,
            ),
            CategoryIcon(
              6,
              selectedIconNum,
              CupertinoIcons.bandage,
              changeIcon,
            ),
            CategoryIcon(
              7,
              selectedIconNum,
              CupertinoIcons.square_favorites_alt,
              changeIcon,
            ),
          ],
        ),
      ],
    );
  }
}
