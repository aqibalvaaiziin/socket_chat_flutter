import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class PhotoPreview extends StatelessWidget {
  final url;

  const PhotoPreview({Key key, this.url}) : super(key: key);
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Photo Preview"),
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        centerTitle: true,
      ),
      body: Container(
          child: PhotoView(
        imageProvider: MemoryImage(url),
      )),
    );
  }
}
