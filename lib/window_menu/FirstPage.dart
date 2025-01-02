import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:tasty_and_easy/country_dishes/dishes_categoria.dart';
import 'package:tasty_and_easy/window_details_recept/Page_recept.dart';

class Dish {
  String name;
  String imageUrl;
  int likes;
  String mealType;
  String time;

  Dish(this.name, this.imageUrl, this.likes, this.mealType, this.time);
}

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  ScrollController _scrollController = ScrollController();
  Query dbRef = FirebaseDatabase.instance.reference().child('Country');
  final databaseReference = FirebaseDatabase.instance.reference();

  List<Dish> breakfastDishes = [];
  List<Dish> dinnerDishes = [];

  Dish? mostLikedBreakfastDish;
  Dish? mostLikedDinnerDish;

  String? mostPopularDishImageUrl;
  String? mostPopularDishname;
  String? mostPopularDishlike;
  String? mostPopulartime;

  @override
  void initState() {
    super.initState();
    fetchDataFromDatabase();
    compareDishes();
  }

  void fetchDataFromDatabase() {
    databaseReference.child('Breakfast').onValue.listen((event) {
      updateDishesList('Breakfast', event.snapshot);
      printMostLikedDish('Breakfast');
      compareDishes();
    });

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
          if (value is Map &&
              value.containsKey('number_of_likes') &&
              value.containsKey('image_url') &&
              value.containsKey('time')) {
            var numberOfLikes = value['number_of_likes'] as int;
            var imageUrl = value['image_url'] as String;
            var dishName = key;
            var time = value['time'] as String;

            var dish = Dish(dishName, imageUrl, numberOfLikes, category, time);
            dishesList.add(dish);
          }
        });

        if (category == 'Breakfast') {
          breakfastDishes = dishesList;
        } else if (category == 'Dinner') {
          dinnerDishes = dishesList;
        }

        compareDishes();
      }
    }
  }

  void printMostLikedDish(String category) {
    List<Dish> dishesList =
    category == 'Breakfast' ? breakfastDishes : dinnerDishes;

    if (dishesList.isNotEmpty) {
      var mostLikedDish = dishesList
          .reduce((curr, next) => curr.likes > next.likes ? curr : next);

      if (category == 'Breakfast') {
        mostLikedBreakfastDish = mostLikedDish;
      } else if (category == 'Dinner') {
        mostLikedDinnerDish = mostLikedDish;
      }
    }
  }

  void compareDishes() {
    if (mostLikedBreakfastDish != null && mostLikedDinnerDish != null) {
      mostPopularDishImageUrl =
      mostLikedBreakfastDish!.likes > mostLikedDinnerDish!.likes
          ? mostLikedBreakfastDish!.imageUrl
          : mostLikedDinnerDish!.imageUrl;

      mostPopularDishname =
      mostLikedBreakfastDish!.likes > mostLikedDinnerDish!.likes
          ? mostLikedBreakfastDish!.name
          : mostLikedDinnerDish!.name;

      mostPopularDishlike =
      mostLikedBreakfastDish!.likes > mostLikedDinnerDish!.likes
          ? mostLikedBreakfastDish!.likes.toString()
          : mostLikedDinnerDish!.likes.toString();


      mostPopulartime =
      mostLikedBreakfastDish!.likes > mostLikedDinnerDish!.likes
          ? mostLikedBreakfastDish!.time.toString()
          : mostLikedDinnerDish!.time.toString();




      var mostPopularDish = mostLikedBreakfastDish!.likes > mostLikedDinnerDish!.likes
          ? mostLikedBreakfastDish!
          : mostLikedDinnerDish!;

      print("Most Popular Dish:");
      print("Name: ${mostPopularDish.name}");
      print("Likes: ${mostPopularDish.likes}");
      print("Image URL: $mostPopularDishImageUrl");

      setState(() {});
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
                expandedHeight: 170.0,
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
                return Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasData &&
                  snapshot.data!.snapshot.value != null &&
                  (snapshot.data!.snapshot.value as Map).isNotEmpty) {
                Map<String, dynamic> users = Map<String, dynamic>.from(
                  (snapshot.data!.snapshot.value as Map)
                      .cast<String, dynamic>(),
                );

                List userList = users.values.toList();

                userList.sort((a, b) => (b['number_of_likes'] ?? 0)
                    .compareTo(a['number_of_likes'] ?? 0));

                return Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: ListView(
                    children: [
                      Column(
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
                          Padding(
                            padding: const EdgeInsets.only(top : 10.0),
                            child: Text(
                              "Best Dishe",
                              style: TextStyle(
                                fontSize: 23,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Container(
                            width: 250,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.amber,
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: mostPopularDishImageUrl != null
                                ? Stack(
                              alignment: Alignment.bottomLeft,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Page_recept(
                                          dishName: mostPopularDishname!,
                                          dishtime: mostPopulartime!, SSS: mostPopularDishname!,
                                          // Другие параметры, которые вам нужны
                                        ),
                                      ),
                                    );
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.network(
                                      mostPopularDishImageUrl!,
                                      width: 500,
                                      height: 200,
                                      fit: BoxFit.cover,
                                    ),

                                  ),
                                ),
                                Container(
                                  height: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                ),
                                Column(
                                  children: [
                                    Text(
                                      mostPopularDishname!,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.bookmark_border,
                                          color: Colors.white,
                                          size: 15,
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          mostPopularDishlike!,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Icon(
                                          Icons.access_time,
                                          color: Colors.white,
                                          size: 15,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          mostPopulartime!,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            )
                                : Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        ],
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

    String? Name_country = user['name'];
    return InkWell(
        onTap: () {
          print('Tapped on $Name_country');
          if (Name_country != null) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => country_dish(country_dish_name: Name_country),
              ),
            );
          }
        },

      child: Container(
        width: 200,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.amber,
            width: 2.0,
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
