import 'package:flutter/material.dart';

import 'main.dart';

// Memo 데이터의 형식을 정해줍니다. 추후 isPinned, updatedAt 등의 정보도 저장할 수 있습니다.
class Memo {
  Memo({
    required this.content,
  });

  String content;
}

// Memo 데이터는 모두 여기서 관리
class MemoService extends ChangeNotifier {
  List<Memo> memoList = [
    Memo(content: '장보기 목록: 사과, 양파'), // 더미(dummy) 데이터
    Memo(content: '새 메모'), // 더미(dummy) 데이터
  ];

  createMemo({required String content}) {
    Memo memo = Memo(content: content);
    memoList.add(memo);
    notifyListeners(); // Consumer<MemoService>의 builder 부분을 호출해서 화면 새로고침
  }

  updateMemo({required int index, required String content}) {
    Memo memo = memoList[index];
    memo.content = content;
    notifyListeners();
  }

  deleteMemo({required int index}) {
    memoList.removeAt(index);
    notifyListeners();
  }
}
