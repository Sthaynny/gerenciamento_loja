import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:gerenciamento_loja/controllers/orders/oders_controller.dart';
import 'package:gerenciamento_loja/views/home_screen/tabs/orders_tab/tile/orders_tile.dart';

class OrdersTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _ordersBloc = BlocProvider.of<OrdersBloc>(context);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: StreamBuilder<List>(
          stream: _ordersBloc.outOrders,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(Colors.deepOrangeAccent),
                ),
              );
            } else if (snapshot.data.length == 0) {
              return Center(
                child: Text(
                  "Nenhum pedido encontrado!",
                  style: TextStyle(color: Colors.deepOrangeAccent),
                ),
              );
            }
            return ListView.builder(
              itemBuilder: (context, index) {
                return OrderTile(snapshot.data[index]);
              },
              itemCount: snapshot.data.length,
            );
          }),
    );
  }
}
