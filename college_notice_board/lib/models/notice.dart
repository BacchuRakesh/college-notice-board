class Notice {
  const Notice({
    required this.id,
    required this.title,
    required this.description,
    required this.department,
    required this.date,
    required this.postedBy,
    this.pinned = false,
  });

  final String id;
  final String title;
  final String description;
  final String department;
  final DateTime date;
  final String postedBy;
  final bool pinned;

  Notice copyWith({bool? pinned}) {
    return Notice(
      id: id,
      title: title,
      description: description,
      department: department,
      date: date,
      postedBy: postedBy,
      pinned: pinned ?? this.pinned,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'department': department,
      'date': date.toIso8601String(),
      'postedBy': postedBy,
      'pinned': pinned,
    };
  }

  factory Notice.fromJson(Map<String, dynamic> json) {
    return Notice(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      department: json['department'] as String,
      date: DateTime.parse(json['date'] as String),
      postedBy: json['postedBy'] as String,
      pinned: json['pinned'] as bool? ?? false,
    );
  }

  String get formattedDate => formatDate(date);

  static const List<String> _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  static String formatDate(DateTime date) {
    return '${date.day} ${_months[date.month - 1]} ${date.year}';
  }
}
