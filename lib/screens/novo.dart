import 'package:flutter/material.dart';
import 'package:natal_smart/components/editor.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text('New Item'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Editor(
              controller: _controladorNome,
              rotulo: 'Nome',
            ),
            Editor(
              controller: _controladorCodigo,
              rotulo: 'Código',
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Editor(
                    controller: _controladorValueOn,
                    rotulo: 'Valor ON',
                  ),
                ),
                Expanded(
                  child: Editor(
                    controller: _controladorValueOff,
                    rotulo: 'Valor OFF',
                  ),
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
    final String nome = _controladorNome.text;
    final String codigo = _controladorCodigo.text;
    final String valueOn = _controladorValueOn.text;
    final String valueOff = _controladorValueOff.text;

    final itemSmart = Item(nome, codigo, valueOn, valueOff, false);

    Navigator.pop(context, itemSmart);
  }
}
