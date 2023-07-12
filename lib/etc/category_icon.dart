import 'package:flutter/material.dart';

class CategoryIcon extends StatelessWidget {
  final int productNum;
  final int selectedIconNum;
  final IconData mIcon;
  final Function changeIcon;

  const CategoryIcon(
    this.productNum,
    this.selectedIconNum,
    this.mIcon,
    this.changeIcon, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        // 선택된 버튼, 선택안된 버튼 배경색 삼항 연산자로 정의
        color: productNum == selectedIconNum
            ? Color.fromARGB(159, 255, 158, 190)
            : Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: IconButton(
        onPressed: () {
          changeIcon(productNum);
        },
        icon: Icon(
          mIcon,
          color: Colors.black,
        ),
      ),
    );
  }
}
