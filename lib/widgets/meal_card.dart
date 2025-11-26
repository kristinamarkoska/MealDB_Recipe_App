import 'package:flutter/material.dart';
import '../models/meal.dart';

class MealCard extends StatelessWidget {
  final Meal meal;
  final VoidCallback onTap;

  MealCard({required this.meal, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        child: Column(
          children: [
            Image.network(meal.image, height: 100, fit: BoxFit.cover),
            SizedBox(height: 8),
            Text(meal.name,
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
