import 'package:flutter/material.dart';
import 'package:gerenciamento_loja/views/products/tile/sizes/add_sizes_dialog.dart';

class ProductSizes extends FormField<List> {
  ProductSizes({
    BuildContext context,
    List initialValue,
    FormFieldSetter<List> onSaved,
    FormFieldValidator<List> validator,
  }) : super(
            initialValue: initialValue,
            onSaved: onSaved,
            validator: validator,
            builder: (state) {
              return SizedBox(
                height: 34,
                child: GridView(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  scrollDirection: Axis.horizontal,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      mainAxisSpacing: 8,
                      childAspectRatio: 0.5),
                  children: state.value.map((s) {
                    return GestureDetector(
                      onLongPress: () {
                        state.didChange(state.value..remove(s));
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: Colors.deepOrangeAccent,
                              width: 2,
                            )),
                        child: Text(
                          s,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  }).toList()
                    ..add(GestureDetector(
                      onTap: () async {
                        String size = await showDialog(
                          context: context,
                          builder: (context) => AddSizeDialog(),
                        );
                        if (size != null) {
                          state.didChange(state.value..add(size));
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: state.hasError
                                  ? Colors.red
                                  : Colors.deepOrangeAccent,
                              width: 2,
                            )),
                        child: Text(
                          "+",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )),
                ),
              );
            });
}
