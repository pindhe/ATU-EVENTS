class SchoolClass {
  final String id;
  final String name;
  final String facultyId;
  final String teacherId;
  final List<String> studentIds;

  SchoolClass({
    required this.id,
    required this.name,
    required this.facultyId,
    required this.teacherId,
    required this.studentIds,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'facultyId': facultyId,
    'teacherId': teacherId,
    'studentIds': studentIds,
  };

  factory SchoolClass.fromJson(Map<String, dynamic> json) => SchoolClass(
    id: json['id'],
    name: json['name'],
    facultyId: json['facultyId'],
    teacherId: json['teacherId'],
    studentIds: List<String>.from(json['studentIds']),
  );
}
