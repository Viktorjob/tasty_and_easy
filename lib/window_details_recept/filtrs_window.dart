import 'package:flutter/material.dart';

typedef OnFilterChangedCallback = void Function(bool glutenFree, bool lactoseFree, bool vegetarian, bool vegan, bool halal);
void filtrs_details_window(BuildContext context, bool glutenFree, bool lactoseFree, bool vegetarian, bool vegan, bool halal,  OnFilterChangedCallback onFilterChanged) {
  showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return AlertDialog(
            title: Text('Filters'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  SwitchListTile(
                    value: glutenFree,
                    onChanged: (isChecked) {
                      setState(() {
                        glutenFree = isChecked;
                      });
                    },
                    title: Text('Gluten free'),
                  ),
                  SwitchListTile(
                    value: lactoseFree,
                    onChanged: (isChecked) {
                      setState(() {
                        lactoseFree = isChecked;
                      });
                    },
                    title: Text('Lactose free'),
                  ),
                  SwitchListTile(
                    value: vegetarian,
                    onChanged: (isChecked) {
                      setState(() {
                        vegetarian = isChecked;
                      });
                    },
                    title: Text('Vegetarian dishes'),
                  ),
                  SwitchListTile(
                    value: vegan,
                    onChanged: (isChecked) {
                      setState(() {
                        vegan = isChecked;
                      });
                    },
                    title: Text('Vegan dishes'),
                  ),
                  SwitchListTile(
                    value: halal,
                    onChanged: (isChecked) {
                      setState(() {
                        halal = isChecked;
                      });
                    },
                    title: Text('Halal dishes'),
                  ),


                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onFilterChanged(glutenFree, lactoseFree, vegetarian, vegan, halal );
                },
                child: Text('Apply'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close'),
              ),
            ],
          );
        },
      );
    },
  );
}

