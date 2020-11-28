import 'package:flutter/material.dart';
import 'package:pdf_render/pdf_render_widgets2.dart';

class ViewPDFPage extends StatefulWidget {
  final dataSource;

  const ViewPDFPage({Key key, this.dataSource}) : super(key: key);
  @override
  _ViewPDFPageState createState() => _ViewPDFPageState();
}

class _ViewPDFPageState extends State<ViewPDFPage> {
  final controller = PdfViewerController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        centerTitle: true,
        title: ValueListenableBuilder<Object>(
            valueListenable: controller,
            builder: (context, _, child) => Text(controller.isReady
                ? 'Page #${controller.currentPageNumber}'
                : 'Page -')),
      ),
      backgroundColor: Colors.grey,
      body: PdfViewer(
        data: widget.dataSource,
        padding: 16,
        minScale: 1.0,
        viewerController: controller,
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          FloatingActionButton(
              heroTag: 'firstPage',
              child: Icon(Icons.first_page),
              onPressed: () => controller?.goToPage(pageNumber: 1)),
          FloatingActionButton(
              heroTag: 'lastPage',
              child: Icon(Icons.last_page),
              onPressed: () =>
                  controller?.goToPage(pageNumber: controller?.pageCount)),
        ],
      ),
    );
  }
}
