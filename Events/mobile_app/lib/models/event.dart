enum EventVisibility { public, local, private }

class Event {
  final String id;
  final String title;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  final String location;
  final String? imageUrl;
  final String? externalLink;
  final String? categoryName;
  final String? createdByUsername;
  final bool isPublished;
  final EventVisibility visibility;
  final String? assignedClassId;
  final int? maxParticipants;
  final int currentParticipants;
  final double? price;
  final int likeCount;
  final bool isLiked;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.location,
    this.imageUrl,
    this.externalLink,
    this.categoryName,
    this.createdByUsername,
    required this.isPublished,
    this.visibility = EventVisibility.public,
    this.assignedClassId,
    this.maxParticipants,
    this.currentParticipants = 0,
    this.price,
    this.likeCount = 0,
    this.isLiked = false,
  });


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
      'location': location,
      'event_image_url': imageUrl,
      'external_link': externalLink,
      'category_name': categoryName,
      'created_by_username': createdByUsername,
      'is_published': isPublished,
      'visibility': visibility.toString().split('.').last,
      'assigned_class_id': assignedClassId,
      'max_participants': maxParticipants,
      'current_participants': currentParticipants,
      'price': price,
      'like_count': likeCount,
      'is_liked': isLiked,
    };
  }

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'].toString(),
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      startTime: DateTime.parse(json['start_time']),
      endTime: DateTime.parse(json['end_time']),
      location: json['location'] ?? '',
      imageUrl: json['event_image_url'],
      externalLink: json['external_link'],
      categoryName: json['category_name'],
      createdByUsername: json['created_by_username'],
      isPublished: json['is_published'] ?? false,
      visibility: json['visibility'] == 'local' 
          ? EventVisibility.local 
          : (json['visibility'] == 'private' ? EventVisibility.private : EventVisibility.public),
      assignedClassId: json['assigned_class_id']?.toString(),
      maxParticipants: json['max_participants'],
      currentParticipants: json['current_participants'] ?? 0,
      price: json['price']?.toDouble(),
      likeCount: json['like_count'] ?? 0,
      isLiked: json['is_liked'] ?? false,
    );
  }
}

