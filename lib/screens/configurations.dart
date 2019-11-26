import 'package:flutter/material.dart';
import 'package:natal_smart/components/dropdown.dart';
import 'package:natal_smart/components/editor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ConfigPage extends StatefulWidget {
  @override
  _ConfigPageState createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  final TextEditingController _controladorHostname = TextEditingController();
  final TextEditingController _controladorPort = TextEditingController();
  final TextEditingController _controladorClientId = TextEditingController();
  final TextEditingController _controladorSubscribeTopic = TextEditingController();
  final TextEditingController _controladorPublishTopic = TextEditingController();

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
      _controladorPublishTopic.text = (prefs.getString('pubTopic') ?? '');
      _controladorSubscribeTopic.text = (prefs.getString('subsTopic') ?? '');
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
            Row(
              children: <Widget>[
                Expanded(
                  child: Editor(
                    controller: _controladorSubscribeTopic,
                    rotulo: 'Subscribe Topic',
                  ),
                ),
                Expanded(
                  child: QoSSelector(),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Editor(
                    controller: _controladorPublishTopic,
                    rotulo: 'Publish Topic',
                  ),
                ),
                Expanded(
                  child: QoSSelector(),
                ),
              ],
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
    final String subsTopic = _controladorSubscribeTopic.text;
    final String pubTopic = _controladorPublishTopic.text;

    final prefs = await SharedPreferences.getInstance();

    prefs.setString('hostname', hostname);
    prefs.setInt('port', port);
    prefs.setString('clientID', clientID);
    prefs.setString('subsTopic', subsTopic);
    prefs.setString('pubTopic', pubTopic);

    Fluttertoast.showToast(
        msg: "Saved",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0
    );

    // final mqttConfig = MQTTConfiguration(hostname, port, clientID, subsTopic, pubTopic);

    // final transferenciaCriada = Transferencia(valor, numeroConta);
    // Navigator.pop(context, transferenciaCriada);
  }
}
