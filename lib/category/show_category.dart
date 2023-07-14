import 'package:flutter/cupertino.dart';
import 'package:mytask/network/task_service.dart';

import 'category_icon.dart';

class ShowCategory extends StatefulWidget {
  const ShowCategory({
    super.key,
    required this.selectedIconNum,
    required this.taskService,
    required this.index,
    required this.onChanged,
    required this.categoryIsEnabled,
  });

  final int selectedIconNum, index;
  final TaskService taskService;
  final void Function(int val) onChanged;
  final bool categoryIsEnabled;

  @override
  State<ShowCategory> createState() => _ShowCategoryState();
}

class _ShowCategoryState extends State<ShowCategory> {
  late int selectedIconNum, index;
  late final TaskService taskService;
  bool categoryIsEnabled = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      selectedIconNum = widget.selectedIconNum;
      index = widget.index;
      taskService = widget.taskService;
      categoryIsEnabled = widget.categoryIsEnabled;
    });
  }

  void changeIcon(int num) {
    setState(() {
      selectedIconNum = num;
      widget.onChanged(num);
      // widget.taskService.updateCategory(
      //   index: index,
      //   category: selectedIconNum,
      // );
    });
  }

  @override
  Widget build(BuildContext context) {
    setState(() => categoryIsEnabled = widget.categoryIsEnabled);

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
              categoryIsEnabled,
            ),
            CategoryIcon(
              1,
              selectedIconNum,
              CupertinoIcons.building_2_fill,
              changeIcon,
              categoryIsEnabled,
            ),
            CategoryIcon(
              2,
              selectedIconNum,
              CupertinoIcons.sportscourt,
              changeIcon,
              categoryIsEnabled,
            ),
            CategoryIcon(
              3,
              selectedIconNum,
              CupertinoIcons.gamecontroller,
              changeIcon,
              categoryIsEnabled,
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
              categoryIsEnabled,
            ),
            CategoryIcon(
              5,
              selectedIconNum,
              CupertinoIcons.bus,
              changeIcon,
              categoryIsEnabled,
            ),
            CategoryIcon(
              6,
              selectedIconNum,
              CupertinoIcons.bandage,
              changeIcon,
              categoryIsEnabled,
            ),
            CategoryIcon(
              7,
              selectedIconNum,
              CupertinoIcons.square_favorites_alt,
              changeIcon,
              categoryIsEnabled,
            ),
          ],
        ),
      ],
    );
  }
}
