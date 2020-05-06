import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerenciamento_loja/controllers/product/product_bloc.dart';
import 'package:gerenciamento_loja/validators/porduct_validator.dart';
import 'package:gerenciamento_loja/views/products/tile/image/Image_widget.dart';
import 'package:gerenciamento_loja/views/products/tile/sizes/producs_sizes.dart';

class ProductScreen extends StatefulWidget {
  final String categoryId;
  final DocumentSnapshot product;

  ProductScreen({@required this.categoryId, this.product});

  @override
  _ProductScreenState createState() => _ProductScreenState(categoryId, product);
}

class _ProductScreenState extends State<ProductScreen> with ProductValidator {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final ProductBloc _productBloc;

  _ProductScreenState(String categoryId, DocumentSnapshot product)
      : _productBloc = ProductBloc(
          categoryId: categoryId,
          product: product,
        );
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final _fieldStyle = TextStyle(color: Colors.white, fontSize: 16);
    InputDecoration _buildDecoration(String label) {
      return InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey),
      );
    }

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[850],
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        elevation: 0,
        title: StreamBuilder<bool>(
            stream: _productBloc.outCreated,
            initialData: false,
            builder: (context, snapshot) {
              return Text(snapshot.data ? "Editar Produto" : "Criar Produto");
            }),
        actions: <Widget>[
          StreamBuilder<bool>(
              stream: _productBloc.outCreated,
              initialData: false,
              builder: (context, snapshot) {
                if (snapshot.data)
                  return StreamBuilder<bool>(
                    stream: _productBloc.outLoading,
                    initialData: false,
                    builder: (context, snapshot) {
                      return IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: snapshot.data
                            ? null
                            : () {
                                _productBloc.deleteProduct();
                                Navigator.of(context).pop();
                              },
                      );
                    },
                  );
                else
                  return Container();
              }),
          StreamBuilder<bool>(
            stream: _productBloc.outLoading,
            initialData: false,
            builder: (context, snapshot) {
              return IconButton(
                icon: Icon(Icons.save),
                onPressed: snapshot.data ? null : saveProduct,
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          Form(
            key: _formKey,
            child: StreamBuilder<Map>(
              stream: _productBloc.outData,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                }
                return ListView(
                  padding: EdgeInsets.all(16),
                  children: <Widget>[
                    Text(
                      "Images",
                      style: TextStyle(color: Colors.grey),
                    ),
                    ImagesWidget(
                      context: context,
                      initialValue: snapshot.data['images'],
                      onSaved: _productBloc.saveImages,
                      validator: validateImage,
                    ),
                    TextFormField(
                      cursorColor: Colors.deepOrangeAccent,
                      initialValue: snapshot.data['title'],
                      style: _fieldStyle,
                      decoration: _buildDecoration("Título"),
                      onSaved: _productBloc.saveTitle,
                      validator: validateTile,
                    ),
                    TextFormField(
                      cursorColor: Colors.deepOrangeAccent,
                      initialValue: snapshot.data['description'],
                      style: _fieldStyle,
                      maxLines: 6,
                      decoration: _buildDecoration("Descrição"),
                      onSaved: _productBloc.saveDescription,
                      validator: validateDescription,
                    ),
                    TextFormField(
                      cursorColor: Colors.deepOrangeAccent,
                      initialValue: snapshot.data['price']?.toStringAsFixed(2),
                      style: _fieldStyle,
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      decoration: _buildDecoration("Preço"),
                      onSaved: _productBloc.savePrice,
                      validator: validatePrice,
                    ),
                    SizedBox(height: 16),
                    Text(
                      "Tamanho(s)",
                      style: TextStyle(color: Colors.grey),
                    ),
                    ProductSizes(
                      context: context,
                      initialValue: snapshot.data['sizes'],
                      onSaved: _productBloc.saveSizes,
                      validator: (s) {
                        if (s.isEmpty) return "";
                      },
                    )
                  ],
                );
              },
            ),
          ),
          StreamBuilder<bool>(
            stream: _productBloc.outLoading,
            initialData: false,
            builder: (context, snapshot) {
              return IgnorePointer(
                ignoring: !snapshot.data,
                child: Container(
                  color: snapshot.data ? Colors.black54 : Colors.transparent,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> saveProduct() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          backgroundColor: Colors.deepOrangeAccent,
          content: Text(
            "Salvando produto...",
            style: TextStyle(color: Colors.white),
          ),
          duration: Duration(minutes: 1),
        ),
      );

      bool success = await _productBloc.saveProduct();

      _scaffoldKey.currentState.removeCurrentSnackBar();

      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          backgroundColor: success ? Colors.green : Colors.red,
          content: Text(
            success ? "Produto salvo" : "Erro ao salvar produto!",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }
  }
}
