import 'package:flutter/material.dart';
import 'package:natal_smart/components/editor.dart';
import 'package:shared_preferences/shared_preferences.dart';
class ConfigPage extends StatefulWidget {
  @override
  _ConfigPageState createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  final TextEditingController _controladorHostname = TextEditingController();
  final TextEditingController _controladorPort = TextEditingController();
  final TextEditingController _controladorClientId = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  _loadConfig() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _controladorHostname.text = (prefs.getString('hostname') ?? '');
      _controladorPort.text = (prefs.getInt('port') ?? '').toString();
      _controladorClientId.text = (prefs.getString('clientID') ?? '');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configurations'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Editor(
                    controller: _controladorHostname,
                    rotulo: 'Hostname',
                  ),
                ),
                Expanded(
                  child: Editor(
                    controller: _controladorPort,
                    rotulo: 'Port',
                  ),
                ),
              ],
            ),
            Editor(
              controller: _controladorClientId,
              rotulo: 'Client ID',
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: RaisedButton(
                onPressed: () => _saveConfig(context),
                child: Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future _saveConfig(BuildContext context) async {
    final String hostname = _controladorHostname.text;
    final int port = int.tryParse(_controladorPort.text);
    final String clientID = _controladorClientId.text;

    final prefs = await SharedPreferences.getInstance();

    prefs.setString('hostname', hostname);
    prefs.setInt('port', port);
    prefs.setString('clientID', clientID);

    Navigator.pop(context, true);
  }
}
