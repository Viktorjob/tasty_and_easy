import 'package:flutter/material.dart';
Future<void> History_page(BuildContext context, String title, String history) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return ListView(
        children: [
          AlertDialog(
            contentPadding: EdgeInsets.all(20.0),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text(
                    title, // Используйте переданный заголовок
                    style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.amber,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 1.0 , top: 20), // Добавляем отступ слева
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(history,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ],
      );
    },
  );
}
