import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:pp1/service/http_service.dart';

import '../models/page_data.dart';
import '../models/pokemon.dart';

class HomePageController extends StateNotifier<HomePageData> {
  HomePageController() : super(HomePageData.initial()) {
    _httpService = _getIt.get<HttpService>();
    _setup();
  }

  final GetIt _getIt = GetIt.instance;
  late HttpService _httpService;

  Future<void> _setup() async {
    loadData();
  }

  Future<void> loadData() async {
    try {
      if (state.data == null) {
        final response = await _httpService
            .fetchData('https://pokeapi.co/api/v2/pokemon?limit=20&offset=0');

        if (response.statusCode == 200) {
          final pokemonListData = PokemonListData.fromJson(response.data);
          state = state.copyWith(data: pokemonListData);
          print(response.data);
        }
      } else {
        if (state.data!.next != null) {
          final response = await _httpService.fetchData(state.data!.next!);
          if (response.statusCode == 200) {
            final pokemonListData = PokemonListData.fromJson(response.data);
            state = state.copyWith(
                data: pokemonListData.copyWith(results: [
              ...?state.data!.results,
              ...?pokemonListData.results
            ]));
            print(response.data);
          }
        }
      }
    } catch (e) {
      print(e);
    }
  }
}
