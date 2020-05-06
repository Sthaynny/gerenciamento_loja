import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageSourceSheet extends StatelessWidget {
  final Function(File) onImageSelected;

  ImageSourceSheet({@required this.onImageSelected});

  Future<void> ImageSelected(File image) async {
    if (image != null) {
      File cropped = await ImageCropper.cropImage(
          sourcePath: image.path,
          aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0));
      onImageSelected(cropped);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            FlatButton(
                onPressed: () async {
                  File image =
                      await ImagePicker.pickImage(source: ImageSource.camera);
                  ImageSelected(image);
                },
                child: Text("Câmera")),
            FlatButton(
                onPressed: () async {
                  File image =
                      await ImagePicker.pickImage(source: ImageSource.gallery);
                  ImageSelected(image);
                },
                child: Text("Galeria")),
          ],
        );
      },
      onClosing: () {},
    );
  }
}
