import 'dart:ui';

class ProductColor{
  final String name;
  final Color color;

  ProductColor({
    required this.name,
    required this.color,
  });

  static ProductColor fromMap(Map<String, dynamic> data){
    return ProductColor(
        name: data['name'],
        color: Color(data['value'])
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'name': name,
      'value': color.value
    };
  }
}