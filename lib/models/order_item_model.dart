import 'package:stitch/models/product_color_model.dart';

class OrderItem{
  final String productId;
  final int quantity;
  final String size;
  final ProductColor color;

  OrderItem({
    required this.productId,
    required this.quantity,
    required this.size,
    required this.color
  });

  static OrderItem fromMap(Map<String, dynamic> data){
    return OrderItem(
      productId: data['productId'],
      quantity: data['quantity'],
      size: data['size'],
      color: ProductColor.fromMap(data['color'])
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'productId': productId,
      'quantity': quantity,
      'size': size,
      'color': color.toMap()
    };
  }
}