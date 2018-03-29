import 'package:flutter/material.dart';
import 'package:untitled/common/dialog.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'My Todo App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var addListController = new TextEditingController();

  List<String> textLists = [];
  List<bool> textCheckBoxes = [];

  _onClickShowDialog() {
    Dialog dialog = new MyDialog(
        child: new Center(
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
                            context, {'value': addListController.text});
                      }, child: new Text('add')),
                  new FlatButton(
                      onPressed: () {
                        Navigator.pop(context);
                      }, child: new Text('delete')),
                ],
              )
            ],
          ),
        )
    );

    showDialog(context: context, child: dialog)
        .then((onValue) {
      if (onValue == null) {
        return;
      }

      textLists.add(onValue['value']);
      textCheckBoxes.add(false);
      addListController.clear();
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    deleteRows() {
      for (var i = 0; i < textLists.length; i++) {
        if (textCheckBoxes[i]) {
          textCheckBoxes.removeAt(i);
          textLists.removeAt(i);
        }
      }
      setState(() {});
    }

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
        actions: <Widget>[
          new IconButton(
              icon: new Icon(Icons.add),
              onPressed: _onClickShowDialog),
          new IconButton(
              icon: new Icon(Icons.remove),
              onPressed: deleteRows),
        ],
      ),
        body: new Column(
          children: <Widget>[
            new Flexible(
                child: new ListView.builder(
                    itemCount: textLists.length,
                    itemBuilder: (context, index) {
                      return new Row(
                        children: <Widget>[
                          new Checkbox(
                              value: textCheckBoxes[index],
                              onChanged: (bool newValue) {
                                textCheckBoxes[index] = newValue;
                                setState(() {});
                              }),
                          new Text(textLists[index]),
                        ],
                      );
                    })
            ),
          ],
        )
    );
  }
}
