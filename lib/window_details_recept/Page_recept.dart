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
            Map<String, dynamic> data = Map<String, dynamic>.from(
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
                        data['image_url'].toString(),
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
                          data['time'],
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: InkWell(
                      onTap: () {
                        History_page(
                          context,
                          widget.dishName,
                          data['history'],
                        );
                      },
                      child: Icon(
                        Icons.history_edu,
                        color: Colors.orange,
                      ),
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
                  _buildIngredientRow(data, 'ingredient_1', 'quantity_1'),
                  _buildIngredientRow(data, 'ingredient_2', 'quantity_2'),
                  _buildIngredientRow(data, 'ingredient_3', 'quantity_3'),
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
                  _buildStep(data, '1_step'),
                  _buildStep(data, '2_step'),
                  _buildStep(data, '3_step'),
                  _buildStep(data, '4_step'),
                  _buildStep(data, '5_step'),
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

  Widget _buildIngredientRow(Map<String, dynamic> data, String ingredientKey, String quantityKey) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Text(data[ingredientKey]),
          SizedBox(width: 8),
          Text('________________________________________'),
          SizedBox(width: 8),
          Text(data[quantityKey]),
        ],
      ),
    );
  }

  Widget _buildStep(Map<String, dynamic> data, String stepKey) {
    if (data[stepKey].isNotEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(data[stepKey]),
      );
    } else {
      return SizedBox.shrink();
    }
  }
}
