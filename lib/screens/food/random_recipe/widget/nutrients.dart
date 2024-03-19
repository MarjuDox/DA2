import 'package:diabetes/core/extension/context_extension.dart';
import 'package:diabetes/model/food/nutrients.dart';
import 'package:diabetes/screens/food/random_recipe/widget/expandable.dart';
import 'package:flutter/material.dart';

class NutrientsWidgets extends StatelessWidget {
  final Nutrient nutrient;

  const NutrientsWidgets({Key? key, required this.nutrient}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ExpandableGroup(
        isExpanded: false,
        collapsedIcon: const Icon(Icons.chevron_left),
        header: const Text(
          "Nutrients",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        items: [
          item(
              icon: Icons.fireplace,
              title: "Calories",
              value: nutrient.calories),
          item(icon: Icons.face_outlined, title: "Fat", value: nutrient.fat),
          item(
              icon: Icons.bakery_dining,
              title: "Carbohydrates",
              value: nutrient.carbs),
          item(
              icon: Icons.bolt_outlined,
              title: "Protein",
              value: nutrient.protein),
        ],
      ),
    );
  }

  ListTile item(
      {required IconData icon, required String title, required String value}) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 16),
      leading: LayoutBuilder(builder: (context, constraint) {
        return Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: context.colorScheme.secondary.withOpacity(0.05),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: constraint.maxWidth * 0.1,
            color: context.colorScheme.primary,
          ),
        );
      }),
      title: Text(
        title,
      ),
      trailing: Text(
        value,
        style: const TextStyle(
            fontSize: 16, color: Colors.green, fontWeight: FontWeight.w500),
      ),
    );
  }
}

class NutrientsbadWidget extends StatelessWidget {
  final Nutrient nutrient;

  const NutrientsbadWidget({Key? key, required this.nutrient})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ExpandableGroup(
        isExpanded: false,
        collapsedIcon: const Icon(Icons.chevron_left),
        header: const Text(
          "Bad for health Nutrients.",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        items: [
          ...nutrient.bad.map((nutri) {
            return ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
              subtitle: Text("${nutri.percentOfDailyNeeds}% of Daily needs."),
              title: Text(
                nutri.name.toString(),
              ),
              trailing: Text(
                nutri.amount,
                style: const TextStyle(
                    fontSize: 16,
                    color: Colors.green,
                    fontWeight: FontWeight.w500),
              ),
            );
          }).toList()
        ],
      ),
    );
  }
}

class NutrientsgoodWidget extends StatelessWidget {
  final Nutrient nutrient;

  const NutrientsgoodWidget({Key? key, required this.nutrient})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ExpandableGroup(
        isExpanded: false,
        collapsedIcon: const Icon(Icons.chevron_left),
        header: const Text(
          "good for health Nutrients.",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        items: [
          ...nutrient.good.map((nutri) {
            return ListTile(
              contentPadding: const EdgeInsets.symmetric(vertical: 10),
              subtitle: Text("${nutri.percentOfDailyNeeds}% of Daily needs."),
              title: Text(
                nutri.name.toString(),
              ),
              trailing: Text(
                nutri.amount,
                style: const TextStyle(
                    fontSize: 16,
                    color: Colors.green,
                    fontWeight: FontWeight.w500),
              ),
            );
          }).toList()
        ],
      ),
    );
  }
}
