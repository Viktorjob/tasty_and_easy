import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Top_like extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class Likedish extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Top_like(),
    );
  }
}

class Dish {
  String name;
  String imageUrl;
  int likes;
  String mealType; // "Breakfast" or "Dinner"

  Dish(this.name, this.imageUrl, this.likes, this.mealType);
}

class _MyHomePageState extends State<Top_like> {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase Data'),
      ),
      body: Center(
        child: Text('Check the console for data from Firebase'),
      ),
    );
  }
}
