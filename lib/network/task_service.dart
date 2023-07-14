import 'dart:convert';
// import 'dart:ffi';
// import 'dart:js_interop'; -> Xcode 미지원 에러 발생

import 'package:flutter/material.dart';

import '../main.dart';

// Task 데이터의 형식을 정해줍니다. 추후 isPinned, updatedAt 등의 정보도 저장할 수 있습니다.
class Task {
  Task(
      {required this.content,
      required this.dueDate,
      this.detail,
      this.category = 7,
      this.isPinned = false,
      this.updatedAt,
      this.isDeleted = false,
      this.isChecked = false});

  String content;
  DateTime dueDate;
  String? detail;
  int category;
  bool isPinned;
  bool isDeleted;
  DateTime? updatedAt;
  bool isChecked;

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'dueDate': dueDate.toIso8601String(),
      'detail': detail,
      'category': category,
      'isPinned': isPinned,
      'isDeleted': isDeleted,
      'updatedAt': updatedAt?.toIso8601String(),
      'isChecked': isChecked,
    };
  }

  factory Task.fromJson(json) {
    return Task(
      content: json['content'],
      dueDate: DateTime.parse(json['dueDate'] ?? DateTime(2020, 1, 1)),
      detail: json['detail'] ?? '',
      category: json['category'] ?? 7,
      isPinned: json['isPinned'] ?? false,
      isDeleted: json['isDeleted'] ?? false,
      updatedAt:
          json['updatedAt'] == null ? null : DateTime.parse(json['updatedAt']),
      isChecked: json['isChecked'] ?? false,
    );
  }
}

// Task 데이터는 모두 여기서 관리
class TaskService extends ChangeNotifier {
  TaskService() {
    loadTaskList();
  }

  Map<int, List<Task>> getTasksByCategory() {
    Map<int, List<Task>> tasksByCategory = {};

    for (Task task in taskList) {
      if (!tasksByCategory.containsKey(task.category)) {
        tasksByCategory[task.category] = [];
      }
      if (task.isDeleted == false) {
        tasksByCategory[task.category]!.add(task);
      }
    }

    // Create new lists for each category and copy tasks to the new lists
    Map<int, List<Task>> categorizedTasks = {};
    tasksByCategory.forEach((category, tasks) {
      categorizedTasks[category] = List<Task>.from(tasks);
    });

    return categorizedTasks;
  }

  List<int> getCategories() {
    List<int> categories = [];

    for (Task task in taskList) {
      if (!categories.contains(task.category)) {
        categories.add(task.category);
      }
    }

    return categories;
  }

  List<Task> taskList = [
    Task(
        content: '이전 날짜1',
        dueDate: DateTime(2020, 1, 1),
        category: 1,
        detail: '어제였습니다'), // 더미(dummy) 데이터
    Task(
        content: '이전 날짜2',
        dueDate: DateTime(2020, 1, 1),
        category: 2,
        detail: '오늘이 아니라니'), // 더미(dummy) 데이터
    Task(
        content: '오늘입니다',
        dueDate: DateTime(2023, 7, 14),
        category: 3,
        detail: '오늘이에요'), // 더미(dummy) 데이터
    Task(
        content: '내일이 아닙니다',
        dueDate: DateTime(2023, 7, 14),
        category: 1,
        detail: '오늘이에요'), // 더미(dummy) 데이터
    Task(
        content: '7/14',
        dueDate: DateTime(2023, 7, 14),
        category: 2,
        detail: '오늘입니다'), // 더미(dummy) 데이터
    Task(
        content: '메모 메모',
        dueDate: DateTime(2023, 7, 14),
        category: 4,
        detail: '오늘이에요 오늘오늘오늘오늘오늘오늘오늘오늘오늘오늘오늘오늘오늘오늘오늘오늘오늘오늘오늘오늘'),
    Task(
        content: '오늘이 아닙니다',
        dueDate: DateTime(2023, 7, 15),
        category: 5,
        detail: '오늘이 아닙니다'), // 더미(dummy) 데이터
    Task(
        content: '메모 메모가 오늘이 아닙니다',
        dueDate: DateTime(2023, 7, 15),
        category: 6,
        detail: '메모 메모 오늘이 아녜요'),
    Task(
        content: '사자',
        dueDate: DateTime(2023, 7, 16),
        category: 5,
        detail: '오늘이 아닙니다'), // 더미(dummy) 데이터
    Task(
        content: '고양이',
        dueDate: DateTime(2023, 7, 17),
        category: 6,
        detail: '메모 메모 오늘이 아녜요'),
    Task(
        content: '강아지',
        dueDate: DateTime(2023, 7, 20),
        category: 4,
        detail: '오늘이 아닙니다'), // 더미(dummy) 데이터
    Task(
        content: '원두',
        dueDate: DateTime(2023, 7, 21),
        category: 3,
        detail: '메모 메모 오늘이 아녜요'),
    Task(
        content: '츄르',
        dueDate: DateTime(2023, 8, 1),
        category: 1,
        detail: '오늘이 아닙니다'), // 더미(dummy) 데이터
    Task(
        content: '원두는 강아지',
        dueDate: DateTime(2023, 8, 21),
        category: 1,
        detail: '메모 메모 오늘이 아녜요'),
    Task(
        content: '건물',
        dueDate: DateTime(2023, 8, 3),
        category: 1,
        detail: '오늘이 아닙니다'), // 더미(dummy) 데이터
    Task(
        content: '운동장',
        dueDate: DateTime(2023, 9, 21),
        category: 2,
        detail: '메모 메모 오늘이 아녜요'),
    Task(
        content: '축구장',
        dueDate: DateTime(2023, 7, 21),
        category: 2,
        detail: '메모 메모 오늘이 아녜요'),
  ];

