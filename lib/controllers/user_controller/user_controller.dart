import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class UserController extends BlocBase {
  final _usersController = BehaviorSubject<List>();

  Stream<List> get outUsers => _usersController.stream;

  Map<String, Map<String, dynamic>> _users = {};

  Firestore _firestore = Firestore.instance;

  UserController() {
    _addUserListener();
  }

  void onChangedShearch(String value) {
    if (value.trim().isEmpty) {
      _usersController.add(_users.values.toList());
    } else {
      _usersController.add(_filter(value.trim()));
    }
  }

  List<Map<String, dynamic>> _filter(String value) {
    List<Map<String, dynamic>> filteredUser = List.from(_users.values.toList());
    filteredUser.retainWhere((user) {
      return user['name'].toUpperCase().contains(value.toUpperCase());
    });
    return filteredUser;
  }

  void _addUserListener() {
    _firestore.collection('users').snapshots().listen((snapshot) {
      snapshot.documentChanges.forEach((change) {
        String uid = change.document.documentID;
        switch (change.type) {
          case DocumentChangeType.added:
            // TODO: Handle this case.
            _users[uid] = change.document.data;
            _subuscribeToOrders(uid);
            break;
          case DocumentChangeType.modified:
            // TODO: Handle this case.
            _users[uid].addAll(change.document.data);
            _usersController.add(_users.values.toList());
            break;
          case DocumentChangeType.removed:
            // TODO: Handle this case.
            _users.remove(uid);
            _unSubcribeOrders(uid);
            _usersController.add(_users.values.toList());
            break;
        }
      });
    });
  }

  Future<void> _subuscribeToOrders(String uid) {
    //TODO: para obter os dados apenas uma vez aprenas trocar snapshot por getdocuments
    _users[uid]['subscription'] = _firestore
        .collection('users')
        .document(uid)
        .collection("orders")
        .snapshots()
        .listen(
      (orders) async {
        int numOrders = orders.documents.length;
        double money = 0.0;

        for (DocumentSnapshot item in orders.documents) {
          DocumentSnapshot order = await _firestore
              .collection('orders')
              .document(item.documentID)
              .get();
          if (order.data == null) continue;
          money += order.data['totalPrice'];
        }
        _users[uid].addAll({'money': money, 'orders': numOrders});
        _usersController.add(_users.values.toList());
      },
    );
  }

  Map<String, dynamic> getUser(String uid) {
    return _users[uid];
  }

  void _unSubcribeOrders(String uid) {
    _users[uid]['subscription'].cancel();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _usersController.close();
  }
}
