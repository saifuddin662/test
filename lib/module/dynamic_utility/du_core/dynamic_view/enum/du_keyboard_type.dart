/// Created by Shakil Ahmed Shaj [shakilahmedshaj@gmail.com] on 29,March,2023.

enum DuKeyboardType {
  text('text'),
  numeric('numeric'),
  none('none');

  final String name;

  const DuKeyboardType(this.name);

  String get type => name;

  factory DuKeyboardType.toType(String elementType) {
    for (var value in DuKeyboardType.values) {
      if (value.type == elementType) return value;
    }
    throw 'Unknown DU Keyboard Type --> $elementType';
  }
}