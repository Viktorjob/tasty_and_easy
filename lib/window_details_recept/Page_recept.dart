import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Page_recept extends StatefulWidget {
  final String dishName;

  const Page_recept({Key? key, required this.dishName}) : super(key: key);

  @override
  _Page_receptState createState() => _Page_receptState();
}

class _Page_receptState extends State<Page_recept> {
  Query? dbRef;
  bool isFavorite = false;
  Map<String, dynamic>? data;
  String? uid = FirebaseAuth.instance.currentUser?.uid;
  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.reference().child('${widget.dishName}');
    loadIsFavorite();
  }

  void loadIsFavorite() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool favorite = prefs.getBool(widget.dishName) ?? false;
    setState(() {
      isFavorite = favorite;
    });
  }

  // Определите метод saveIsFavorite для сохранения состояния в SharedPreferences
  void saveIsFavorite(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(widget.dishName, value);
  }
  void toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
    });
    saveIsFavorite(isFavorite);

    DatabaseReference likeListRef = FirebaseDatabase.instance.reference().child('users').child(uid!).child('Like_list');

    if (isFavorite && data != null) {
      likeListRef.push().set({
        'name': widget.dishName,
        'image_url': data!['image_url'],
      });
    } else {
      // Удалите блюдо из списка Like_list, если оно было удалено из избранных
      likeListRef.orderByChild('name').equalTo(widget.dishName).once().then((event) {
        final snapshot = event.snapshot;
        Map<dynamic, dynamic>? values = snapshot.value as Map?;
        if (values != null) {
          values.forEach((key, value) {
            likeListRef.child(key).remove();
          });
        }
      });
    }
  }


  Widget _buildIngredientRow(Map<String, dynamic> data, String ingredientKey, String quantityKey) {
    if (data[ingredientKey] != null && data[quantityKey] != null) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Text(data[ingredientKey]),
            Expanded(
              child: Divider(), // Используйте Divider внутри Expanded
            ),
            Text(data[quantityKey]),
          ],
        ),
      );
    } else {
      return SizedBox.shrink(); // Скрывает виджет, если данные `null`.
    }
  }




  Widget _buildStep(Map<String, dynamic> data, String stepKey) {
    if (data[stepKey] != null) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(data[stepKey]),
      );
    } else {
      return SizedBox.shrink(); // Скрывает виджет, если данные `null`.
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(widget.dishName),
      ),
      body: StreamBuilder(
        stream: dbRef!.onValue,
        builder: (context, snapshot) {

          if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
            data = Map<String, dynamic>.from(
              (snapshot.data!.snapshot.value as Map).cast<String, dynamic>(),
            );
            print('$data');
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        data!['image_url'].toString(),
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 200,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Icon(Icons.access_time, color: Colors.black),
                        SizedBox(width: 8),
                        Text(
                          data!['time'],
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (uid != null) {
                              toggleFavorite();
                            }
                          },
                          child: Opacity(
                            opacity: uid != null ? 1.0 : 0.3, // Если пользователь не вошел в систему, устанавливаем непрозрачность в 0.3
                            child: Icon(
                              isFavorite ? Icons.favorite : Icons.favorite_border,
                              color: isFavorite ? Colors.red : Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Ingredients:',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  _buildIngredientRow(data!, 'ingredient_1', 'quantity_1'),
                  _buildIngredientRow(data!, 'ingredient_2', 'quantity_2'),
                  _buildIngredientRow(data!, 'ingredient_3', 'quantity_3'),
                  _buildIngredientRow(data!, 'ingredient_4', 'quantity_4'),
                  _buildIngredientRow(data!, 'ingredient_5', 'quantity_5'),
                  _buildIngredientRow(data!, 'ingredient_6', 'quantity_6'),
                  _buildIngredientRow(data!, 'ingredient_7', 'quantity_7'),
                  _buildIngredientRow(data!, 'ingredient_8', 'quantity_8'),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Instructions:',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  _buildStep(data!, '1_step'),
                  _buildStep(data!, '2_step'),
                  _buildStep(data!, '3_step'),
                  _buildStep(data!, '4_step'),
                  _buildStep(data!, '5_step'),
                  _buildStep(data!, '6_step'),
                  _buildStep(data!, '7_step'),
                  _buildStep(data!, '8_step'),
                ],
              ),
            );
          } else {
            return Center(
              child: Text("Data is null"),
            );
          }
        },
      ),
    );
  }
}
