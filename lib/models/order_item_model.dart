import 'package:stitch/models/product_color_model.dart';

class OrderItem{
  final String productId;
  final String sellerId;
  final int quantity;
  final String size;
  final ProductColor color;

  OrderItem({
    required this.productId,
    required this.sellerId,
    required this.quantity,
    required this.size,
    required this.color
  });

  static OrderItem fromMap(Map<String, dynamic> data){
    return OrderItem(
      productId: data['productId'],
      sellerId: data['sellerId'],
      quantity: data['quantity'],
      size: data['size'],
      color: ProductColor.fromMap(data['color'])
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'productId': productId,
      'sellerId': sellerId,
      'quantity': quantity,
      'size': size,
      'color': color.toMap()
    };
  }
}