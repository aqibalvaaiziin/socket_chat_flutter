import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:real_chat_flutter/color_pallate.dart';
import 'package:real_chat_flutter/widgets/photopreview.dart';
import 'package:real_chat_flutter/widgets/viewpdfpage.dart';
import './chat_page_view_model.dart';

class ChatPageView extends ChatPageViewModel {
  Widget buildSingleMessage(data) {
    return Container(
      alignment: data['name'] != widget.name
          ? Alignment.centerLeft
          : Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.all(10.0),
        constraints: BoxConstraints(
          maxWidth: width * 0.7,
        ),
        margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
        decoration: BoxDecoration(
          color: data['name'] != widget.name ? sender : bubble,
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              child: Text(
                data['message'],
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.0,
                ),
              ),
            ),
            SizedBox(height: 6),
            Container(
              child: Text(
                data['time'],
                style: TextStyle(
                  color: Colors.grey[300],
                  fontSize: 9.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildImageMessage(data) {
    return imageLoader
        ? loaderImage(data)
        : InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => PhotoPreview(
                    url: Uint8List.fromList(data['image']),
                  ),
                ),
              );
            },
            child: Container(
              alignment: data['name'] != widget.name
                  ? Alignment.centerLeft
                  : Alignment.centerRight,
              child: Container(
                padding: const EdgeInsets.all(10.0),
                constraints: BoxConstraints(
                  maxWidth: width * 0.7,
                ),
                margin:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: reply,
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.memory(
                        Uint8List.fromList(data['image']),
                        fit: BoxFit.cover,
                        width: width * 0.4,
                        height: width * 0.4,
                      ),
                    ),
                    SizedBox(height: 6),
                    Container(
                      child: Text(
                        data['time'],
                        style: TextStyle(
                          color: Colors.grey[300],
                          fontSize: 9.0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  Widget buildFileMessage(data) {
    return imageLoader
        ? loaderImage(data)
        : InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ViewPDFPage(
                    dataSource: Uint8List.fromList(data['file']),
                  ),
                ),
              );
            },
            child: Container(
              alignment: data['name'] != widget.name
                  ? Alignment.centerLeft
                  : Alignment.centerRight,
              child: Container(
                padding: const EdgeInsets.all(10.0),
                constraints: BoxConstraints(
                  maxWidth: width * 0.7,
                ),
                margin:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: bubble,
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Container(
                          color: bubblein,
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.file_copy,
                                size: width * 0.065,
                              ),
                              SizedBox(width: 8),
                              SizedBox(
                                width: width * 0.5,
                                child: Text(
                                  data['fileName'],
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15.0,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              )
                            ],
                          ),
                        )),
                    SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Text(
                            "${data['extention'].toUpperCase()} . ${data['size']} kB",
                            style: TextStyle(
                              color: Colors.grey[300],
                              fontSize: 9.0,
                            ),
                          ),
                        ),
                        Container(
                          child: Text(
                            data['time'],
                            style: TextStyle(
                              color: Colors.grey[300],
                              fontSize: 9.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
  }

  Widget loaderImage(data) {
    return Container(
      alignment: data['name'] != widget.name
          ? Alignment.centerLeft
          : Alignment.centerRight,
      child: Container(
          padding: const EdgeInsets.all(10.0),
          constraints: BoxConstraints(
            maxWidth: width * 0.7,
          ),
          margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
          decoration: BoxDecoration(
            color: reply,
            borderRadius: BorderRadius.circular(4.0),
          ),
          child: Center(
            child: CircularProgressIndicator(),
          )),
    );
  }

  Widget buildMessageList() {
    return Expanded(
      flex: 9,
      child: ListView.builder(
        reverse: true,
        controller: scrollController,
        itemCount: messages.reversed.toList().length,
        itemBuilder: (BuildContext context, int index) {
          return messages[index]['type'] == 'image'
              ? buildImageMessage(messages[index])
              : messages[index]['type'] == 'file'
                  ? buildFileMessage(messages[index])
                  : buildSingleMessage(messages[index]);
        },
      ),
    );
  }

  Widget buildChatInput() {
    return Expanded(
      child: Container(
        width: width,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: input,
          borderRadius: BorderRadius.circular(50),
        ),
        child: TextField(
          minLines: 1,
          maxLines: 4,
          decoration: InputDecoration.collapsed(
            hintText: 'Send a message...',
            fillColor: input,
            focusColor: input,
            hoverColor: input,
          ),
          controller: textController,
          onChanged: (value) {
            if (value.isEmpty) {
              setState(() {
                isImage = true;
              });
            } else {
              setState(() {
                isImage = false;
              });
            }
          },
        ),
      ),
    );
  }

  Widget buildSendButton() {
    return isImage
        ? Row(
            children: [
              IconButton(
                icon: Icon(Icons.camera_alt),
                onPressed: () {
                  sendImage();
                },
              ),
              SizedBox(width: 4),
              IconButton(
                icon: Icon(Icons.file_copy),
                onPressed: () {
                  sendFile();
                },
              ),
            ],
          )
        : IconButton(
            color: Colors.white,
            onPressed: () {
              sendAction();
            },
            icon: Icon(
              Icons.send,
              size: 25,
            ),
          );
  }

  Widget buildInputArea() {
    return Container(
      height: height * 0.08,
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      width: width,
      color: dock,
      child: Row(
        children: <Widget>[
          buildChatInput(),
          buildSendButton(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Stack(
        children: [
          Image.asset(
            "assets/s.jpg",
            width: width,
            height: height,
            fit: BoxFit.cover,
          ),
          SingleChildScrollView(
            child: Container(
              width: width,
              height: height * 0.899,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 10),
                  buildMessageList(),
                  SizedBox(height: 10),
                  buildInputArea(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
