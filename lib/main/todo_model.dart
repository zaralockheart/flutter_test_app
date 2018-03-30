class TodoModel {
  String dateTime;
  String todo;

  TodoModel(this.dateTime, this.todo);

  toJson() {
    return {
      "date": dateTime,
      "todo": todo
    };
  }
}