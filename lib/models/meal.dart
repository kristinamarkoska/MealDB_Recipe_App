class Meal {
  final String id;
  final String name;
  final String image;

  Meal({required this.id, required this.name, required this.image});

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['idMeal'],
      name: json['strMeal'],
      image: json['strMealThumb'],
    );
  }
}

class MealDetail {
  final String id;
  final String name;
  final String image;
  final String instructions;
  final Map<String, String> ingredients;
  final String? youtubeLink;

  MealDetail({
    required this.id,
    required this.name,
    required this.image,
    required this.instructions,
    required this.ingredients,
    this.youtubeLink,
  });

  factory MealDetail.fromJson(Map<String, dynamic> json) {
    Map<String, String> ingredients = {};
    for (int i = 1; i <= 20; i++) {
      final ingredient = json['strIngredient$i'];
      final measure = json['strMeasure$i'];
      if (ingredient != null && ingredient != "" && measure != null && measure != "") {
        ingredients[ingredient] = measure;
      }
    }

    return MealDetail(
      id: json['idMeal'],
      name: json['strMeal'],
      image: json['strMealThumb'],
      instructions: json['strInstructions'],
      ingredients: ingredients,
      youtubeLink: json['strYoutube'],
    );
  }
}
