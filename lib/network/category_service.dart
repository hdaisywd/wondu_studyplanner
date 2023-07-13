import 'package:flutter/material.dart';

import '../network/task_service.dart';

class CategoryService extends ChangeNotifier {
  CategoryService(this.taskService);

  final TaskService taskService;

  int getCategoryCount(int category) {
    return taskService.taskList
        .where((task) => task.category == category)
        .length;
  }
}
