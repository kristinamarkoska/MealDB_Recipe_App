import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../services/api_service.dart';
import '../widgets/meal_card.dart';
import 'meal_detail_screen.dart';

class CategoryMealsScreen extends StatefulWidget {
  final String categoryName;
  CategoryMealsScreen({required this.categoryName});

  @override
  _CategoryMealsScreenState createState() => _CategoryMealsScreenState();
}

class _CategoryMealsScreenState extends State<CategoryMealsScreen> {
  late Future<List<Meal>> _meals;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _meals = ApiService.getMealsByCategory(widget.categoryName);
  }

  void _searchMeals(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      _meals = ApiService.searchMeals(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.categoryName)),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search meals...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: _searchMeals,
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Meal>>(
              future: _meals,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No meals found.'));
                } else {
                  final meals = snapshot.data!;
                  return GridView.builder(
                    padding: EdgeInsets.all(8),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, childAspectRatio: 0.8),
                    itemCount: meals.length,
                    itemBuilder: (context, index) {
                      return MealCard(
                        meal: meals[index],
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  MealDetailScreen(mealId: meals[index].id),
                            ),
                          );
                        },
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
