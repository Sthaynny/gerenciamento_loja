import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:rxdart/rxdart.dart';

class ProductBloc extends BlocBase {
  String categoryId;
  DocumentSnapshot product;
  final _dataController = BehaviorSubject<Map>();
  final _loadingController = BehaviorSubject<bool>();
  final _createdController = BehaviorSubject<bool>();

  Stream<Map> get outData => _dataController.stream;
  Stream<bool> get outLoading => _loadingController.stream;
  Stream<bool> get outCreated => _createdController.stream;

  Map<String, dynamic> unsavedData;

  ProductBloc({this.categoryId, this.product}) {
    if (product != null) {
      unsavedData = Map.of(product.data);
      unsavedData['images'] = List.of(product.data['images']);
      unsavedData['sizes'] = List.of(product.data['sizes']);
      _createdController.add(true);
    } else {
      unsavedData = {
        'title': null,
        'description': null,
        'price': null,
        'images': [],
        'sizes': []
      };
      _createdController.add(false);
    }
    _dataController.add(unsavedData);
  }

  void saveTitle(String value) {
    unsavedData['title'] = value;
  }

  void saveDescription(String value) {
    unsavedData['description'] = value;
  }

  void savePrice(String value) {
    unsavedData['price'] = double.parse(value);
  }

  void saveImages(List value) {
    unsavedData['images'] = value;
  }

  Future<bool> saveProduct() async {
    _loadingController.add(true);
    try {
      if (product != null) {
        await _uploadImages(product.documentID);
        await product.reference.updateData(unsavedData);
      } else {
        DocumentReference dr = await Firestore.instance
            .collection("products")
            .document(categoryId)
            .collection('items')
            .add(Map.from(unsavedData)..remove('images'));
        await _uploadImages(dr.documentID);
        await dr.updateData(unsavedData);
      }
      _loadingController.add(false);
      return true;
    } catch (e) {
      _loadingController.add(false);
      return false;
    }
  }

  void saveSizes(List sizes) {
    unsavedData["sizes"] = sizes;
  }

  void deleteProduct() {
    product.reference.delete();
  }

  _uploadImages(String uid) async {
    for (int i = 0; i < unsavedData['images'].length; i++) {
      if (unsavedData['images'][i] is String) continue;
      StorageUploadTask uploadTask = FirebaseStorage.instance
          .ref()
          .child(categoryId)
          .child(uid)
          .child(DateTime.now().millisecondsSinceEpoch.toString())
          .putFile(unsavedData['images'][i]);

      StorageTaskSnapshot s = await uploadTask.onComplete;

      String url = await s.ref.getDownloadURL();

      unsavedData['images'][i] = url;
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _dataController.close();
    _loadingController.close();
    _createdController.close();
  }
}
