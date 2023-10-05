import 'package:flutter/material.dart';

class listdishes extends StatefulWidget {
  const listdishes({Key? key}) : super(key: key);

  @override
  _listdishesState createState() => _listdishesState();
}

class _listdishesState extends State<listdishes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Добавляем кнопку "назад"
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Возвращаемся на предыдущий экран
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: Text("sdsf"),
      ),
    );
  }
}
