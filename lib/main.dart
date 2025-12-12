import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'injection_container.dart' as di;
import 'features/movies/presentation/pages/home_page.dart';
import 'features/movies/presentation/bloc/movies_bloc.dart';
import 'features/search/presentation/bloc/search_bloc.dart';
import 'features/favorites/presentation/bloc/favorites_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie Browser',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => di.sl<MoviesBloc>()),
          BlocProvider(create: (_) => di.sl<SearchBloc>()),
          BlocProvider(create: (_) => di.sl<FavoritesBloc>()),
        ],
        child: const HomePage(),
      ),
    );
  }
}
