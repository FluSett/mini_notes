class Note {
  final int? id;
  final String title;
  final String message;
  final String date;
  final String color;

  Note(
      {this.id,
      required this.title,
      required this.message,
      required this.date,
      required this.color});

  Note.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        title = res['title'],
        message = res['message'],
        date = res['date'],
        color = res['color'];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'title': title,
      'message': message,
      'date': date,
      'color': color
    };
  }
}
