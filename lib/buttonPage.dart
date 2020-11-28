import 'package:flutter/material.dart';
import 'package:real_chat_flutter/chat_page/chat_page.dart';

// ignore: must_be_immutable
class StarterPage extends StatelessWidget {

  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 12),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Input your Name",
              ),
            ),
          ),
          RaisedButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ChatPage(name: controller.text),
                  ),
                );
              }
            },
            child: Text("Start"),
          ),
        ],
      ),
    );
  }
}
