import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/movie_provider.dart';
import '../widgets/movie_tile.dart';
import '../models/movie_model.dart';

class MoviesListScreen extends ConsumerStatefulWidget {
  const MoviesListScreen({super.key});

  @override
  MoviesListScreenState createState() => MoviesListScreenState();
}

class MoviesListScreenState extends ConsumerState<MoviesListScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<MovieModel> _allMovies = [];
  bool _isFetchingMore = false;

  // this will used for debouncing
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _scrollController.addListener(_onScroll);
  }

  // TODO:
  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _scrollController.removeListener(_onScroll);
    _searchController.dispose();
    _scrollController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer(const Duration(milliseconds: 300), () {
      setState(() {});
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent * 0.95 &&
        !_isFetchingMore) {
      setState(() {
        _isFetchingMore = true;
      });
      ref
          .read(movieListProvider.notifier)
          .fetchMovies(loadMore: true)
          .then((_) {
        setState(() {
          _isFetchingMore = false;
        });
      }).catchError((error) {
        setState(() {
          _isFetchingMore = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final movieListAsyncValue = ref.watch(movieListProvider);

    return Scaffold(
      appBar: _appBar(),
      body: movieListAsyncValue.when(
        data: (movies) {
          _allMovies = movies;
          if (movies.isEmpty) {
            return Center(
              child: Text(
                _searchController.text.isNotEmpty
                    ? 'No results found for "${_searchController.text}".'
                    : 'No movies available.',
                style: const TextStyle(fontSize: 18),
              ),
            );
          }

          final filtered = _allMovies.where((e) {
            if (_searchController.text.isEmpty) {
              return true;
            }
            return e.title
                .toLowerCase()
                .contains(_searchController.text.toLowerCase());
          }).toList();

          return CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: SliverGrid.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 7 / 8,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    return MovieTile(
                      movie: filtered[index],
                    );
                  },
                ),
              ),
              if (_isFetchingMore)
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: CupertinoActivityIndicator(),
                  ),
                ),
            ],
          );
        },
        loading: () => const Center(child: CupertinoActivityIndicator()),
        error: (error, stack) {
          debugPrint(error.toString());
          return const Center(child: Text('Failed to fetch movies.'));
        },
      ),
    );
  }

  AppBar _appBar() {
    return AppBar(
      surfaceTintColor: Colors.transparent,
      title: const Text('Trending Movies'),
      backgroundColor: Colors.white,
      elevation: 0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(56.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF787880).withOpacity(0.12),
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search',
                border: InputBorder.none,
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: const Color(0xFF3C3C43).withOpacity(0.6),
                  size: 30,
                ),
                hintStyle: TextStyle(
                  color: const Color(0xFF3C3C43).withOpacity(0.6),
                ),
              ),
              style: TextStyle(
                color: const Color(0xFF3C3C43).withOpacity(0.6),
                fontSize: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
