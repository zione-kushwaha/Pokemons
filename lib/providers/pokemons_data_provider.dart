import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:pp1/models/pokemon.dart';
import 'package:pp1/service/database_service.dart';
import 'package:pp1/service/http_service.dart';

final Pokemon_Data_Provider =
    FutureProvider.family<Pokemon?, String>((ref, url) async {
  HttpService _httpservice = GetIt.instance.get<HttpService>();
  Response response = await _httpservice.fetchData(url);
  if (response.statusCode == 200 && response.data != null) {
    return Pokemon.fromJson(response.data);
  }
  return null;
});

final favouritePokemonProvider =
    StateNotifierProvider<FavouritePokemons, List<String>>(
        (ref) => FavouritePokemons([]));

class FavouritePokemons extends StateNotifier<List<String>> {
  FavouritePokemons(super._state) {
    _setup();
  }

  final DatabaseService _databaseService =
      GetIt.instance.get<DatabaseService>();
  final String favourite_pokemons_key = 'favourite_pokemons';

  Future<void> _setup() async {
    List<String>? data = await _databaseService.getList(favourite_pokemons_key);
    state = data ?? [];
  }

  void addFavourite(String url) {
    state = [...state, url];
    _databaseService.saveList(favourite_pokemons_key, state);
  }

  void removeFavourite(String url) {
    state = state.where((element) => element != url).toList();
    _databaseService.saveList(favourite_pokemons_key, state);
  }
}
