class Grade {
  int id;
  String className;
  String? classDescription;
  String? virtualClassroom;

  Grade({
    required this.id, 
    required this.className,
    this.classDescription,
    this.virtualClassroom,
    });

  Grade.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        className = json['class_name'],
        classDescription = json['class_description'],
        virtualClassroom = json['virtual_classroom'];

  
}
