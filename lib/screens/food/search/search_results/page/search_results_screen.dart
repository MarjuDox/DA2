import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:diabetes/core/common_widget/base_screen.dart';
import 'package:diabetes/core/extension/context_extension.dart';
import 'package:diabetes/model/food/search_result.dart';
import 'package:diabetes/screens/common_widget/card_x.dart';
import 'package:diabetes/screens/common_widget/diabetes_loading.dart';
import 'package:diabetes/screens/food/recipe_infor/bloc/recipe_infor_bloc.dart';
import 'package:diabetes/screens/food/recipe_infor/page/recipe_infor_screen.dart';
import 'package:diabetes/screens/food/search/search_results/bloc/search_results_bloc.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class SearchResults extends StatefulWidget {
  final String id;
  const SearchResults({Key? key, required this.id}) : super(key: key);

  @override
  State<SearchResults> createState() => _SearchResultsState();
}

class _SearchResultsState extends State<SearchResults> {
  late final SearchResultsBloc bloc;
  @override
  void initState() {
    bloc = BlocProvider.of<SearchResultsBloc>(context);
    bloc.add(LoadSearchResults(name: widget.id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1.0)),
        child: Scaffold(
          backgroundColor: context.colorScheme.surfaceVariant.withOpacity(0.1),
          appBar: AppBar(
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.black),
            title: Text(
              "All your search result",
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          body: BlocBuilder<SearchResultsBloc, SearchResultsState>(
            builder: (context, state) {
              if (state is SearchResultsLoading) {
                return const Center(child: DiabetesLoading());
              } else if (state is SearchResultsSuccess) {
                return SafeArea(
                    child: BaseScreen(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: GridView(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 10 / 11,
                      ),
                      physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      children: [
                        ...state.results.map((result) {
                          return SearchResultItem(
                            result: result,
                          );
                        }).toList()
                      ],
                    ),
                  ),
                ));
              } else if (state is SearchResultsError) {
                return const Center(
                  child: Text("Error"),
                );
              } else {
                return const Center(
                  child: Text("Noting happingng"),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class SearchResultItem extends StatefulWidget {
  final SearchResult result;
  const SearchResultItem({
    Key? key,
    required this.result,
  }) : super(key: key);

  @override
  _SearchResultresulttate createState() => _SearchResultresulttate();
}

class _SearchResultresulttate extends State<SearchResultItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CardX(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (context) => RecipeInfoBloc(),
                child: RecipeInfo(
                  id: widget.result.id,
                ),
              ),
            ),
          );
        },
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 3 / 2,
              child: CachedNetworkImage(
                imageUrl: widget.result.image,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(9),
              child: Text(
                widget.result.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
