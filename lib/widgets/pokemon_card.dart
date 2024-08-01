import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../models/pokemon.dart';
import '../providers/pokemons_data_provider.dart';

class PokemonCard extends ConsumerWidget {
  PokemonCard({super.key, required this.url});
  final String url;
  late FavouritePokemons _favouritepokemonsProvider;

  Future<void> _showpokemonsdetails(
      BuildContext context, Pokemon? pokemon) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(pokemon?.name ?? 'Pokemon'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(pokemon?.sprites?.frontDefault ?? ''),
                Text('ID: ${pokemon?.id}'),
                Text('Name: ${pokemon?.name}'),
                Text('Height: ${pokemon?.height}'),
                Text('Weight: ${pokemon?.weight}'),
                Text('Base Stats:'),
                ...?pokemon?.stats?.map((stat) => Text(
                    '${stat.stat?.name}: ${stat.baseStat} (Effort: ${stat.effort})')),
                Text('Abilities:'),
                ...?pokemon?.abilities?.map((ability) => Text(
                    '${ability.ability?.name} (Hidden: ${ability.isHidden})')),
                Text('Moves:'),
                ...?pokemon?.moves?.map((move) => Text(move.move?.name ?? '')),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pokemon = ref.watch(Pokemon_Data_Provider(url));
    _favouritepokemonsProvider = ref.watch(favouritePokemonProvider.notifier);
    return pokemon.when(
      data: (pokemon) {
        return _card(context, pokemon, false);
      },
      loading: () {
        return _card(context, null, true);
      },
      error: (error, stack) {
        return const Center(
          child: Text('Error'),
        );
      },
    );
  }

  Widget _card(BuildContext context, Pokemon? pokemon, bool isloading) {
    return Skeletonizer(
      enabled: isloading,
      child: GestureDetector(
        onTap: () async {
          _showpokemonsdetails(context, pokemon);
        },
        child: Card(
          child: Column(
            children: [
              Text('${pokemon?.name}       #${pokemon?.id}' ?? 'Pokemon #',
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.bold)),
              Image.network(pokemon?.sprites?.frontDefault ?? ''),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('${pokemon?.moves?.length} moves'),
                  InkWell(
                    onTap: () {
                      if (_favouritepokemonsProvider.state.contains(url)) {
                        _favouritepokemonsProvider.removeFavourite(url);
                      }
                    },
                    child: Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
