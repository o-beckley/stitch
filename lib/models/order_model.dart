import 'package:stitch/models/delivery_details_model.dart';
import 'package:stitch/models/order_item_model.dart';

enum OrderStatus {placed, confirmed, shipped, delivered, cancelled, returned}

class StitchOrder{
  final String id;
  final String sellerId;
  final String receiverId;
  final DeliveryDetails deliveryDetails;
  final Map<OrderStatus, DateTime> status;
  final List<OrderItem> items;

  StitchOrder({
    required this.id,
    required this.sellerId,
    required this.receiverId,
    required this.deliveryDetails,
    required this.status,
    required this.items,
  });

  static OrderStatus _getOrderStatus(String name){
   return switch (name){
      'placed' => OrderStatus.placed,
      'confirmed' => OrderStatus.confirmed,
      'shipped' => OrderStatus.shipped,
      'delivered' => OrderStatus.delivered,
      'cancelled' => OrderStatus.cancelled,
      'returned' => OrderStatus.returned,
      _ => OrderStatus.placed
    };
  }

  static StitchOrder fromMap(Map<String, dynamic> data){
    return StitchOrder(
      id: data['id'],
      sellerId: data['sellerId'],
      receiverId: data['receiverId'],
      deliveryDetails: DeliveryDetails.fromMap(data['deliveryDetails']),
      status: (data['status'] as Map).map((k, v) => MapEntry(_getOrderStatus(k), DateTime.parse(v))),
      items: (data['items'] as List).cast<Map<String, dynamic>>().map((e) => OrderItem.fromMap(e)).toList()
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'id': id,
      'sellerId': sellerId,
      'receiverId': receiverId,
      'deliveryDetails': deliveryDetails.toMap(),
      'status': status.map((k, v) => MapEntry(k.name, v.toIso8601String())),
      'items': items.map((e) => e.toMap()).toList()
    };
  }
}