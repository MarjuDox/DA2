// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:diabetes/core/repo/get_random_recipe.dart';
import 'package:diabetes/model/food/equipments.dart';
import 'package:diabetes/model/food/failure.dart';
import 'package:diabetes/model/food/nutrients.dart';
import 'package:diabetes/model/food/recipe.dart';
import 'package:diabetes/model/food/similar_list.dart';
import 'package:flutter/material.dart';

part 'random_recipe_event.dart';
part 'random_recipe_state.dart';

class RandomRecipeBloc extends Bloc<RandomRecipeEvent, RandomRecipeState> {
  final GetRandomRecipe repo = GetRandomRecipe();
  RandomRecipeBloc() : super(RandomRecipeInitial()) {
    // ignore: void_checks
    on<RandomRecipeEvent>((event, emit) async {
      if (event is LoadRandomRecipe) {
        try {
          emit(RandomRecipeLoadState());
          final data = await repo.getRecipe();
          emit(
            RandomRecipeSuccesState(
              recipe: data[0],
              nutrient: data[3],
              similar: data[1].list,
              equipment: data[2].items,
            ),
          );
        } on Failure catch (e) {
          emit(FailureState(error: e));
        } catch (e) {
          print(e.toString());
          emit(RandomRecipeErrorState());
        }
      }
    });
  }
}