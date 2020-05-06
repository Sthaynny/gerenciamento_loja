import 'package:flutter/material.dart';

class AddSizeDialog extends StatelessWidget {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.only(top: 8, right: 8, left: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: "Tamanho"),
            ),
            Container(
              alignment: Alignment.centerRight,
              child: FlatButton(
                child: Text("Add"),
                textColor: Colors.deepOrangeAccent,
                onPressed: () {
                  if (_controller.text.isNotEmpty) {
                    Navigator.of(context).pop(_controller.text);
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
