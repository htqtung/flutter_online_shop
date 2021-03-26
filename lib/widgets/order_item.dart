import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/orders.dart' as OrderProvider;

class OrderItem extends StatefulWidget {
  final OrderProvider.OrderItem order;

  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem>
    with SingleTickerProviderStateMixin {
  var _expanded = false;

  Widget itemRowBuilder(title, description) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          description,
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height:
          _expanded ? min(widget.order.products.length * 24.0 + 100, 200) : 100,
      child: Card(
        margin: EdgeInsets.all(8),
        elevation: 5,
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text(
                'Order ${widget.order.id}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                DateFormat('dd-MM-yyyy hh:mm').format(widget.order.dateTime),
              ),
              trailing: IconButton(
                icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              height: _expanded
                  ? min(widget.order.products.length * 24.0 + 10, 200)
                  : 0,
              child: ListView(
                children: widget.order.products
                    .map(
                      (item) => itemRowBuilder(
                          item.title, '${item.quantity}x \$${item.price}'),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
