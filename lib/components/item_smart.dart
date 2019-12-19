import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:natal_smart/models/item_smart.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class ItemSmart extends StatefulWidget {
  final Item item;
  final int index;
  final ValueChanged<int> deleted;
  final void Function(String codigo, String value) onChange;
  final bool status;

  const ItemSmart(
      {Key key,
      this.item,
      this.index,
      this.deleted,
      this.onChange,
      this.status})
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
    final row = SafeArea(
      top: false,
      bottom: false,
      minimum: const EdgeInsets.only(
        left: 20,
        top: 8,
        bottom: 8,
        right: 8,
      ),
      child: Row(
        children: <Widget>[
          widget.status
              ? Image.asset('assets/images/light_on.png', width: 50, height: 50)
              : Image.asset('assets/images/light_off.png', width: 50, height: 50),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.item.nome,
                    style: TextStyle(
                      fontSize: 18,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  const Padding(padding: EdgeInsets.only(top: 8)),
                  Text(
                    widget.item.codigo,
                    style: TextStyle(
                      color: CupertinoColors.inactiveGray,
                      fontSize: 13,
                      fontWeight: FontWeight.w300,
                    ),
                  )
                ],
              ),
            ),
          ),
          CupertinoButton(
            padding: EdgeInsets.only(right: 20),
            onPressed: () {
              if (widget.status) {
                widget.onChange(widget.item.codigo, widget.item.valueOff);
              } else {
                widget.onChange(widget.item.codigo, widget.item.valueOn);
              }
            },
            child: widget.status
              ? Icon(
                  CupertinoIcons.clear_circled_solid,
                  color: CupertinoColors.systemRed,
                )
              : Icon(
                  CupertinoIcons.check_mark_circled,
                ),
          ),
        ],
      ),
    );

    final col = Column(
      children: <Widget>[
        row,
        Padding(
          padding: const EdgeInsets.only(
            left: 10,
            right: 10,
          ),
          child: Divider(
            height: 0,
            color: CupertinoColors.inactiveGray,
          ),
        ),
      ],
    );

  return Slidable(
    actionPane: SlidableDrawerActionPane(),
    actionExtentRatio: 0.25,
    child: col,
    secondaryActions: <Widget>[
      IconSlideAction(
        caption: 'Delete',
        color: CupertinoColors.systemRed,
        icon: CupertinoIcons.delete,
        onTap: () => widget.deleted(widget.index),
      ),
    ],
  );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Dismissible(
  //     onDismissed: (direction) {
  //       widget.deleted(widget.index);
  //     },
  //     direction: DismissDirection.endToStart,
  //     key: Key(widget.item.nome),
  //     background: Container(
  //       alignment: AlignmentDirectional.centerEnd,
  //       child: Padding(
  //         padding: const EdgeInsets.only(right: 16.0),
  //         child: Icon(
  //           Icons.delete,
  //           color: Colors.white,
  //         ),
  //       ),
  //       color: Colors.red,
  //     ),
  //     child: Card(
  //       child: Row(
  //         children: <Widget>[
  //           Expanded(
  //             child: ListTile(
  //               leading: widget.status
  //                   ? Image.asset('assets/images/light_on.png')
  //                   : Image.asset('assets/images/light_off.png'),
  //               title: Text(widget.item.nome),
  //               subtitle: Text(widget.item.codigo),
  //             ),
  //           ),
  //           FlatButton(
  //             child: widget.status
  //                 ? Icon(
  //                     Icons.highlight_off,
  //                     color: Colors.white,
  //                   )
  //                 : Icon(
  //                     Icons.highlight,
  //                     color: Colors.white,
  //                   ),
  //             color: widget.status ? Colors.red : Color.fromRGBO(68, 153, 213, 1.0),
  //             shape: CircleBorder(),
  //             onPressed: () {
  //               if(widget.status) {
  //                 // setState(() => status = false);
  //                 widget.onChange(widget.item.codigo, widget.item.valueOff);
  //               } else {
  //                 // setState(() => status = true);
  //                 widget.onChange(widget.item.codigo, widget.item.valueOn);
  //               }
  //             },
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }
}
