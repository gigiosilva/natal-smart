import 'package:flutter/cupertino.dart';
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

  // @override
  // Widget build(BuildContext context) {
  //   return DefaultTextStyle(
  //     style: const TextStyle(
  //       fontFamily: '.SF UI Text',
  //       inherit: false,
  //       fontSize: 17.0,
  //       color: CupertinoColors.black,
  //     ),
  //     child: CupertinoPageScaffold(
  //       navigationBar: const CupertinoNavigationBar(
  //         // We're specifying a back label here because the previous page is a
  //         // Material page. CupertinoPageRoutes could auto-populate these back
  //         // labels.
  //         previousPageTitle: 'Cupertino',
  //         middle: Text('Text Fields'),
  //       ),
  //       child: CupertinoScrollbar(
  //         child: ListView(
  //           children: <Widget>[
  //             Padding(
  //               padding: EdgeInsets.symmetric(
  //                   vertical: 32.0, horizontal: 16.0),
  //               child: Column(
  //                 children: <Widget>[
  //                   CupertinoTextField(
  //                     prefix: Icon(
  //                       CupertinoIcons.person_solid,
  //                       color: CupertinoColors.lightBackgroundGray,
  //                       size: 28.0,
  //                     ),
  //                     padding:
  //                         EdgeInsets.symmetric(horizontal: 6.0, vertical: 12.0),
  //                     clearButtonMode: OverlayVisibilityMode.editing,
  //                     textCapitalization: TextCapitalization.words,
  //                     autocorrect: false,
  //                     decoration: BoxDecoration(
  //                       border: Border(
  //                           bottom: BorderSide(
  //                               width: 0.0,
  //                               color: CupertinoColors.inactiveGray)),
  //                     ),
  //                     placeholder: 'Name',
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             // Padding(
  //             //   padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
  //             //   child: _buildChatTextField(),
  //             // ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

  Widget _buildNameField() {
    return CupertinoTextField(
      controller: _controladorNome,
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
      placeholder: 'Name',
    );
  }

  Widget _buildCodeField() {
    return CupertinoTextField(
      controller: _controladorCodigo,
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
      placeholder: 'Code',
    );
  }

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
                      child: _buildNameField(),
                    );
                  case 1:
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _buildCodeField(),
                    );
                  default:
                  // Do nothing. For now.
                }
                return null;
              },
            )),
          )
        ],
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text('New Item'),
  //     ),
  //     body: SingleChildScrollView(
  //       child: Column(
  //         children: <Widget>[
  //           Editor(
  //             controller: _controladorNome,
  //             rotulo: 'Nome',
  //           ),
  //           Editor(
  //             controller: _controladorCodigo,
  //             rotulo: 'Código',
  //           ),
  //           Padding(
  //             padding: const EdgeInsets.all(16.0),
  //             child: RaisedButton(
  //               onPressed: () => _saveConfig(context),
  //               child: Text('Save'),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Future _saveConfig(BuildContext context) async {
    final String nome = _controladorNome.text;
    final String codigo = _controladorCodigo.text;

    final itemSmart = Item(nome, codigo, false);

    Navigator.pop(context, itemSmart);
  }
}
