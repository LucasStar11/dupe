import 'package:dupe/models/task.dart';

class TaskList {
  String? title;
  List<Task>? items;

  TaskList({this.title, this.items}) {
    title ??= "";
    items ??= [];
  }
}