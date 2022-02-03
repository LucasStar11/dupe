class Board {
  final int? id;
  String? title;
  String? description;
  Board({this.id, this.title, this.description}){
    title ??= "no title";
    description ??= "no description";
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
    };
  }
}