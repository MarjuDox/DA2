import 'package:diabetes/screens/common_widget/diabetes_loading.dart';
import 'package:diabetes/screens/food/random_recipe/widget/recipe_info_success_widget.dart';
import 'package:diabetes/screens/food/recipe_infor/bloc/recipe_infor_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RecipeInfo extends StatefulWidget {
  final String id;
  const RecipeInfo({Key? key, required this.id}) : super(key: key);

  @override
  State<RecipeInfo> createState() => _RecipeInfoState();
}

class _RecipeInfoState extends State<RecipeInfo> {
  late final RecipeInfoBloc bloc;
  @override
  void initState() {
    bloc = BlocProvider.of<RecipeInfoBloc>(context);
    bloc.add(LoadRecipeInfo(widget.id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocBuilder<RecipeInfoBloc, RecipeInfoState>(
          builder: (context, state) {
            if (state is RecipeInfoLoadState) {
              return const Center(child: DiabetesLoading());
            } else if (state is RecipeInfoSuccesState) {
              return RecipeInfoWidget(
                equipment: state.equipment,
                info: state.recipe,
                nutrient: state.nutrient,
                similarlist: state.similar,
              );
              //return const SizedBox();
            } else if (state is RecipeInfoErrorState) {
              return Center(
                child: Container(
                  child: const Text("Error"),
                ),
              );
            } else {
              return Center(
                child: Container(
                  child: const Text("Noting happingng"),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
