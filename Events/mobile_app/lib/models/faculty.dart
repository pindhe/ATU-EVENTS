class Faculty {
  final String id;
  final String name;

  Faculty({required this.id, required this.name});

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
  factory Faculty.fromJson(Map<String, dynamic> json) => Faculty(id: json['id'], name: json['name']);
}
