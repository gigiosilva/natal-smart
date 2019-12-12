import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
                      child: _buildHostnameField(),
                    );
                  case 1:
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _buildPortField(),
                    );
                  case 2:
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _buildClientIdField(),
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

  Widget _buildHostnameField() {
    return CupertinoTextField(
      controller: _controladorHostname,
      prefix: Icon(
        CupertinoIcons.location_solid,
        color: CupertinoColors.lightBackgroundGray,
        size: 28,
      ),
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 12),
      clearButtonMode: OverlayVisibilityMode.editing,
      textCapitalization: TextCapitalization.words,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 0,
            color: CupertinoColors.inactiveGray,
          ),
        ),
      ),
      placeholder: 'Hostname',
    );
  }

  Widget _buildPortField() {
    return CupertinoTextField(
      controller: _controladorPort,
      prefix: Icon(
        CupertinoIcons.location_solid,
        color: CupertinoColors.lightBackgroundGray,
        size: 28,
      ),
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 12),
      clearButtonMode: OverlayVisibilityMode.editing,
      textCapitalization: TextCapitalization.words,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 0,
            color: CupertinoColors.inactiveGray,
          ),
        ),
      ),
      placeholder: 'Port',
    );
  }

  Widget _buildClientIdField() {
    return CupertinoTextField(
      controller: _controladorClientId,
      prefix: Icon(
        CupertinoIcons.location_solid,
        color: CupertinoColors.lightBackgroundGray,
        size: 28,
      ),
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 12),
      clearButtonMode: OverlayVisibilityMode.editing,
      textCapitalization: TextCapitalization.words,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 0,
            color: CupertinoColors.inactiveGray,
          ),
        ),
      ),
      placeholder: 'ClientId',
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

    ToastService.showPositive(msg: 'Server Salvo');

    // Navigator.pop(context, true);
  }
}
