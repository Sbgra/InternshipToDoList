import 'package:flutter/material.dart';

class CreateProduct extends StatefulWidget {
  final Function(String)? onAdd;

  const CreateProduct({super.key, this.onAdd});

  @override
  State<CreateProduct> createState() => _CreateProductState();
}

class _CreateProductState extends State<CreateProduct> {
  var text = TextEditingController(); //???????????????
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.brown[200],
            borderRadius: BorderRadius.circular(25),
          ),
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: text,
                  decoration: InputDecoration(
                    hintText: "Add new item",
                    hintStyle: TextStyle(fontSize: 20),
                    border: InputBorder.none,
                  ),
                ),
              ),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.green[900],
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                ),
                onPressed: () {
                  if (text.text.trim().isNotEmpty) {
                    widget.onAdd?.call(text.text.trim());
                    text.clear();
                  }
                },
                child: Text('+'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
