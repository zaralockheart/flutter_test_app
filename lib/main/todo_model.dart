import 'package:firebase_database/firebase_database.dart';

class TodoModel {
  String key;
  String dateTime;
  String todo;
  bool checked;

  TodoModel(this.dateTime, this.todo, this.checked);

  TodoModel.fromSnapshot(DataSnapshot snapshot)
      : key = snapshot.key,
        dateTime = snapshot.value["date"],
        checked = snapshot.value["checked"],
        todo = snapshot.value["todo"];

  toJson() {
    return {
      "date": dateTime,
      "todo": todo,
      "checked": checked
    };
  }
}