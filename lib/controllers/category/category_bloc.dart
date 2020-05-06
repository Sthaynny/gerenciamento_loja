import 'dart:async';
import 'dart:io';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:rxdart/rxdart.dart';

class CategoryBloc extends BlocBase {
  File image;
  String title;
  final _titleController = BehaviorSubject<String>();
  final _imageController = BehaviorSubject();
  final _deleteController = BehaviorSubject<bool>();

  Stream<String> get outTitle => _titleController.stream.transform(
          StreamTransformer<String, String>.fromHandlers(
              handleData: (title, sink) {
        if (title.isEmpty)
          sink.addError("Insira um título");
        else
          sink.add(title);
      }));
  Stream get outIcon => _imageController.stream;
  Stream<bool> get outDelete => _deleteController.stream;
  Stream<bool> get submitValide =>
      Observable.combineLatest2(outTitle, outIcon, (a, b) => true);

  DocumentSnapshot category;

  CategoryBloc(this.category) {
    if (category != null) {
      title = category.data['title'];
      _titleController.add(category.data['title']);
      _imageController.add(category.data['icon']);
      _deleteController.add(true);
    } else {
      _deleteController.add(false);
    }
  }

  void setImage(File file) {
    _imageController.add(file);
    image = file;
  }

  void setTitle(String title) {
    _titleController.add(title);
    this.title = title;
  }

  Future<void> saveData() async {
    if (image == null && category != null && title == category.data['title'])
      return;
    Map<String, dynamic> dataUpdate = {};
    if (image != null) {
      StorageUploadTask tesk = FirebaseStorage.instance
          .ref()
          .child('icons')
          .child(title)
          .putFile(image);
      StorageTaskSnapshot snapshot = await tesk.onComplete;
      dataUpdate['icon'] = await snapshot.ref.getDownloadURL();
    }
    if (category == null || title != category.data['title']) {
      dataUpdate['title'] = title;
    }
    if (category == null) {
      await Firestore.instance
          .collection('products')
          .document(title.toLowerCase())
          .setData(dataUpdate);
    } else {
      await category.reference.updateData(dataUpdate);
    }
  }

  void delete() {
    category.reference.delete();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _titleController.close();
    _imageController.close();
    _deleteController.close();
  }
}
