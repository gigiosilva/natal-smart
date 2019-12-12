import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:natal_smart/components/editor.dart';
import 'package:natal_smart/components/text_editor.dart';
import 'package:natal_smart/models/item_smart.dart';

class NovoPage extends StatefulWidget {
  @override
  _NovoPageState createState() => _NovoPageState();
}

class _NovoPageState extends State<NovoPage> {
  final TextEditingController _controladorNome = TextEditingController();
  final TextEditingController _controladorCodigo = TextEditingController();
  final TextEditingController _controladorValueOn = TextEditingController();
  final TextEditingController _controladorValueOff = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: <Widget>[
          CupertinoSliverNavigationBar(
            largeTitle: Text('New Item'),
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
                          label: 'Name', controller: _controladorNome),
                    );
                  case 1:
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextEditor(
                          label: 'Code', controller: _controladorCodigo),
                    );
                    case 2:
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextEditor(
                          label: 'Value ON', controller: _controladorValueOn),
                    );
                    case 3:
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextEditor(
                          label: 'Value OFF', controller: _controladorValueOff),
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
    final String nome = _controladorNome.text;
    final String codigo = _controladorCodigo.text;
    final String valueOn = _controladorValueOn.text;
    final String valueOff = _controladorValueOff.text;

    final itemSmart = Item(nome, codigo, valueOn, valueOff, false);

    Navigator.pop(context, itemSmart);
  }
}
