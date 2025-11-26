import 'package:flutter/material.dart';
import '../models/category.dart';
import '../services/api_service.dart';
import '../widgets/category_card.dart';
import 'category_meals_screen.dart';
import 'meal_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Category>> _categories;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _categories = ApiService.getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meal Categories'),
        actions: [
          IconButton(
            icon: Icon(Icons.casino),
            onPressed: () async {
              final randomMeal = await ApiService.getRandomMeal();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MealDetailScreen(mealId: randomMeal.id),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search category...',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (val) {
                setState(() {
                  searchQuery = val.toLowerCase();
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Category>>(
              future: _categories,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final categories = snapshot.data!
                      .where((c) =>
                      c.name.toLowerCase().contains(searchQuery))
                      .toList();
                  return GridView.builder(
                    padding: EdgeInsets.all(8),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, childAspectRatio: 0.8),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      return CategoryCard(
                        category: categories[index],
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CategoryMealsScreen(
                                  categoryName: categories[index].name),
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