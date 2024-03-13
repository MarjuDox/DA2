// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:diabetes/core/repo/get_recipes_infor.dart';
import 'package:diabetes/model/food/equipments.dart';
import 'package:diabetes/model/food/failure.dart';
import 'package:diabetes/model/food/nutrients.dart';
import 'package:diabetes/model/food/recipe.dart';
import 'package:diabetes/model/food/similar_list.dart';
import 'package:meta/meta.dart';

part 'recipe_infor_event.dart';
part 'recipe_infor_state.dart';

class RecipeInfoBloc extends Bloc<RecipeInfoEvent, RecipeInfoState> {
  final GetRecipeInfo repo = GetRecipeInfo();

  RecipeInfoBloc() : super(RecipeInfoInitial()) {
    on<RecipeInfoEvent>((event, emit) async {
      if (event is LoadRecipeInfo) {
        try {
          emit(RecipeInfoLoadState());
          final data = await repo.getRecipeInfo(event.id);
          emit(
            RecipeInfoSuccesState(
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
          emit(RecipeInfoErrorState());
        }
      }
    });
  }
}
