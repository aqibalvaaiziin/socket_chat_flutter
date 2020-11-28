import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_socket_io/flutter_socket_io.dart';
import 'package:flutter_socket_io/socket_io_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:real_chat_flutter/utils.dart';
import './chat_page.dart';

abstract class ChatPageViewModel extends State<ChatPage> {
  // Add your state and logic here
  SocketIO socketIO;
  List messages;
  double height, width;
  TextEditingController textController;
  ScrollController scrollController;
  bool isImage = true;
  File selectedImage;
  File selectedFile;
  bool imageLoader = false;
  bool fileLoader = false;
  FilePickerResult filePicker;

  final picker = ImagePicker();
  sendAction() {
    if (textController.text.isNotEmpty) {
      socketIO.sendMessage(
          'send_message',
          json.encode(
            {
              'name': widget.name,
              'message': textController.text,
              'time': Utils.formatDateString(DateTime.now()),
              "type": "text"
            },
          ));
      setState(() {
        messages.insert(
          0,
          {
            'name': widget.name,
            "message": textController.text,
            "time": Utils.formatDateString(DateTime.now()),
            "type": "text"
          },
        );
        isImage = true;
      });
      textController.text = '';
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 1000),
        curve: Curves.ease,
      );
    }
  }

  sendImage() async {
    final pickedFile = await picker.getImage(
      source: ImageSource.camera,
      imageQuality: 80,
      maxWidth: width,
      maxHeight: height * 0.7,
    );

    if (pickedFile != null) {
      setState(() {
        selectedImage = File(pickedFile.path);
        imageLoader = true;
      });
      final bytes = await selectedImage.readAsBytes();
      socketIO.sendMessage(
          'send_message',
          json.encode({
            'name': widget.name,
            "image": bytes,
            "time": Utils.formatDateString(DateTime.now()),
            "type": "image"
          }));
      messages.insert(
        0,
        {
          'name': widget.name,
          "image": bytes,
          "time": Utils.formatDateString(DateTime.now()),
          "type": "image"
        },
      );
      setState(() {
        imageLoader = false;
      });
    } else {
      print('No image selected.');
    }
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 1000),
      curve: Curves.ease,
    );
  }

  sendFile() async {
    filePicker = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    PlatformFile file = filePicker.files.first;
    if (filePicker != null) {
      setState(() {
        selectedFile = File(filePicker.files.single.path);
        fileLoader = true;
      });
      final bytes = await selectedFile.readAsBytes();
      socketIO.sendMessage(
          'send_message',
          json.encode({
            'name': widget.name,
            "fileName": file.name,
            "size": file.size,
            "extention": file.extension,
            "file": bytes,
            "time": Utils.formatDateString(DateTime.now()),
            "type": "file"
          }));
      messages.insert(
        0,
        {
          'name': widget.name,
          "size": file.size,
          "extention": file.extension,
          "fileName": file.name,
          "file": bytes,
          "time": Utils.formatDateString(DateTime.now()),
          "type": "file"
        },
      );
      setState(() {
        fileLoader = false;
      });
    } else {
      print('No File selected.');
    }
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 1000),
      curve: Curves.ease,
    );
  }

  getDataSocket() {
    socketIO.subscribe('receive_message', (jsonData) {
      Map<String, dynamic> data = json.decode(jsonData);
      setState(() {
        if (data['type'] == 'image') {
          messages.insert(
            0,
            {
              'name': data['name'],
              "image": data['image'].cast<int>(),
              "time": data['time'],
              "type": data['type'],
            },
          );
        } else if (data['type'] == 'file') {
          messages.insert(
            0,
            {
              'name': data['name'],
              "fileName": data['fileName'],
              "size": data['size'],
              "extention": data['extention'],
              "file": data['file'].cast<int>(),
              "time": data['time'],
              "type": data['type'],
            },
          );
        } else {
          messages.insert(
            0,
            {
              'name': data['name'],
              "message": data['message'],
              "time": data['time'],
              "type": data['type'],
            },
          );
        }
      });
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 1000),
        curve: Curves.ease,
      );
    });
  }

  @override
  void initState() {
    messages = List();
    textController = TextEditingController();
    scrollController = ScrollController();
    socketIO = SocketIOManager().createSocketIO(
      'https://mychatsockets.herokuapp.com',
      '/',
    );
    socketIO.init();
    getDataSocket();
    socketIO.connect();
    super.initState();
  }
}
