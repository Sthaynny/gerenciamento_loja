import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerenciamento_loja/controllers/user_controller/user_controller.dart';

class OrderHearder extends StatelessWidget {
  final DocumentSnapshot order;

  const OrderHearder(this.order);
  @override
  Widget build(BuildContext context) {
    final _userBloc = BlocProvider.of<UserController>(context);
    final _user = _userBloc.getUser(order.data['clientId']);
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text("${_user['name']}"),
              Text(
                '${_user['address']}',
                style: TextStyle(fontWeight: FontWeight.w300),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(
              "Produto(s): R\$${order.data["productsPrice"].toStringAsFixed(2)}",
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            Text(
              'Total: R\$${order.data['totalPrice'].toStringAsFixed(2)}',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ],
    );
  }
}
