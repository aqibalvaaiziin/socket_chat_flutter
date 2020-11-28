import 'package:flutter/material.dart';
import './chat_page_view.dart';

class ChatPage extends StatefulWidget {
  final String name;

  const ChatPage({Key key, this.name}) : super(key: key);
  @override
  ChatPageView createState() => new ChatPageView();
}