  createTask(
      {required String content,
      required DateTime dueDate,
      String? detail,
      required int category}) {
    Task task = Task(
        content: content,
        updatedAt: DateTime.now(),
        dueDate: dueDate,
        detail: detail,
        category: category);
    taskList.add(task);
    //taskList.sort(((a, b) => a.dueDate.compareTo(b.dueDate)));
    sortList();

    notifyListeners();
    saveTaskList(); // Consumer<TaskService>의 builder 부분을 호출해서 화면 새로고침
  }

  updateTask(
      {required int index,
      required String content,
      required DateTime dueDate}) {
    Task task = taskList[index];
    task.content = content;
    task.dueDate = dueDate;
    task.updatedAt = DateTime.now();
    //taskList.sort(((a, b) => a.dueDate.compareTo(b.dueDate)));
    //sortList();
    notifyListeners();
    saveTaskList();
  }

  updateDetail({required int index, required String detail}) {
    Task task = taskList[index];
    task.detail = detail;
    notifyListeners();
    saveTaskList();
  }

  updateCategory({required int index, required int category}) {
    Task task = taskList[index];
    task.category = category;
    notifyListeners();
    saveTaskList();
  }

  updateCheckTask({required int index}) {
    Task task = taskList[index];
    task.isChecked = !task.isChecked;
    notifyListeners();
    saveTaskList();
  }

  updatePinTask({required int index}) {
    Task task = taskList[index];
    task.isPinned = !task.isPinned;
    taskList = [
      ...taskList.where((element) => element.isPinned),
      ...taskList.where((element) => !element.isPinned),
    ];
    notifyListeners();
    saveTaskList();
  }

  updateDeleteTask({required int index}) {
    Task task = taskList[index];
    task.isDeleted = !task.isDeleted;
    taskList = [
      ...taskList.where((element) => element.isDeleted),
      ...taskList.where((element) => !element.isDeleted),
    ];
    notifyListeners();
    saveTaskList();
  }

  unDeleteTask({required int index}) {
    Task task = taskList[index];
    task.isDeleted = !task.isDeleted;
    taskList = [
      ...taskList.where((element) => element.isDeleted),
      ...taskList.where((element) => !element.isDeleted),
    ];
    notifyListeners();
    saveTaskList();
  }

  deleteTask({required int index}) {
    taskList.removeAt(index);
    notifyListeners();
    saveTaskList();
  }

  saveTaskList() {
    List taskJsonList = taskList.map((task) => task.toJson()).toList();
    // [{"content": "1"}, {"content": "2"}]

    String jsonString = jsonEncode(taskJsonList);
    // '[{"content": "1"}, {"content": "2"}]'

    prefs.setString('taskList', jsonString);
  }

  loadTaskList() {
    String? jsonString = prefs.getString('taskList');
    // '[{"content": "1"}, {"content": "2"}]'

    // content가 null이거나 삭제한 항목이면 로드하지 않음
    if (jsonString == null) return;

    List taskJsonList = jsonDecode(jsonString);
    taskList = taskJsonList.map((json) => Task.fromJson(json)).toList();
    sortList();
  }

  sortList() {
    taskList.sort(((a, b) => a.dueDate.compareTo(b.dueDate)));
    taskList = [
      ...taskList.where((element) => element.isPinned),
      ...taskList.where((element) => !element.isPinned),
    ];
  }
}
