import 'package:flutter/material.dart';
import '../database_halper.dart';
import '../models/board.dart';

class KanbanPage extends StatefulWidget {
  late final Board? board;

  KanbanPage({required this.board});

  @override
  _KanbanPage createState() => _KanbanPage();
}

class _KanbanPage extends State<KanbanPage> {

  int _boardId = 0;
  String _boardTitle = "";
  String _boardDescription = "";

  late FocusNode _titleFocus;
  late FocusNode _descriptionFocus;

  bool _contentVisile = false;

  @override
  void initState() {
    if (widget.board != null) {
      // Set visibility to true
      _contentVisile = true;

      _boardTitle = widget.board?.title ?? "danunahui";
      _boardDescription = widget.board?.description ?? "danunahui";
      _boardId = widget.board?.id ?? -1;
    }

    _titleFocus = FocusNode();
    _descriptionFocus = FocusNode();

    super.initState();
  }

  @override
  void dispose() {
    _titleFocus.dispose();
    _descriptionFocus.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 24.0,
                      bottom: 6.0,
                    ),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(24.0),
                            child: Image(
                              image: AssetImage(
                                  'assets/images/back_arrow_icon.png'),
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            focusNode: _titleFocus,
                            onSubmitted: (value) async {
                              // Check if the field is not empty
                              if (value != "") {
                                // Check if the board is null
                                if (widget.board == null) {
                                  Board _newBoard = Board(
                                      title: value,
                                      id: _boardId,
                                      description: _boardDescription);
                                  _boardId =
                                      await DatabaseHelper.instance.insertBoard(_newBoard);
                                  setState(() {
                                    _contentVisile = true;
                                    _boardTitle = value;
                                  });
                                } else {
                                  await DatabaseHelper.instance.updateBoardTitle(
                                      _boardId, value);
                                  /// для дебага удалить
                                  print("Board Updated");
                                }
                                _descriptionFocus.requestFocus();
                              }
                            },
                            controller: TextEditingController()
                              ..text = _boardTitle,
                            decoration: const InputDecoration(
                              hintText: "Enter Board Title",
                              border: InputBorder.none,
                            ),
                            style: const TextStyle(
                              fontSize: 26.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF211551),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Visibility(
                    visible: _contentVisile,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        bottom: 12.0,
                      ),
                      child: TextField(
                        focusNode: _descriptionFocus,
                        onSubmitted: (value) async {
                          if (value != "") {
                            if (_boardId != 0) {
                              await DatabaseHelper.instance.updateBoardDescription(
                                  _boardId, value);
                              _boardDescription = value;
                            }
                          }
                        },
                        controller: TextEditingController()
                          ..text = _boardDescription,
                        decoration: const InputDecoration(
                          hintText: "Enter Description for the board...",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 24.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Visibility(
                visible: _contentVisile,
                child: Positioned(
                  bottom: 24.0,
                  right: 24.0,
                  child: GestureDetector(
                    onTap: () async {
                      if (_boardId != 0) {
                        await DatabaseHelper.instance.deleteBoard(_boardId);
                        Navigator.pop(context);
                      }
                    },
                    child: Container(
                      width: 60.0,
                      height: 60.0,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFE3577),
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      child: const Image(
                        image: AssetImage(
                          "assets/images/delete_icon.png",
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
