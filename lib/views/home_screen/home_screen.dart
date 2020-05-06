import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:gerenciamento_loja/controllers/home/home_controller.dart';
import 'package:gerenciamento_loja/controllers/orders/oders_controller.dart';
import 'package:gerenciamento_loja/views/home_screen/tabs/cliente_tab/cliente_tab.dart';
import 'package:gerenciamento_loja/controllers/user_controller/user_controller.dart';
import 'package:gerenciamento_loja/views/home_screen/tabs/orders_tab/orders_tab.dart';
import 'package:gerenciamento_loja/views/home_screen/tabs/products/products_tab.dart';
import 'package:gerenciamento_loja/views/home_screen/tabs/products/tiles/edite_category/edit_category_dialog.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _page = 0;
  PageController _pageController;

  UserController _userController;
  OrdersBloc _ordersBloc;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = PageController();
    _userController = UserController();
    _ordersBloc = OrdersBloc();
  }

  @override
  Widget build(BuildContext context) {
    HomeController _controller = HomeController();
    return Scaffold(
      backgroundColor: Colors.grey[850],
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.deepOrangeAccent,
          primaryColor: Colors.white,
          textTheme: Theme.of(context)
              .textTheme
              .copyWith(caption: TextStyle(color: Colors.white38)),
        ),
        child: BottomNavigationBar(
          currentIndex: _page,
          onTap: (p) {
            _pageController.animateToPage(
              p,
              duration: Duration(microseconds: 500),
              curve: Curves.easeInCirc,
            );
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
              ),
              title: Text('Cliente'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              title: Text('Pedidos'),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.list,
              ),
              title: Text('Produtos'),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: BlocProvider<UserController>(
          bloc: _userController,
          child: BlocProvider<OrdersBloc>(
            bloc: _ordersBloc,
            child: PageView(
              onPageChanged: (p) {
                setState(() {
                  _page = p;
                });
              },
              controller: _pageController,
              children: <Widget>[
                ClientTab(onSignOut: () {
                  _controller.signOut(context);
                }),
                OrdersTab(),
                ProductsTab(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: _buildFloating(),
    );
  }

  Widget _buildFloating() {
    switch (_page) {
      case 0:
        return null;
        break;
      case 1:

        //TODO: Speed dial
        return SpeedDial(
          child: Icon(Icons.sort),
          backgroundColor: Colors.deepOrangeAccent,
          overlayOpacity: 0.4,
          overlayColor: Colors.black,
          children: [
            SpeedDialChild(
              child: Icon(
                Icons.arrow_downward,
                color: Colors.deepOrangeAccent,
              ),
              label: "Concluidos Abaixo",
              labelStyle: TextStyle(fontSize: 14),
              onTap: () {
                _ordersBloc.setOrderCriteria(SortCriteria.READY_LAST);
              },
              backgroundColor: Colors.white,
            ),
            SpeedDialChild(
              child: Icon(
                Icons.arrow_upward,
                color: Colors.deepOrangeAccent,
              ),
              label: "Concluidos Acima",
              labelStyle: TextStyle(fontSize: 14),
              onTap: () {
                _ordersBloc.setOrderCriteria(SortCriteria.READY_FIRST);
              },
              backgroundColor: Colors.white,
            ),
          ],
        );
        break;
      case 2:
        return FloatingActionButton(
          child: Icon(Icons.add),
          backgroundColor: Colors.deepOrangeAccent,
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => EditCategoryDialog(),
            );
          },
        );
        break;
    }
  }
}
