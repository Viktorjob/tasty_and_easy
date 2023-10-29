import 'package:flutter/material.dart';
import 'package:tasty_and_easy/data_filter/data_filters.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Filters extends StatefulWidget {
  final List<Map<String, dynamic>> allDishes;
  final Function(List<String>) onFilterApplied;

  Filters({required this.allDishes, required this.onFilterApplied});

  @override
  _FiltersState createState() => _FiltersState();
}

class _FiltersState extends State<Filters> {
  bool _glutenFreeFilterSet = false;
  bool _veganFilterSet = false;
  bool _lactoseFreeFilterSet = false;
  bool _vegetarianFilterSet = false;

  void onFilterChanged() {
    saveFilters();
    List<String> filters = [];
    if (_glutenFreeFilterSet) {
      filters.add('gluten');
    }
    if (_veganFilterSet) {
      filters.add('vegan');
    }
    if (_lactoseFreeFilterSet) {
      filters.add('lactose');
    }
    if (_vegetarianFilterSet) {
      filters.add('vegetarian');
    }
    widget.onFilterApplied(filters);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadFilters();
  }

  void loadFilters() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _glutenFreeFilterSet = prefs.getBool('glutenFreeFilter') ?? false;
      _veganFilterSet = prefs.getBool('veganFilter') ?? false;
      _lactoseFreeFilterSet = prefs.getBool('lactoseFreeFilter') ?? false;
      _vegetarianFilterSet = prefs.getBool('vegetarianFilter') ?? false;
    });
    onFilterChanged();
  }

  void saveFilters() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('glutenFreeFilter', _glutenFreeFilterSet);
    prefs.setBool('veganFilter', _veganFilterSet);
    prefs.setBool('lactoseFreeFilter', _lactoseFreeFilterSet);
    prefs.setBool('vegetarianFilter', _vegetarianFilterSet);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Filters"),
        backgroundColor: Colors.lightGreen,
      ),
      body: Column(
        children: [
          SwitchListTile(
            value: _glutenFreeFilterSet,
            onChanged: (isChecked) {
              setState(() {
                _glutenFreeFilterSet = isChecked;
                onFilterChanged();
              });
            },
            title: Text('Gluten-free'),
          ),
          SwitchListTile(
            value: _lactoseFreeFilterSet,
            onChanged: (isChecked) {
              setState(() {
                _lactoseFreeFilterSet = isChecked;
                onFilterChanged();
              });
            },
            title: Text('Lactose-free'),
          ),
          SwitchListTile(
            value: _vegetarianFilterSet,
            onChanged: (isChecked) {
              setState(() {
                _vegetarianFilterSet = isChecked;
                onFilterChanged();
              });
            },
            title: Text('Vegetarian'),
          ),
          SwitchListTile(
            value: _veganFilterSet,
            onChanged: (isChecked) {
              setState(() {
                _veganFilterSet = isChecked;
                onFilterChanged();
              });
            },
            title: Text('Vegan'),
          ),
        ],
      ),
    );
  }
}
