import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:natal_smart/components/text_editor.dart';
import 'package:natal_smart/services/toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConfigPage extends StatefulWidget {
  @override
  _ConfigPageState createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  final TextEditingController _controladorHostname = TextEditingController();
  final TextEditingController _controladorPort = TextEditingController();
  final TextEditingController _controladorClientId = TextEditingController();
  final TextEditingController _controladorUsername = TextEditingController();
  final TextEditingController _controladorPassword = TextEditingController();

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
      _controladorUsername.text = (prefs.getString('username') ?? '');
      _controladorPassword.text = (prefs.getString('password') ?? '');
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: <Widget>[
          CupertinoSliverNavigationBar(
            largeTitle: Text('Server Configuration'),
            trailing: CupertinoButton(
              padding: EdgeInsets.zero,
              child: Text('Save'),
              onPressed: () {
                _saveConfig(context);
              },
            ),
          ),
          SliverSafeArea(
            top: false,
            minimum: const EdgeInsets.only(top: 4),
            sliver: SliverList(delegate: SliverChildBuilderDelegate(
              (context, index) {
                switch (index) {
                  case 0:
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextEditor(
                        label: 'Hostname',
                        controller: _controladorHostname,
                      ),
                    );
                  case 1:
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextEditor(
                        label: 'Port',
                        controller: _controladorPort,
                      ),
                    );
                  case 2:
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextEditor(
                        label: 'Client ID',
                        controller: _controladorClientId,
                      ),
                    );
                  case 3:
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextEditor(
                        label: 'Username',
                        controller: _controladorUsername,
                      ),
                    );
                  case 4:
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextEditor(
                        label: 'Password',
                        controller: _controladorPassword,
                      ),
                    );
                }
                return null;
              },
            )),
          )
        ],
      ),
    );
  }

  Future _saveConfig(BuildContext context) async {
    final String hostname = _controladorHostname.text;
    final int port = int.tryParse(_controladorPort.text);
    final String clientID = _controladorClientId.text;
    final String username = _controladorUsername.text;
    final String password = _controladorPassword.text;

    final prefs = await SharedPreferences.getInstance();

    prefs.setString('hostname', hostname);
    prefs.setInt('port', port);
    prefs.setString('clientID', clientID);
    prefs.setString('username', username);
    prefs.setString('password', password);

    ToastService.showPositive(msg: 'Server Salvo');

    // Navigator.pop(context, true);
  }
}
