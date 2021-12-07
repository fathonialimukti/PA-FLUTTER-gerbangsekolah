class Assignment {
  int id;
  int gradeId;
  int teacherId;
  String title;
  String? description;

  Assignment({
    required this.id,
    required this.gradeId,
    required this.teacherId,
    required this.title,
    this.description,
  });

  Assignment.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        gradeId = json['grade_id'],
        teacherId = json['teacher_id'],
        title = json['title'],
        description = json['description'];
}
