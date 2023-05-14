/// Created by Shakil Ahmed Shaj [shakilahmedshaj@gmail.com] on 03,April,2023.

class EduSummaryDetailsModel {
  String title;
  String description;

//<editor-fold desc="Data Methods">
  EduSummaryDetailsModel({
    required this.title,
    required this.description,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EduSummaryDetailsModel &&
          runtimeType == other.runtimeType &&
          title == other.title &&
          description == other.description);

  @override
  int get hashCode => title.hashCode ^ description.hashCode;

  @override
  String toString() {
    return 'EduSummaryDetailsModel{' +
        ' title: $title,' +
        ' description: $description,' +
        '}';
  }

  EduSummaryDetailsModel copyWith({
    String? title,
    String? description,
  }) {
    return EduSummaryDetailsModel(
      title: title ?? this.title,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': this.title,
      'description': this.description,
    };
  }

  factory EduSummaryDetailsModel.fromMap(Map<String, dynamic> map) {
    return EduSummaryDetailsModel(
      title: map['title'] as String,
      description: map['description'] as String,
    );
  }

//</editor-fold>
}