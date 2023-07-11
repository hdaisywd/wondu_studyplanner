// 홈 페이지
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import 'detail_page.dart';
import 'memo_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // sort order, true: ascending, false: descending
  final bool _sortAscending = true;

  @override
  Widget build(BuildContext context) {
    return Consumer<MemoService>(
      builder: (context, memoService, child) {
        // memoService로 부터 memoList 가져오기
        List<Memo> memoList = memoService.memoList;

        // 여기서부터 내일 다시 해보기 ~. ~
        // void _sortLists(bool ascending){
        //   setState((){
        //     _sortAscending = ascending;
        //     memoList.sort((a, b) => ascending
        //       ? a[''])
        //   })
        // }

        return Scaffold(
          appBar: AppBar(
            title: Text("mymemo"),
          ),
          body: memoList.isEmpty
              ? Center(child: Text("메모를 작성해 주세요"))
              : ListView.builder(
                  itemCount: memoList.length, // memoList 개수 만큼 보여주기
                  itemBuilder: (context, index) {
                    Memo memo = memoList[index]; // index에 해당하는 memo 가져오기
                    return Slidable(
                      key: const ValueKey(0),
                      startActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            onPressed: null,
                            backgroundColor: Color(0xFF21B7CA),
                            foregroundColor: Colors.white,
                            icon: Icons.push_pin,
                            label: 'pin',
                          ),
                        ],
                      ),
                      endActionPane: ActionPane(
                        // swipe from right to left
                        motion: ScrollMotion(),
                        dismissible: DismissiblePane(onDismissed: () {}),
                        children: [
                          SlidableAction(
                              flex: 2,
                              onPressed: null,
                              backgroundColor: Color(0xFFFE4A49),
                              foregroundColor: Colors.white,
                              icon: Icons.delete,
                              label: 'Delete'),
                        ],
                      ),
                      child: ListTile(
                        // 메모 내용 (최대 3줄까지만 보여주도록)
                        title: Text(
                          memo.content,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onTap: () {
                          // 아이템 클릭시
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetailPage(
                                index: index,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              // + 버튼 클릭시 메모 생성 및 수정 페이지로 이동
              memoService.createMemo(content: '');
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DetailPage(
                    index: memoService.memoList.length - 1,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
