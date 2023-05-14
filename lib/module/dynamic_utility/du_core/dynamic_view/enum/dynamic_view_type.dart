/// Created by Shakil Ahmed Shaj [shakilahmedshaj@gmail.com] on 08,March,2023.
enum DynamicViewType {
  text('text'),
  dropDown('dropdown'),
  notificationWidget('notification_widget'),
  barCode('barcode'),
  none('none');

  final String name;

  const DynamicViewType(this.name);

  String get type => name;

  factory DynamicViewType.toType(String elementType) {
    for (var value in DynamicViewType.values) {
      if (value.type == elementType) return value;
    }
    throw 'Unknown Dynamic Element --> $elementType';
  }
}
