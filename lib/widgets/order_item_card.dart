import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:stitch/models/order_item_model.dart';
import 'package:stitch/network_services/product_provider_service.dart';
import 'package:stitch/theme/color_theme.dart';
import 'package:stitch/widgets/custom_network_image.dart';
import 'package:stitch/widgets/placeholders.dart';

class OrderItemCard extends StatefulWidget {
  final OrderItem item;

  const OrderItemCard({
    required this.item,
    super.key
  });

  @override
  State<OrderItemCard> createState() => _OrderItemCardState();
}

class _OrderItemCardState extends State<OrderItemCard> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: context.read<ProductProviderService>().getProduct(widget.item.productId),
      builder: (context, snapshot) {
       if(snapshot.data != null){
         return SizedBox(
           height: 0.2.sw,
           child: Container(
             decoration: BoxDecoration(
               color: context.watch<UIColors>().surfaceContainer,
               borderRadius: BorderRadius.circular(0.02.sw)
             ),
             child: Padding(
               padding: EdgeInsets.all(0.02.sw),
               child: Row(
                 children: [
                   CustomNetworkImage(
                     imageUrl: snapshot.data!.imageUrls[0],
                     height: 0.18.sw,
                     width: 0.12.sw,
                     radius: 0.02.sw,
                   ),
                   0.04.sw.horizontalSpace,
                   Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     mainAxisAlignment: MainAxisAlignment.spaceAround,
                     children: [
                       Text(
                         snapshot.data!.name,
                         style: Theme.of(context).textTheme.bodyLarge
                       ),
                       Row(
                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                         children: [
                           RichText(
                             text: TextSpan(
                               text: "Size ",
                               style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                 color: context.watch<UIColors>().outline
                               ),
                               children: [
                                 TextSpan(
                                   text: widget.item.size,
                                   style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                     fontWeight: FontWeight.bold
                                   )
                                 )
                               ]
                             ),
                           ),
                          0.03.sw.horizontalSpace,
                           RichText(
                             text: TextSpan(
                               text: "Color ",
                               style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                 color: context.watch<UIColors>().outline
                               ),
                               children: [
                                 TextSpan(
                                   text: widget.item.color.name,
                                   style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                     fontWeight: FontWeight.bold
                                   )
                                 )
                               ]
                             ),
                           ),
                         ],
                       )
                     ],
                   ),
                   const Expanded(child: SizedBox()),
                   Column(
                     mainAxisAlignment: MainAxisAlignment.spaceAround,
                     crossAxisAlignment: CrossAxisAlignment.end,
                     children: [
                       Text(
                         "\$${(snapshot.data!.price * widget.item.quantity).toStringAsFixed(2)}",
                         style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                           fontWeight: FontWeight.bold
                         ),
                       ),
                       RichText(
                         text: TextSpan(
                           text: "Qty ",
                           style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                               color: context.watch<UIColors>().outline
                           ),
                           children: [
                             TextSpan(
                               text: widget.item.quantity.toString(),
                               style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                   fontWeight: FontWeight.bold
                               )
                             )
                           ]
                         ),
                       ),
                     ],
                   )
                 ],
               ),
             ),
           ),
         );
       }
       return const OrderItemLoading();
      }
    );
  }
}

class OrderItemLoading extends StatelessWidget {
  const OrderItemLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 0.2.sw,
      child: Container(
        decoration: BoxDecoration(
            color: context.watch<UIColors>().surfaceContainer,
            borderRadius: BorderRadius.circular(0.02.sw)
        ),
        child: Padding(
          padding: EdgeInsets.all(0.02.sw),
          child: Row(
            children: [
              ImagePlaceholder(
                height: 0.18.sw,
                width: 0.12.sw,
                radius: 0.02.sw,
              ),
              0.04.sw.horizontalSpace,
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextPlaceHolder(height: 12, width: 0.4.sw),
                  TextPlaceHolder(height: 12, width: 0.3.sw),
                ],
              ),
              const Expanded(child: SizedBox()),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextPlaceHolder(height: 12, width: 0.1.sw),
                  TextPlaceHolder(height: 12, width: 0.05.sw),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
