class Task {
  final int? id;
  final int? boardId;
  String? title;
  String? description;
  Task({this.id,this.boardId, this.title, this.description}){
    title ??= "no title";
    description ??= "no description";
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'deskId': boardId,
      'title': title,
      'description': description,
    };
  }
}
