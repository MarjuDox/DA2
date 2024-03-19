import 'package:cached_network_image/cached_network_image.dart';
import 'package:diabetes/model/food/similar_list.dart';
import 'package:diabetes/screens/common_widget/card_x.dart';
import 'package:diabetes/screens/food/recipe_infor/bloc/recipe_infor_bloc.dart';
import 'package:diabetes/screens/food/recipe_infor/page/recipe_infor_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SimilarListWidget extends StatelessWidget {
  final List<Similar> items;

  const SimilarListWidget({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        physics: const BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        itemBuilder: (context, index) => RecipeCardWidget(items: items[index]),
        separatorBuilder: (context, index) => const SizedBox(width: 16),
      ),
    );
  }
}

class RecipeCardWidget extends StatefulWidget {
  const RecipeCardWidget({
    Key? key,
    required this.items,
  }) : super(key: key);

  final Similar items;

  @override
  _RecipeCardWidgetState createState() => _RecipeCardWidgetState();
}

class _RecipeCardWidgetState extends State<RecipeCardWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: CardX(
        padding: EdgeInsets.zero,
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => BlocProvider(
                    create: (context) => RecipeInfoBloc(),
                    child: RecipeInfo(
                      id: widget.items.id,
                    ),
                  )));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              child: Container(
                foregroundDecoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                ),
                width: double.infinity,
                child: CachedNetworkImage(
                  imageUrl: widget.items.image,
                  fit: BoxFit.cover,
                  width: 200,
                  height: 150,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                widget.items.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Text(
                "Ready in ${widget.items.readyInMinutes} Min",
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
