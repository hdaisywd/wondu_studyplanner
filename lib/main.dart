import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'detail_page.dart';
import 'task_service.dart';

late SharedPreferences prefs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TaskService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color.fromARGB(159, 255, 158, 190),
      ),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

// 홈 페이지
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<TaskService>(
      builder: (context, taskService, child) {
        // taskService로 부터 taskList 가져오기
        List<Task> taskList = taskService.taskList;

        return Scaffold(
          drawer: Drawer(
            child: ListView(
              children: [
                UserAccountsDrawerHeader(
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: AssetImage('assets/image/dog.jpg'),
                  ),
                  accountName: Text('원두네'),
                  accountEmail: Text('wondu@gmail.com'),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(159, 242, 170, 255),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0),
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.home),
                  iconColor: Colors.purple,
                  focusColor: Colors.purple,
                  title: Text('홈'),
                  onTap: () {},
                  trailing: Icon(Icons.navigate_next),
                ),
                ListTile(
                  leading: Icon(Icons.shopping_cart_rounded),
                  iconColor: Colors.purple,
                  focusColor: Colors.purple,
                  title: Text('날짜별'),
                  onTap: () {},
                  trailing: Icon(Icons.navigate_next),
                ),
                ListTile(
                  leading: Icon(Icons.shopping_cart_rounded),
                  iconColor: Colors.purple,
                  focusColor: Colors.purple,
                  title: Text('카테고리별'),
                  onTap: () {},
                  trailing: Icon(Icons.navigate_next),
                ),
                ListTile(
                  leading: Icon(Icons.restore_from_trash),
                  iconColor: Colors.purple,
                  focusColor: Colors.purple,
                  title: Text('휴지통'),
                  onTap: () {},
                  trailing: Icon(Icons.navigate_next),
                ),
                ListTile(
                  leading: Icon(Icons.settings),
                  iconColor: Colors.purple,
                  focusColor: Colors.purple,
                  title: Text('설정'),
                  onTap: () {},
                  trailing: Icon(Icons.navigate_next),
                ),
              ],
            ),
          ),
          appBar: AppBar(
            backgroundColor: Color.fromARGB(159, 255, 158, 190),
            title: Text("mytask"),
            actions: [
              IconButton(
                  onPressed: () => Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => SearchTask())),
                  icon: Icon(Icons.search)),
            ],
          ),
          body: taskList.isEmpty
              ? Center(child: Text("메모를 작성해 주세요"))
              : ListView.builder(
                  itemCount: taskList.length, // taskList 개수 만큼 보여주기
                  itemBuilder: (context, index) {
                    Task task = taskList[index]; // index에 해당하는 task 가져오기
                    return ListTile(
                      // 메모 고정 아이콘
                      leading: IconButton(
                        icon: Icon(task.isPinned
                            ? CupertinoIcons.pin_fill
                            : CupertinoIcons.pin),
                        onPressed: () {
                          taskService.updatePinTask(index: index);
                        },
                      ),
                      // 메모 내용 (최대 3줄까지만 보여주도록)
                      title: Text(
                        task.content,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Text(task.updatedAt == null
                          ? ""
                          : task.updatedAt.toString().substring(0, 16)),

                      onTap: () async {
                        // 아이템 클릭시
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailPage(
                              index: index,
                            ),
                          ),
                        );
                        if (task.content.isEmpty) {
                          taskService.deleteTask(index: index);
                        }
                      },
                    );
                  },
                ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () async {
              // + 버튼 클릭시 메모 생성 및 수정 페이지로 이동
              taskService.createTask(content: '');
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DetailPage(
                    index: taskService.taskList.length - 1,
                  ),
                ),
              );
              if (taskList.last.content.isEmpty) {
                taskService.deleteTask(index: taskList.length - 1);
              }
            },
          ),
        );
      },
    );
  }
}

class SearchTask extends StatelessWidget {
  const SearchTask({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          child: TextField(
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              suffixIcon: IconButton(
                onPressed: () {},
                icon: Icon(Icons.clear),
              ),
              hintText: 'Search...',
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }
}
