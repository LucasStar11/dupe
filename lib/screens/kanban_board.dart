import 'package:flutter/material.dart';
import 'package:dupe/models/task_list.dart';
import 'package:drag_and_drop_lists/drag_and_drop_item.dart';
import 'package:drag_and_drop_lists/drag_and_drop_list.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import '../database_halper.dart';
import '../models/board.dart';

class KanbanBoard extends StatefulWidget {
  const KanbanBoard ({Key? key}) : super(key: key);

  @override
  _KanbanBoard createState() => _KanbanBoard();
}

class _KanbanBoard extends State<KanbanBoard> {

  late List<TaskList> listData = [
    TaskList(title: "To do"),
    TaskList(title: "Doing"),
    TaskList(title: "Done")
  ];

  @override
  Widget build(BuildContext context) {




    return Container();
  }
}
