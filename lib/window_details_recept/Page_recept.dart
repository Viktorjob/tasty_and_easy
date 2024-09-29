import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart' as database; // Используйте префикс
import 'package:cloud_firestore/cloud_firestore.dart' as firestore; // Используйте префикс
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tasty_and_easy/window_details_recept/commends_window.dart';

class Page_recept extends StatefulWidget {
  final String dishName;
  final String SSS;

  const Page_recept({Key? key, required this.dishName, required this.SSS, required String dishtime}) : super(key: key);

  @override
  _Page_receptState createState() => _Page_receptState();
}

class _Page_receptState extends State<Page_recept> {
  database.Query? dbRef;
  bool isFavorite = false;
  int likesCount = 0;
  Map<String, dynamic>? data;
  String? uid = FirebaseAuth.instance.currentUser?.uid;
  bool showScrollIcon = true;
  List<String> likedKeys = [];
  String newLikeKey = "";
  String? userName;

  @override

  void initState() {
    super.initState();

    dbRef = database.FirebaseDatabase.instance.reference().child('Dishes/${widget.dishName}');
    loadLikedKeys();
    loadIsFavorite();
    loadLikesCount();
    getUserName();
  }



  void loadIsFavorite() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool favorite = prefs.getBool('${widget.dishName}_$uid') ?? false;
    setState(() {
      isFavorite = favorite || (data != null && data!['is_favorite'] == true);
    });
  }

  void loadLikedKeys() async {
    database.DatabaseReference likedKeysRef = database.FirebaseDatabase.instance.reference().child('users').child(uid!).child('Like_list');
    likedKeysRef.once().then((event) {
      if (event.snapshot.value != null) {
        Map<dynamic, dynamic>? updatedKeys = event.snapshot.value as Map?;
        print('Data from Firebase: $updatedKeys');

        List<String> keysList = [];

        if (updatedKeys != null) {
          updatedKeys.forEach((key, value) {
            keysList.add(key.toString());
          });
        }

        setState(() {
          likedKeys = keysList;
          // Проверка наличия блюда в списке likedKeys
          isFavorite = likedKeys.any((key) => updatedKeys?[key]?['name'] == widget.dishName);
        });

        // Вывести названия блюд для каждого ключа
        likedKeys.forEach((key) {
          print('Dish Name: ${updatedKeys?[key]?['name']}');
        });
      } else {
        setState(() {
          likedKeys = [];
          isFavorite = false; // Если список пуст, блюда нет в избранном
        });
      }
    });
  }

  void saveLikedKeys() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('sfsdfsfsd');
    prefs.setStringList('likedKeys', likedKeys);
  }

  void loadLikesCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    likesCount = prefs.getInt('${widget.dishName}_likes') ?? 0;

    // Обновленный путь для получения количества лайков блюда
    DatabaseReference likesRef = FirebaseDatabase.instance.reference().child('Dishes/${widget.dishName}/number_of_likes');

    likesRef.onValue.listen((event) {
      if (event.snapshot.value != null) {
        setState(() {
          likesCount = (event.snapshot.value as int?) ?? 0;
        });
      }
    });
  }


  void saveIsFavorite(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('${widget.dishName}_$uid', value);
  }

  void saveLikesCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('${widget.dishName}_likes', likesCount);

    DatabaseReference likesRef =
    FirebaseDatabase.instance.reference().child('${widget.SSS}/${widget.dishName}/number_of_likes');
    likesRef.set(likesCount);
  }


  void toggleFavorite() async {
    setState(() {
      isFavorite = !isFavorite;
      likesCount += isFavorite ? 1 : -1;
      saveLikesCount();
    });
    saveIsFavorite(isFavorite);

    // Обновленный путь для изменения количества лайков блюда
    DatabaseReference likesRef = FirebaseDatabase.instance.reference().child('Dishes/${widget.dishName}/number_of_likes');
    await likesRef.set(likesCount);

    // Обновленный путь к списку лайков пользователя
    DatabaseReference likeListRef = FirebaseDatabase.instance.reference().child('users').child(uid!).child('Like_list');

    if (isFavorite && data != null) {
      DatabaseReference newLikeRef = likeListRef.push();
      newLikeKey = newLikeRef.key!;

      // Сохраняем информацию о блюде в списке избранного пользователя
      await newLikeRef.set({
        'name': widget.dishName,
        'image_url': data!['image_url'],
        'time': data!['time'],
        'like': likesCount,
      });

      print('Сгенерированный ключ для нового элемента: $newLikeKey');
    } else {
      // Удаление блюда из списка избранного
      await likeListRef.orderByChild('name').equalTo(widget.dishName).once().then((event) {
        final snapshot = event.snapshot;
        Map<dynamic, dynamic>? values = snapshot.value as Map?;
        if (values != null) {
          values.forEach((key, value) {
            likeListRef.child(key).remove(); // Удаляем элемент по ключу
          });
        }
      });
    }

    setState(() {
      likedKeys.add(newLikeKey);
    });
    saveLikedKeys();
  }




  Widget _buildIngredientsBlock(Map<String, dynamic> data) {
    List<Widget> ingredientsWidgets = [];
    print('++++++');
    print(likedKeys);
    print('------');
    print(widget.dishName);


    for (int i = 1; i <= 13; i++) {
      String ingredientKey = 'ingredient_$i';
      String quantityKey = 'quantity_$i';

      if (data[ingredientKey] != null && data[quantityKey] != null) {
        ingredientsWidgets.add(_buildIngredientRow(data, i));
      }
    }

    double maxImageHeight = 300;
    double imageBorderRadius = 30.0;
    double imagePadding = 15.0;

    return Padding(
      padding: EdgeInsets.all(imagePadding),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(imageBorderRadius),
              border: Border.all(
                color: Colors.amber, // Цвет линии
                width: 2.0, // Ширина линии
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(imageBorderRadius),
              child: Image.network(
                data['image_url'].toString(),
                fit: BoxFit.cover,
                width: double.infinity,
                height: maxImageHeight,
              ),
            ),
          ),

          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(imageBorderRadius),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.5),
                    Colors.black.withOpacity(0.9),
                  ],
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ...ingredientsWidgets,
                  ],
                ),
              ),
            ),
          ),
          if (showScrollIcon && ingredientsWidgets.length > 6)
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    showScrollIcon = false;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(imageBorderRadius),
                    color: Colors.black.withOpacity(0.5), // Цвет затемненного фона
                    // Добавьте другие свойства декорации по вашему усмотрению
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/swipe.png',
                      fit: BoxFit.cover,
                    ),
                  ),

                ),


              ),
            ),
        ],
      ),
    );
  }



  Widget _buildIngredientRow(Map<String, dynamic> data, int i) {
    String ingredientKey = 'ingredient_$i';
    String quantityKey = 'quantity_$i';

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Text(
            data[ingredientKey],
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          Expanded(
            child: Container(
              height: 1,
              color: Colors.amber,
              margin: EdgeInsets.symmetric(horizontal: 8.0),
            ),
          ),
          Text(
            data[quantityKey],
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep(Map<String, dynamic> data, String stepKey) {
    if (data[stepKey] != null) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(data[stepKey], style: TextStyle(color: Colors.white)),
      );
    } else {
      return SizedBox.shrink();
    }
  }

  // Добавьте это после определения переменных в _Page_receptState
  Future<String?> getUserName() async {
    if (uid != null) {
      firestore.DocumentSnapshot userDoc = await firestore.FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (userDoc.exists) {
        String userName = userDoc.get('name');
        print("Имя пользователя: $userName"); // Выводим имя в консоль
        return userName;
      }
    }
    return null;
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color(0xFF0B0E12),
      appBar: AppBar(
        backgroundColor: Colors.amber,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            saveLikesCount();
            Navigator.of(context).pop();
          },
        ),
        title: Text(widget.dishName),
      ),
      body: FutureBuilder(
        future: dbRef!.once(), // Загрузка данных один раз
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
            data = Map<String, dynamic>.from(
              (snapshot.data!.snapshot.value as Map).cast<String, dynamic>(),
            );
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
                    child: Column(
                      children: [
                        // Center(child: Text(widget.dishName, style: TextStyle(color: Colors.white, fontSize: 15))),
                        Row(
                          children: [
                            Icon(Icons.access_time, color: Colors.white),
                            SizedBox(width: 8),
                            Text(
                              data!['time'],
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Spacer(),
                            IconButton(
                              icon: Icon(Icons.comment, color: Colors.amber),
                              onPressed: () async {
                                // Используйте dishName как уникальный идентификатор блюда
                                String dishId = widget.dishName; // Здесь вы используете dishName как идентификатор
                                print('***********8');

                                // Ждем загрузки имени пользователя
                                String? loadedUserName = await getUserName();

                                if (loadedUserName != null) {
                                  Comments_window(context, dishId, loadedUserName); // Передаем dishId и userName
                                } else {
                                  print("Имя пользователя еще не загружено.");
                                }
                              },
                            ),


                          ],

                        ),
                        FutureBuilder<String?>(
                          future: getUserName(),
                          builder: (context, AsyncSnapshot<String?> userNameSnapshot) {
                            if (userNameSnapshot.connectionState == ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (userNameSnapshot.hasError) {
                              return Text("Ошибка загрузки имени", style: TextStyle(color: Colors.red));
                            }

                              return SizedBox.shrink(); // Если имени нет, ничего не отображать
                            }

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
                            opacity: uid != null ? 1.0 : 0.3,
                            child: Icon(
                              isFavorite ? Icons.favorite : Icons.favorite_outline,
                              color: isFavorite ? Colors.amber : Colors.grey,
                            ),
                          ),
                        ),
                        Text('Likes: $likesCount', style: TextStyle(color: Colors.white)),

                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Ingredients:',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  _buildIngredientsBlock(data!),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Instructions:',
                      style: TextStyle(
                        color: Colors.white,
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
                  _buildStep(data!, '9_step'),
                  _buildStep(data!, '10_step'),
                  _buildStep(data!, '11_step'),
                  _buildStep(data!, '12_step'),
                  _buildStep(data!, '13_step'),
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