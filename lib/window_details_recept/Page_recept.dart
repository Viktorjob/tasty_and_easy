import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:tasty_and_easy/window_details_recept/history_page.dart';

class Page_recept extends StatefulWidget {
  final String dishName;

  const Page_recept({Key? key, required this.dishName}) : super(key: key);

  @override
  _Page_receptState createState() => _Page_receptState();
}
class _Page_receptState extends State<Page_recept> {

  Query? dbRef;

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.reference().child('Breakfast/${widget.dishName}');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text(widget.dishName),
        ),
        body: StreamBuilder(
          stream: dbRef!.onValue, // Используйте ваш запрос к Firebase
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
              Map<String, dynamic> data = Map<String, dynamic>.from(
                (snapshot.data!.snapshot.value as Map).cast<String, dynamic>(),
              );
              print(data.toString());
              // Ваши данные доступны в переменной 'data', их можно отобразить или обработать здесь
              return ListView(
                children: [
                  Column(
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10), // Устанавливаем радиус скругления углов
                              child: Image.network(
                                data['image_url'].toString(),
                                fit: BoxFit.cover,
                                width: 400, // Задаем ширину изображения (можете изменить на свое усмотрение)
                                height: 200, // Задаем высоту изображения (можете изменить на свое усмотрение)
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              History_page(
                                context,
                                widget.dishName, // Передаем название блюда в качестве заголовка
                                data['history'], // Передаем ингредиенты
                              );
                            },
                            child: Icon(
                              Icons.history_edu,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),

                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 140.0, top: 20),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Row(
                                children: [
                                  Icon(Icons.access_time, color: Colors.black), // Иконка часов
                                  SizedBox(width: 8), // Отступ между иконкой и текстом
                                  Text(
                                    data['time'],
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 140.0, top: 20), // Добавляем отступ слева
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(data['ingredients'],
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Row(
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child:Text(data['ingredient_1']),
                            ),
                            Align(
                              child:Text(' ________________________________________ '),
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child:Text(data['quantity_1']),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Row(
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child:Text(data['ingredient_2']),
                            ),
                            Align(
                              child:Text(' ________________________________________ '),
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child:Text(data['quantity_2']),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Row(
                          children: [
                            Align(
                              alignment: Alignment.topLeft,
                              child:Text(data['ingredient_3']),
                            ),
                            Align(
                              child:Text(' ________________________________________ '),
                            ),
                            Align(
                              alignment: Alignment.topLeft,
                              child:Text(data['quantity_3']),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 100.0 , top: 20), // Добавляем отступ слева
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(data['instructions'],
                            style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0), // Добавляем отступ слева
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(data['1_step']),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(data['2_step']),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(data['3_step']),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(data['4_step']),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(data['5_step']),
                        ),
                      ),
                    ],


                  ),
                ],
              );
            } else {
              return Center(
                child: Text("Data is null"),
              );
            }
          },
        ),
      ),
    );
  }
}
