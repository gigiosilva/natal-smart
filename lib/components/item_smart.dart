import 'package:flutter/material.dart';
import 'package:natal_smart/models/item_smart.dart';

class ItemSmart extends StatefulWidget {
  final Item item;
  final int index;
  final ValueChanged<int> deleted;
  final void Function(String codigo, String value) onChange;
  final bool status;

  const ItemSmart({Key key, this.item, this.index, this.deleted, this.onChange, this.status})
      : super(key: key);

  @override
  _ItemSmartState createState() => _ItemSmartState();
}

class _ItemSmartState extends State<ItemSmart> {
  

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      onDismissed: (direction) {
        widget.deleted(widget.index);
      },
      direction: DismissDirection.endToStart,
      key: Key(widget.item.nome),
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
                leading: widget.status
                    ? Image.asset('assets/images/light_on.png')
                    : Image.asset('assets/images/light_off.png'),
                title: Text(widget.item.nome),
                subtitle: Text(widget.item.codigo),
              ),
            ),
            FlatButton(
              child: widget.status
                  ? Icon(
                      Icons.highlight_off,
                      color: Colors.white,
                    )
                  : Icon(
                      Icons.highlight,
                      color: Colors.white,
                    ),
              color: widget.status ? Colors.red : Color.fromRGBO(68, 153, 213, 1.0),
              shape: CircleBorder(),
              onPressed: () {
                if(widget.status) {
                  // setState(() => status = false);
                  widget.onChange(widget.item.codigo, '-1');
                } else {
                  // setState(() => status = true);
                  widget.onChange(widget.item.codigo, '1');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
