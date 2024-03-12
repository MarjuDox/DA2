import 'package:bloc/bloc.dart';
import 'package:diabetes/core/repo/get_search_results.dart';
import 'package:diabetes/model/food/failure.dart';
import 'package:diabetes/model/food/search_result.dart';
import 'package:equatable/equatable.dart';

part 'search_results_event.dart';
part 'search_results_state.dart';

class SearchResultsBloc extends Bloc<SearchResultsEvent, SearchResultsState> {
  final repo = SearchRepo();
  SearchResultsBloc() : super(SearchResultsInitial()) {
    on<SearchResultsEvent>((event, emit) async {
      if (event is LoadSearchResults) {
        try {
          emit(SearchResultsLoading());
          final results = await repo.getSearchList(event.name, 100);
          emit(SearchResultsSuccess(
            results: results.list,
          ));
        } on Failure catch (e) {
          emit(HomeFailureState(error: e));
        } catch (e) {
          print(e.toString());
          emit(SearchResultsError());
        }
      }
    });
  }
}
