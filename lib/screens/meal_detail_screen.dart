import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../services/api_service.dart';
import 'package:url_launcher/url_launcher.dart';

class MealDetailScreen extends StatefulWidget {
  final String mealId;
  MealDetailScreen({required this.mealId});

  @override
  _MealDetailScreenState createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  late Future<MealDetail> _mealDetail;

  @override
  void initState() {
    super.initState();
    _mealDetail = ApiService.getMealDetail(widget.mealId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Meal Detail')),
      body: FutureBuilder<MealDetail>(
        future: _mealDetail,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final meal = snapshot.data!;
            return SingleChildScrollView(
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(meal.image),
                  SizedBox(height: 8),
                  Text(meal.name,
                      style:
                      TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('Ingredients:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  ...meal.ingredients.entries
                      .map((e) => Text('${e.key} - ${e.value}')),
                  SizedBox(height: 8),
                  Text('Instructions:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(meal.instructions),
                  if (meal.youtubeLink != null && meal.youtubeLink != '')
                    TextButton.icon(
                      onPressed: () async {
                        final url = Uri.parse(meal.youtubeLink!);
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url);
                        }
                      },
                      icon: Icon(Icons.play_circle_fill),
                      label: Text('Watch on YouTube'),
                    ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
