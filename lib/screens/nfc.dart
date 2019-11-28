import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nfc_hce_reader/nfc_hce_reader.dart';
import 'package:flutter/services.dart';

class NFCPage extends StatefulWidget {
  @override
  _NFCPageState createState() => _NFCPageState();
}

class _NFCPageState extends State<NFCPage> {
  String _message = 'none';
  StreamSubscription<String> _stream;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    bool isInitialized;
    try {
      isInitialized = await NfcHceReader.initializeNFCReading();
      _readNFC(context);
    } on PlatformException catch (e) {
      debugPrint('Deu Ruim');
      debugPrint(e.message);
      setState(() {
        _message = e.message;
      });
    } catch(e) {
      debugPrint('Deu Ruim');
      debugPrint(e.message);
      setState(() {
        _message = e.message;
      });
    }

    if (!mounted) return;
  }

  void _readNFC(BuildContext context) {
    StreamSubscription<String> subscription =
        NfcHceReader.readNFCStream().listen((tag) {
      setState(() {
        _message = tag;
        debugPrint("Tag");
        debugPrint(tag);
        _stream?.cancel();
      });
    }, onDone: () {
      setState(() {
        _stream = null;
        debugPrint("Done");
      });
    }, onError: (e) {
      setState(() {
        _stream = null;
        _message = e;
        debugPrint("Deu Erro $e");
      });
    });
    setState(() {
      _stream = subscription;
      debugPrint('Streamou');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NFC Test'),
      ),
      body: Center(
        child: Text('Running on: $_message\n'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: initPlatformState,
        tooltip: 'Reload',
        child: Icon(Icons.replay),
      ),
    );
  }
}
