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
  bool halal = false;
  String searchQuery = '';
  bool isSearching = false;
  TextEditingController searchController = TextEditingController();

  _ListDishesState(this.dishKey);

  @override
  void initState() {
    super.initState();
    dbRef = FirebaseDatabase.instance.reference().child(dishKey);
  }

  void _applyFilters(String text) {
    if (!mounted) return; // Проверка, что виджет все еще в дереве
    setState(() {
      searchQuery = text.toLowerCase();
    });
  }

  @override
  void dispose() {
    // Очистка контроллера и освобождение ресурсов
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0E12),
      appBar: AppBar(
        title: isSearching
            ? TextField(
          controller: searchController,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Search...',
            hintStyle: TextStyle(color: Colors.white),
          ),
          onChanged: _applyFilters,
        )
            : Text(dishKey, style: const TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF120B0E),
        actions: <Widget>[
          IconButton(
            icon: Icon(isSearching ? Icons.cancel : Icons.search),
            onPressed: () {
              if (!mounted) return; // Проверка, что виджет все еще в дереве
              setState(() {
                isSearching = !isSearching;
                if (!isSearching) {
                  searchController.clear();
                  _applyFilters('');
                }
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              filtersDetailsWindow(
                context,
                glutenFree,
                lactoseFree,
                vegetarian,
                vegan,
                halal,
                    (gluten, lactose, veg, vegan, halalDish) {
                  if (!mounted) return; // Проверка, что виджет все еще в дереве
                  setState(() {
                    glutenFree = gluten;
                    lactoseFree = lactose;
                    vegetarian = veg;
                    halal = halalDish;
                    this.vegan = vegan;
                  });
                },
              );
            },
          ),
        ],
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder(
        stream: dbRef!.onValue,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (snapshot.hasData && snapshot.data!.snapshot.value != null) {
            Map<String, dynamic> dishes = Map<String, dynamic>.from(
              (snapshot.data!.snapshot.value as Map).cast<String, dynamic>(),
            );

            final filteredDishes = dishes.values.where((dish) {
              String dishName = dish['name'].toString().toLowerCase();
              return (!glutenFree || dish['Gluten'] == true) &&
                  (!lactoseFree || dish['Lactose'] == true) &&
                  (!vegetarian || dish['Vegetarian'] == true) &&
                  (!vegan || dish['Vegan'] == true) &&
                  (!halal || dish['Halal'] == true) &&
                  (dishName.contains(searchQuery));
            }).toList();

            if (filteredDishes.isEmpty) {
              return const Center(child: Text("No dishes match the selected criteria"));
            }

            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                childAspectRatio: 5 / 3,
              ),
              itemCount: filteredDishes.length,
              itemBuilder: (BuildContext context, int index) {
                final dish = filteredDishes[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListItem(
                    dish: dish,
                    dishKey: dishKey,
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text("No data available"));
          }
        },
      ),
    );
  }
}

class ListItem extends StatelessWidget {
  final Map dish;
  final String dishKey;

  const ListItem({required this.dish, required this.dishKey});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => Page_recept(
              dishName: dish['name'],
              dishtime: dish['time'],
              SSS: dishKey,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: const BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(2, 2),
                  blurRadius: 10,
                ),
              ],
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  padding: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    color: Colors.amber,
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
                    child: Image.network(
                      dish['image_url'].toString(),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.black.withOpacity(0.6),
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dish['name'] ?? '',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.bookmark_border,
                              color: Colors.white,
                              size: 15,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              '${dish['number_of_likes']}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Icon(
                              Icons.access_time,
                              color: Colors.white,
                              size: 15,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${dish['time']}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
