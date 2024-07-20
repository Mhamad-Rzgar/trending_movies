import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/movie_provider.dart';
import '../widgets/movie_tile.dart';

class MoviesListScreen extends ConsumerStatefulWidget {
  const MoviesListScreen({super.key});

  @override
  MoviesListScreenState createState() => MoviesListScreenState();
}

class MoviesListScreenState extends ConsumerState<MoviesListScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isFetchingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  // TODO: dispose required
  // TODO: complete search functionality

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
      // TODO: add AppBar with searchField
      body: movieListAsyncValue.when(
        data: (movies) {
          if (movies.isEmpty) {
            return const Center(
              child: Text(
                'No movies available.',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          // TODO: using CustomScrollView to prepare adding on scroll pagination
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
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    return MovieTile(
                      movie: movies[index],
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
}
