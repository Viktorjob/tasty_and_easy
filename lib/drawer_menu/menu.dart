import 'package:flutter/material.dart';
import 'package:tasty_and_easy/filters/window_filters.dart';

class SecondMenuDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[

          Padding(
            padding: EdgeInsets.only(top: 150.0),
            child: ListTile(
              leading: Icon(Icons.filter),
              title: Text('Filters'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Filters(onFilterApplied: ( List <String> filters ) {  }, allDishes: [],),
                  ),
                );
              },
            ),
          ),


        ],
      ),
    );
  }
}
