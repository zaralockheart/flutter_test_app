import 'package:flutter/material.dart';
import 'package:untitled/common/dialog.dart';
import 'package:untitled/main/add_list_dialog_content.dart';

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
        child: new AddListDialogContent(
            addListController: addListController
        )
    );

    showDialog(context: context, builder: (context) =>dialog)
        .then((onValue) {
      if ((onValue as String).length <= 0) {
        return;
      }

      print(onValue);
      textLists.add(onValue);
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
