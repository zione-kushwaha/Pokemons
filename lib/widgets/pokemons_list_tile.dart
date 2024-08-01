import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pp1/models/pokemon.dart';
import 'package:pp1/providers/pokemons_data_provider.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:pp1/providers/pokemons_data_provider.dart';

class PokemonsListTile extends ConsumerWidget {
  PokemonsListTile({super.key, required this.url});

  late FavouritePokemons _favouritepokemonsProvider;
  late List<String> _favouritepokemons;

  final String url;
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
    _favouritepokemonsProvider = ref.watch(favouritePokemonProvider.notifier);

    _favouritepokemons = ref.watch(favouritePokemonProvider);
    final pokemonData = ref.watch(Pokemon_Data_Provider(url));

    return pokemonData.when(
      data: (pokemon) {
        return _tile(context, pokemon, false);
      },
      loading: () {
        return _tile(context, null, true);
      },
      error: (error, stack) {
        return const Center(
          child: Text('Error'),
        );
      },
    );
  }

  Widget _tile(BuildContext context, Pokemon? pokemon, bool isloading) {
    return Skeletonizer(
      enabled: isloading,
      child: ListTile(
        onTap: () {
          _showpokemonsdetails(context, pokemon);
        },
        leading: pokemon != null
            ? CircleAvatar(
                backgroundImage: NetworkImage(pokemon.sprites!.frontDefault!),
              )
            : const CircleAvatar(),
        title: Text(
          pokemon?.name ?? 'Pokemon data is currently loading',
          style: const TextStyle(fontSize: 20),
        ),
        subtitle: Text(
          'Has ${pokemon?.moves?.length ?? 0} moves',
          style: const TextStyle(fontSize: 14),
        ),
        trailing: IconButton(
          onPressed: () {
            if (_favouritepokemons.contains(url)) {
              _favouritepokemonsProvider.removeFavourite(url);
            } else {
              _favouritepokemonsProvider.addFavourite(url);
            }
          },
          icon: Icon(_favouritepokemons.contains(url)
              ? Icons.favorite
              : Icons.favorite_border),
          color: Colors.red,
        ),
      ),
    );
  }
}
