import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:gerenciamento_loja/views/home_screen/tabs/cliente_tab/tile/user_tile.dart';

import 'package:gerenciamento_loja/controllers/user_controller/user_controller.dart';

class ClientTab extends StatelessWidget {
  final Function onSignOut;

  ClientTab({this.onSignOut});
  @override
  Widget build(BuildContext context) {
    final userController = BlocProvider.of<UserController>(context);
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 8),
          child: ListTile(
            title: TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                  hintText: 'Pesquisar',
                  hintStyle: TextStyle(color: Colors.white),
                  icon: Icon(Icons.search, color: Colors.white),
                  border: InputBorder.none),
              onChanged: userController.onChangedShearch,
            ),
            trailing: IconButton(
              icon: Icon(
                Icons.exit_to_app,
                color: Colors.deepOrangeAccent,
              ),
              onPressed: onSignOut,
            ),
          ),
        ),
        Expanded(
          child: StreamBuilder<List>(
              stream: userController.outUsers,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          AlwaysStoppedAnimation(Colors.deepOrangeAccent),
                    ),
                  );
                } else if (snapshot.data.length == 0) {
                  return Center(
                    child: Text(
                      "Nenhum Usuario encontrado!",
                      style: TextStyle(color: Colors.deepOrangeAccent),
                    ),
                  );
                }

                return ListView.separated(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return UserTile(snapshot.data[index]);
                  },
                  separatorBuilder: (context, index) {
                    return Divider(
                      color: Colors.white,
                    );
                  },
                );
              }),
        )
      ],
    );
  }
}
