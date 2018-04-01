import 'dart:async';
import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:untitled/common/dialog.dart';
import 'package:untitled/common/utils.dart';
import 'package:untitled/main/add_list_dialog_content.dart';
import 'package:untitled/main/todo_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  DatabaseReference mainReference;

  var addListController = new TextEditingController();

  static final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  List<TodoModel> textCheckBoxes = new List();

  String now = new DateTime.now().toIso8601String();

  _MyHomePageState() {
    initPlatformState();
  }

  Future<Null> initPlatformState() async {
    Map<String, dynamic> deviceData;

    try {
      if (Platform.isAndroid) {
        deviceData = readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      } else if (Platform.isIOS) {
        deviceData = readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
      }
    } on PlatformException {
      deviceData = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }

    if (!mounted) return;

    storeDateAndInitFirebase(deviceData);
  }

  storeDateAndInitFirebase(deviceData) async{
    final SharedPreferences prefs = await _prefs;

    if(deviceData['identifierForVendor'] != '') {
      setState(() {
        prefs.setString('device', deviceData['identifierForVendor']);
      });
    }

    mainReference = FirebaseDatabase.instance.reference().child(prefs.getString('device'));
    mainReference.onChildAdded.listen(_onEntryAdded);
    mainReference.onChildChanged.listen(_onEntryEdited);
    mainReference.onChildRemoved.listen(_onChildRemoved);
  }

  _onEntryEdited(Event event) {
    var oldValue = textCheckBoxes.singleWhere((entry) =>
    entry.key == event.snapshot.key);
    setState(() {
      textCheckBoxes[textCheckBoxes.indexOf(oldValue)] =
      new TodoModel.fromSnapshot(event.snapshot);
    });
  }

  int _indexForKey(String key) {
    assert(key != null);
    for (int index = 0; index < textCheckBoxes.length; index++) {
      if (key == textCheckBoxes[index].key) {
        return index;
      }
    }
    return null;
  }

  _onChildRemoved(Event event) {
    final int index = _indexForKey(event.snapshot.key);
    textCheckBoxes.removeAt(index);

    setState(() {});
  }

  _onEntryAdded(Event event) {
    if (new TodoModel.fromSnapshot(event.snapshot) != null)
      textCheckBoxes.add(new TodoModel.fromSnapshot(event.snapshot));

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

      var mTodo = new TodoModel(now, onValue, false);
      mainReference.push().set(mTodo.toJson());

      addListController.clear();
      setState(() {});
    });
  }

  _pushEdit(TodoModel todoModel, newValue) {
    mainReference.child(todoModel.key).set(newValue.toJson());
    setState(() {});
  }

  deleteRows() {
    for (var i = 0; i < textCheckBoxes.length; i++) {
      if (textCheckBoxes[i].checked) {
        _pushEdit(textCheckBoxes[i], new TodoModel(null, null, null));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  itemCount: textCheckBoxes.length,
                  itemBuilder: (context, index) {
                    return new Row(
                      children: <Widget>[
                        new Checkbox(
                            value: textCheckBoxes[index].checked != null
                                && textCheckBoxes[index].checked,
                            onChanged: (bool newValue) {
                              _pushEdit(
                                  textCheckBoxes[index],
                                  new TodoModel(
                                      textCheckBoxes[index].dateTime,
                                      textCheckBoxes[index].todo,
                                      newValue
                                  )
                              );
                              setState(() {});
                            }),
                        new Text(
                            textCheckBoxes[index].todo != null
                                ? textCheckBoxes[index].todo
                                : ''
                        ),
                      ],
                    );
                  })
          ),
        ],
      ),
    );
  }
}
