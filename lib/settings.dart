import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  final String accountName;
  final String accountEmail;

  const SettingsPage({
    Key? key,
    required this.accountName,
    required this.accountEmail,
  }) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.accountName);
    _emailController = TextEditingController(text: widget.accountEmail);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('설정'),
        backgroundColor: Color.fromARGB(159, 255, 158, 190),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '이름',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            Text(
              '이메일',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                String newName = _nameController.text;
                String newEmail = _emailController.text;
                // 이름과 이메일을 업데이트하는 로직 추가

                // 업데이트가 완료되면 이전 화면으로 돌아감
                Navigator.pop(context);
              },
              child: Text('저장'),
            ),
          ],
        ),
      ),
    );
  }
}
