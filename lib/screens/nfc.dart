import 'dart:async';

import 'package:flutter/material.dart';
import 'package:natal_smart/components/item_smart.dart';
import 'package:nfc_in_flutter/nfc_in_flutter.dart';

class NFCPage extends StatefulWidget {
  @override
  _NFCPageState createState() => _NFCPageState();
}

class _NFCPageState extends State<NFCPage> {
  List<NDEFRecord> _itemsSmart = List();
  StreamSubscription<NDEFMessage> _stream;

  @override
  void initState() {
    super.initState();
  }

  void _startScanning() {
    setState(() {
      _stream = NFC.readNDEF(once: true).listen((NDEFMessage message) {
        print("Read NDEF message with ${message.records.length} records");
        _itemsSmart = message.records;
        for (NDEFRecord record in message.records) {
          print(
              "Record '${record.id ?? "[NO ID]"}' with TNF '${record.tnf}', type '${record.type}', payload '${record.payload}' and data '${record.data}' and language code '${record.languageCode}'");
        }
      });
    });
  }

  void _stopScanning() {
    _stream?.cancel();
    setState(() {
      _stream = null;
    });
  }

  void _toggleScan() {
    if (_stream == null) {
      _startScanning();
    } else {
      _stopScanning();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _stopScanning();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NFC Test'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.nfc),
            onPressed: _startScanning,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _itemsSmart.length,
        itemBuilder: (context, indice) {
          final item = _itemsSmart[indice];
          return Card(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: ListTile(
                    title: Text(item.data),
                    subtitle: Text(item.languageCode),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Reload',
        child: Icon(Icons.wb_iridescent),
      ),
    );
  }
}
