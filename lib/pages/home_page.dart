import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pp1/widgets/pokemon_card.dart';
import 'package:pp1/widgets/pokemons_list_tile.dart';

import '../controller/home_page_controller.dart';
import '../models/page_data.dart';
import '../providers/pokemons_data_provider.dart';

final _homePageControllerProvider =
    StateNotifierProvider<HomePageController, HomePageData>((ref) {
  return HomePageController();
});

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final ScrollController _scrollController = ScrollController();
  late List<String> _favouritePokemons;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent * 1 &&
        !_scrollController.position.outOfRange) {
      HomePageController homePageController =
          ref.read(_homePageControllerProvider.notifier);
      homePageController.loadData();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final homePageData = ref.watch(_homePageControllerProvider);
    _favouritePokemons = ref.watch(favouritePokemonProvider);
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _favourite_pokemons_list(context, _favouritePokemons),
            _buildUI(context, homePageData),
          ],
        ),
      ),
    );
  }

  Widget _favourite_pokemons_list(
      BuildContext context, List<String> favouritePokemons) {
    return Container(
      height: 250,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Favourite Pokemons',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          favouritePokemons.isEmpty
              ? Center(
                  child: Text('Empty Favourite'),
                )
              : Expanded(
                  child: GridView.builder(
                      // scrollDirection: Axis.horizontal,
                      itemCount: favouritePokemons.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2),
                      itemBuilder: (context, index) {
                        return PokemonCard(url: favouritePokemons[index]);
                      }),
                )
        ],
      ),
    );
  }

  Widget _buildUI(BuildContext context, HomePageData homePageData) {
    return SafeArea(
        child: SingleChildScrollView(
      child: Container(
        height: 500,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Text(
              ' All Pokemons',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                  controller: _scrollController,
                  itemCount: homePageData.data?.results?.length ?? 0,
                  itemBuilder: (context, index) {
                    final data = homePageData.data?.results?[index];
                    return PokemonsListTile(url: data?.url ?? '');
                  }),
            ),
          ],
        ),
      ),
    ));
  }
}
