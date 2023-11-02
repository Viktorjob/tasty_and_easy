import 'package:flutter/material.dart';

typedef OnFilterChangedCallback = void Function(bool glutenFree, bool lactoseFree, bool vegetarian, bool vegan);
void filtrs_details_window(BuildContext context, bool glutenFree, bool lactoseFree, bool vegetarian, bool vegan, OnFilterChangedCallback onFilterChanged) {
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
                    title: Text('Gluten-free'),
                  ),
                  SwitchListTile(
                    value: lactoseFree,
                    onChanged: (isChecked) {
                      setState(() {
                        lactoseFree = isChecked;
                      });
                    },
                    title: Text('Lactose-free'),
                  ),
                  SwitchListTile(
                    value: vegetarian,
                    onChanged: (isChecked) {
                      setState(() {
                        vegetarian = isChecked;
                      });
                    },
                    title: Text('Vegetarian'),
                  ),
                  SwitchListTile(
                    value: vegan,
                    onChanged: (isChecked) {
                      setState(() {
                        vegan = isChecked;
                      });
                    },
                    title: Text('Vegan'),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onFilterChanged(glutenFree, lactoseFree, vegetarian, vegan);
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

