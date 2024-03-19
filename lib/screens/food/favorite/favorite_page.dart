import 'package:diabetes/core/common_widget/base_screen.dart';
import 'package:diabetes/core/const/text_constants.dart';
import 'package:diabetes/core/extension/context_extension.dart';
import 'package:diabetes/model/food/food_type.dart';
import 'package:diabetes/model/food/list_item.dart';
import 'package:diabetes/model/food/recipe.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: const Text(
            TextConstants.favoriteFood,
          ),
        ),
        body: BaseScreen(
          child: ValueListenableBuilder<Box>(
              valueListenable: Hive.box('Favorite').listenable(),
              builder: (context, box, child) {
                if (box.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          CupertinoIcons.heart_fill,
                          size: 105,
                          color: Colors.grey,
                        ),
                        SizedBox(
                          width: 250,
                          child: Text(
                            "You don't have any Favorite recipe yet.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.separated(
                    padding: const EdgeInsets.all(16),
                    separatorBuilder: (context, index) => const SizedBox(
                          height: 16,
                        ),
                    itemBuilder: (context, i) {
                      final info = box.getAt(i);
                      final data = Recipe.fromJson(info);

                      return ListItem(
                        meal: FoodType(
                          id: data.id.toString(),
                          image: data.image!,
                          name: data.title!,
                          readyInMinutes: data.readyInMinutes.toString(),
                          servings: data.servings.toString(),
                        ),
                      );
                    },
                    itemCount: box.length);
              }),
        ),
      ),
    );
  }
}
