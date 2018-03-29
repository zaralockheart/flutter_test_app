import 'package:flutter/material.dart';
import 'package:meta/meta.dart';


class AddListDialogContent extends StatelessWidget {

  const AddListDialogContent({
    Key key,
    @required this.addListController,
  }) : super(key: key);


  final TextEditingController addListController;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Center(
      child: new Column(
        children: <Widget>[
          new Text('Add List'),
          new TextField(
            controller: addListController,
            decoration: new InputDecoration.collapsed(
                hintText: 'Add what you want here fam'),
            maxLines: 3,
            onSubmitted: (String text) {
              Navigator.pop(context, {'value': text});
            },
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              new FlatButton(
                  onPressed: () {
                    Navigator.pop(
                        context, addListController.text);
                  }, child: new Text('add')),
              new FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  }, child: new Text('delete')),
            ],
          )
        ],
      ),
    );
  }

}