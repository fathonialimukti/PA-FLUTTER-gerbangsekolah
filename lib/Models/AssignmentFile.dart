class AssignmentFile {
  int id;
  int assignmentId;
  int? score;
  String studentName;
  String? note;
  String? file;

  AssignmentFile({
    required this.id,
    required this.assignmentId,
    required this.studentName,
    this.score,
    this.note,
    this.file,
  });

  AssignmentFile.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        assignmentId = json['assignment_id'],
        studentName = json['student_name'],
        score = json['score'],
        note = json['note'],
        file = json['file'];
}
