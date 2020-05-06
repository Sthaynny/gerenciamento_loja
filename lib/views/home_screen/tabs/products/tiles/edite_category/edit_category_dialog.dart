import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerenciamento_loja/controllers/category/category_bloc.dart';
import 'package:gerenciamento_loja/views/products/tile/custom_image/imagesource_sheet.dart';

class EditCategoryDialog extends StatefulWidget {
  final DocumentSnapshot category;

  EditCategoryDialog({this.category});

  @override
  _EditCategoryDialogState createState() =>
      _EditCategoryDialogState(category: category);
}

class _EditCategoryDialogState extends State<EditCategoryDialog> {
  final CategoryBloc _categoryBloc;
  final TextEditingController _editController;

  _EditCategoryDialogState({DocumentSnapshot category})
      : _categoryBloc = CategoryBloc(category),
        _editController = TextEditingController(
            text: category != null ? category.data['title'] : "");

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => ImageSourceSheet(
                      onImageSelected: (File image) {
                        Navigator.of(context).pop();
                        _categoryBloc.setImage(image);
                      },
                    ),
                  );
                },
                child: StreamBuilder(
                  stream: _categoryBloc.outIcon,
                  builder: (context, snapshot) {
                    var child;
                    if (snapshot.data != null) {
                      snapshot.data is File
                          ? child = Image.file(
                              snapshot.data,
                              fit: BoxFit.cover,
                            )
                          : child = Image.network(
                              snapshot.data,
                              fit: BoxFit.cover,
                            );
                    } else {
                      child = Icon(
                        Icons.image,
                        color: Colors.deepOrangeAccent,
                      );
                    }
                    return CircleAvatar(
                      child: child,
                      backgroundColor: Colors.transparent,
                    );
                  },
                ),
              ),
              title: StreamBuilder<String>(
                  stream: _categoryBloc.outTitle,
                  builder: (context, snapshot) {
                    return TextField(
                      controller: _editController,
                      decoration: InputDecoration(
                        labelText: "Categoria",
                        errorText: snapshot.hasError ? snapshot.error : null,
                      ),
                      onChanged: _categoryBloc.setTitle,
                    );
                  }),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                StreamBuilder<bool>(
                    stream: _categoryBloc.outDelete,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Container();
                      }
                      return FlatButton(
                        onPressed: snapshot.data
                            ? () {
                                _categoryBloc.delete();
                                Navigator.of(context).pop();
                              }
                            : null,
                        child: Text("Excluir"),
                        textColor: Colors.red,
                      );
                    }),
                StreamBuilder<bool>(
                    stream: _categoryBloc.submitValide,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return Container();
                      return FlatButton(
                        onPressed: snapshot.hasData
                            ? () async {
                                await _categoryBloc.saveData();
                                Navigator.of(context).pop();
                              }
                            : null,
                        child: Text("Salvar"),
                        textColor: Colors.deepOrangeAccent,
                      );
                    }),
              ],
            )
          ],
        ),
      ),
    );
  }
}
