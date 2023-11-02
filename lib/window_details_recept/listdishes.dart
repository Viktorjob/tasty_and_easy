import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:tasty_and_easy/window_details_recept/Page_recept.dart';
import 'package:tasty_and_easy/window_details_recept/filtrs_window.dart';

class ListDishes extends StatefulWidget {
  final String dishKey;

  const ListDishes({Key? key, required this.dishKey}) : super(key: key);

  @override
  _ListDishesState createState() => _ListDishesState(dishKey);
}

class _ListDishesState extends State<ListDishes> {
  Query? dbRef;
  String dishKey;
  bool glutenFree = false;
  bool lactoseFree = false;
  bool vegetarian = false;
  bool vegan = false;

  _ListDishesState(this.dishKey);

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.reference().child(dishKey);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(dishKey),
        backgroundColor: Colors.lightGreen,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              filtrs_details_window(
                context,
                glutenFree,
                lactoseFree,
                vegetarian,
                vegan,
                    (gluten, lactose, veg, vegan) {
                  setState(() {
                    glutenFree = gluten;
                    lactoseFree = lactose;
                    vegetarian = veg;
                    this.vegan = vegan; // Обновляем значение vegan в этом классе
                  });
                },
              );

            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: dbRef!.onValue,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
            Map<String, dynamic> users = Map<String, dynamic>.from(
              (snapshot.data!.snapshot.value as Map).cast<String, dynamic>(),
            );

            final filteredDishes = users.values.where((dish) {
              final hasGluten = dish['Gluten'] == glutenFree;
              final hasLactose = dish['Lactose'] == lactoseFree;
              final isVegetarian = dish['Vegetarian'] == vegetarian;
              final isVegan = dish['Vegan'] == vegan;

              // Если все фильтры отключены, показываем все блюда
              if (!glutenFree && !lactoseFree && !vegetarian && !vegan) {
                return true;
              }

              return hasGluten && hasLactose && isVegetarian && isVegan;
            }).toList();





            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 0.0,
                mainAxisSpacing: 0.0,
              ),
              itemCount: filteredDishes.length,
              itemBuilder: (BuildContext context, int index) {
                final user1 = filteredDishes[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListItem(
                    user1: user1,
                  ),
                );
              },
            );
          } else {
            return Text("Data is null");
          }
        },
      ),
    );
  }
}

class ListItem extends StatelessWidget {
  final Map user1;

  ListItem({required this.user1});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => Page_recept(dishName: user1['name']),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
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
                user1['image_url'].toString(),
                fit: BoxFit.cover,
              ),
              Container(
                color: Colors.black.withOpacity(0.6),
                child: Center(
                  child: Text(
                    user1['name'] != null ? user1['name'] : '',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
