import 'package:flutter/material.dart';
import 'package:flutter_nfc_reader/flutter_nfc_reader.dart';

class NFCPage extends StatefulWidget {
  @override
  _NFCPageState createState() => _NFCPageState();
}

class _NFCPageState extends State<NFCPage> {
  TextEditingController writerController = TextEditingController();

  @override
  void initState() {
    super.initState();
    FlutterNfcReader.onTagDiscovered().listen((onData) {
      print(onData.id);
      print(onData.content);
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    writerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NFC Test'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.nfc),
            onPressed: () {
              FlutterNfcReader.read();
            },
          ),
        ],
      ),
      // body: ListView.builder(
      //   itemCount: _itemsSmart.length,
      //   itemBuilder: (context, indice) {
      //     final item = _itemsSmart[indice];
      //     return Card(
      //       child: Row(
      //         children: <Widget>[
      //           Expanded(
      //             child: ListTile(
      //               title: Text(item.data),
      //               subtitle: Text(item.languageCode),
      //             ),
      //           ),
      //         ],
      //       ),
      //     );
      //   },
      // ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
            FlutterNfcReader.write(" ", writerController.text).then((value) {
              print(value.content);
            });
          },
        tooltip: 'Reload',
        child: Icon(Icons.wb_iridescent),
      ),
    );
  }
}
