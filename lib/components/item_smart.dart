import 'package:flutter/material.dart';
import 'package:natal_smart/models/item_smart.dart';

class ItemSmart extends StatelessWidget {
  final Item item;
  final int index;
  final ValueChanged<int> deleted;
  final void Function(String codigo, String value) onChange;
  final bool status;

  const ItemSmart({Key key, this.item, this.index, this.deleted, this.onChange, this.status})
      : super(key: key);

    @override
  Widget build(BuildContext context) {
    return Dismissible(
      onDismissed: (direction) {
        deleted(index);
      },
      direction: DismissDirection.endToStart,
      key: Key(item.nome),
      background: Container(
        alignment: AlignmentDirectional.centerEnd,
        child: Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
        color: Colors.red,
      ),
      child: Card(
        child: Row(
          children: <Widget>[
            Expanded(
              child: ListTile(
                leading: status
                    ? Image.asset('assets/images/light_on.png')
                    : Image.asset('assets/images/light_off.png'),
                title: Text(item.nome),
                subtitle: Text(item.codigo),
              ),
            ),
            FlatButton(
              child: status
                  ? Icon(
                      Icons.highlight_off,
                      color: Colors.white,
                    )
                  : Icon(
                      Icons.highlight,
                      color: Colors.white,
                    ),
              color: status ? Colors.red : Color.fromRGBO(68, 153, 213, 1.0),
              shape: CircleBorder(),
              onPressed: () {
                if(status) {
                  onChange(item.codigo, item.valueOff);
                } else {
                  onChange(item.codigo, item.valueOn);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
