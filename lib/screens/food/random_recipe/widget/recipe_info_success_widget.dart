import 'package:diabetes/core/animation/animation.dart';
import 'package:diabetes/core/extension/context_extension.dart';
import 'package:diabetes/model/food/equipments.dart';
import 'package:diabetes/model/food/nutrients.dart';
import 'package:diabetes/model/food/recipe.dart';
import 'package:diabetes/model/food/similar_list.dart';
import 'package:diabetes/screens/common_widget/card_x.dart';
import 'package:diabetes/screens/food/random_recipe/widget/appbar.dart';
import 'package:diabetes/screens/food/random_recipe/widget/equipment.dart';
import 'package:diabetes/screens/food/random_recipe/widget/ingredients.dart';
import 'package:diabetes/screens/food/random_recipe/widget/nutrients.dart';
import 'package:diabetes/screens/food/random_recipe/widget/similar_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';

class RecipeInfoWidget extends StatefulWidget {
  final Recipe info;
  final List<Similar> similarlist;
  final List<Equipment> equipment;
  final Nutrient nutrient;

  const RecipeInfoWidget({
    Key? key,
    required this.info,
    required this.similarlist,
    required this.equipment,
    required this.nutrient,
  }) : super(key: key);

  @override
  State<RecipeInfoWidget> createState() => _RecipeInfoWidgetState();
}

class _RecipeInfoWidgetState extends State<RecipeInfoWidget> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverPersistentHeader(
          delegate: MySliverAppBar(expandedHeight: 300, info: widget.info),
          pinned: true,
        ),
        SliverToBoxAdapter(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(
                        height: 16,
                      ),
                      DelayedDisplay(
                        delay: const Duration(microseconds: 600),
                        child: Text(
                          widget.info.title!,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      DelayedDisplay(
                        delay: const Duration(microseconds: 700),
                        child: CardX(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Column(
                                  children: [
                                    Text("${widget.info.readyInMinutes} Min",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18)),
                                    Text(
                                      "Ready in",
                                      style: TextStyle(
                                        color: context.colorScheme.secondary
                                            .withOpacity(0.6),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 30,
                                width: 1,
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.1),
                              ),
                              Expanded(
                                flex: 1,
                                child: Column(
                                  children: [
                                    Text(widget.info.servings.toString(),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18)),
                                    Text(
                                      "Servings",
                                      style: TextStyle(
                                        color: context.colorScheme.secondary
                                            .withOpacity(0.6),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                height: 30,
                                width: 1,
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.1),
                              ),
                              Expanded(
                                flex: 1,
                                child: Column(
                                  children: [
                                    Text(widget.info.pricePerServing.toString(),
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18)),
                                    Text("Price/Servings",
                                        style: TextStyle(
                                          color: context.colorScheme.secondary
                                              .withOpacity(0.6),
                                        ))
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 22,
                      ),
                      const DelayedDisplay(
                        delay: Duration(microseconds: 700),
                        child: Text(
                          "Ingredients",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ),
                if (widget.info.extendedIngredients!.isNotEmpty)
                  DelayedDisplay(
                    delay: const Duration(microseconds: 600),
                    child: IngredientsWidget(
                      recipe: widget.info,
                    ),
                  ),
                if (widget.info.instructions != null)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Instructions",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Html(
                          data: widget.info.instructions,
                          style: {
                            'p': Style(
                              fontSize: FontSize.large,
                              color: Colors.black,
                            ),
                          },
                        ),
                      ],
                    ),
                  ),
                if (widget.equipment.isNotEmpty)
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      "Equipments",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                if (widget.equipment.isNotEmpty)
                  EquipmentsListView(
                    equipments: widget.equipment,
                  ),
                if (widget.info.summary != null)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Quick summary",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Html(
                          data: widget.info.summary,
                        ),
                      ],
                    ),
                  ),
                NutrientsWidgets(
                  nutrient: widget.nutrient,
                ),
                NutrientsbadWidget(
                  nutrient: widget.nutrient,
                ),
                NutrientsgoodWidget(
                  nutrient: widget.nutrient,
                ),
                const SizedBox(
                  height: 16,
                ),
                if (widget.similarlist.isNotEmpty)
                  const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
                    child: Text("Similar items",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                  ),
                if (widget.similarlist.isNotEmpty)
                  SimilarListWidget(items: widget.similarlist),
                const SizedBox(
                  height: 40,
                ),
              ]),
        )
      ],
    );
  }
}
