import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../top/top_1_dishes.dart';
import '../country_dishes/dishes.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  _FirstPageState createState() => _FirstPageState();
}
class Dish {
  String name;
  String imageUrl;
  int likes;
  String mealType; // "Breakfast" or "Dinner"

  Dish(this.name, this.imageUrl, this.likes, this.mealType);
}
class _FirstPageState extends State<FirstPage> {
  ScrollController _scrollController = ScrollController();
  Query dbRef = FirebaseDatabase.instance.reference().child('Country');
  final databaseReference = FirebaseDatabase.instance.reference();


  List<Dish> breakfastDishes = [];
  List<Dish> dinnerDishes = [];

  Dish? mostLikedBreakfastDish;
  Dish? mostLikedDinnerDish;

  @override
  void initState() {
    super.initState();
    fetchDataFromDatabase();
  }

  void fetchDataFromDatabase() {
    // Слушаем изменения в Breakfast
    databaseReference.child('Breakfast').onValue.listen((event) {
      updateDishesList('Breakfast', event.snapshot);
      printMostLikedDish('Breakfast');
      compareDishes();
    });

    // Слушаем изменения в Dinner
    databaseReference.child('Dinner').onValue.listen((event) {
      updateDishesList('Dinner', event.snapshot);
      printMostLikedDish('Dinner');
      compareDishes();
    });
  }

  void updateDishesList(String category, DataSnapshot snapshot) {
    List<Dish> dishesList = [];

    if (snapshot.value != null) {
      var dishesData = snapshot.value;

      if (dishesData is Map) {
        dishesData.forEach((key, value) {
          if (value is Map && value.containsKey('number_of_likes') && value.containsKey('image_url')) {
            var numberOfLikes = value['number_of_likes'] as int;
            var imageUrl = value['image_url'] as String;
            var dish = Dish(key, imageUrl, numberOfLikes, category);

            dishesList.add(dish);
          }
        });

        if (category == 'Breakfast') {
          breakfastDishes = dishesList;
        } else if (category == 'Dinner') {
          dinnerDishes = dishesList;
        }

        // Вызываем compareDishes() после загрузки данных
        compareDishes();
      }
    }
  }

  void printMostLikedDish(String category) {
    List<Dish> dishesList = category == 'Breakfast' ? breakfastDishes : dinnerDishes;

    if (dishesList.isNotEmpty) {
      var mostLikedDish = dishesList.reduce((curr, next) => curr.likes > next.likes ? curr : next);

      if (category == 'Breakfast') {
        mostLikedBreakfastDish = mostLikedDish;
        print('Most Liked Breakfast Dish: ${mostLikedDish.name}, Likes: ${mostLikedDish.likes}, Image URL: ${mostLikedDish.imageUrl}');
      } else if (category == 'Dinner') {
        mostLikedDinnerDish = mostLikedDish;
        print('Most Liked Dinner Dish: ${mostLikedDish.name}, Likes: ${mostLikedDish.likes}, Image URL: ${mostLikedDish.imageUrl}');
      }
    }
  }

  void compareDishes() {
    if (mostLikedBreakfastDish != null && mostLikedDinnerDish != null) {
      if (mostLikedBreakfastDish!.likes > mostLikedDinnerDish!.likes) {
        print('The most liked dish is from Breakfast: ${mostLikedBreakfastDish!.name}');
      } else if (mostLikedDinnerDish!.likes > mostLikedBreakfastDish!.likes) {
        print('The most liked dish is from Dinner: ${mostLikedDinnerDish!.name}');
      } else {
        print('The most liked dishes from Breakfast and Dinner have the same number of likes.');
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0B0E12),
      body: Container(
        decoration: BoxDecoration(),
        child: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 200.0,
                floating: false,
                pinned: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                flexibleSpace: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return FlexibleSpaceBar(
                      background: Image.asset(
                        'assets/appbar_new.jpg',
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  height: 2,
                  color: Colors.amber,
                ),
              ),
            ];
          },
          body: StreamBuilder(
            stream: dbRef.onValue,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }

              if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
                Map<String, dynamic> users = Map<String, dynamic>.from(
                  (snapshot.data!.snapshot.value as Map).cast<String, dynamic>(),
                );

                // Преобразование Map в List для сортировки
                List userList = users.values.toList();

                // Сортировка списка пользователей по количеству лайков (или другому критерию)
                userList.sort((a, b) =>
                    (b['number_of_likes'] ?? 0).compareTo(a['number_of_likes'] ?? 0));

                return Padding(
                  padding: EdgeInsets.only(top: 50),
                  child: Column(
                    children: [
                      Text(
                        "Traditional Dishes",
                        style: TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Container(
                        width: 500,
                        height: 200,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: userList.length,
                          itemBuilder: (BuildContext context, int index) {
                            final user = userList[index];
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: listItem(user: user),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return Text("Data is null");
              }
            },
          ),
        ),
      ),
    );
  }


  Widget listItem({required Map user}) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>country_dish(),
          ),
        );
      },
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.amber, // Задайте цвет золотой линии
            width: 2.0, // Задайте толщину золотой линии
          ),
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(2, 2),
              blurRadius: 10,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.network(
                user['image_url'].toString(),
                fit: BoxFit.cover,
              ),
              Container(
                height: 10,
                color: Colors.black.withOpacity(0.2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}