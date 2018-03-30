import 'package:flutter/material.dart';
import 'package:untitled/common/dialog.dart';
import 'package:untitled/main/add_list_dialog_content.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:untitled/main/todo_model.dart';

final mainReference = FirebaseDatabase.instance.reference();

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

  _MyHomePageState() {
    mainReference.onChildAdded.listen(_onEntryAdded);
  }

  _onEntryAdded(Event event) {
    textLists.add(event.snapshot.value['todo']);
    textCheckBoxes.add(false);
    setState(() {});
  }

  _onClickShowDialog() {
    Dialog dialog = new MyDialog(
        child: new AddListDialogContent(
            addListController: addListController
        )
    );

    showDialog(context: context, builder: (context) =>dialog)
        .then((onValue) {
      if (onValue == null || (onValue as String).length <= 0) {
        addListController.clear();
        return;
      }

      var now = new DateTime.now().toIso8601String();
      print(now);

      var mTodo = new TodoModel(now, onValue);
      mainReference.push().set(mTodo.toJson());

      print(onValue);
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
