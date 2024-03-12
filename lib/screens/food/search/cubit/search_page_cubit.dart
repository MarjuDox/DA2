// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:diabetes/core/repo/get_search_results.dart';
import 'package:diabetes/model/food/auto_complete.dart';
import 'package:equatable/equatable.dart';

part 'search_page_state.dart';

class SearchPageCubit extends Cubit<SearchPageState> {
  SearchPageCubit() : super(SearchPageState.initial());
  final repo = SearchRepo();
  void textChange(String text) async {
    emit(state.copyWith(status: Status.loading, searchText: text));
    final list = await repo.getAutoCompleteList(text);
    emit(state.copyWith(status: Status.success, searchList: list.list));
  }
}