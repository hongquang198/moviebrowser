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
    final Color globalTextColor = Colors.amberAccent;
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => di.sl<MoviesBloc>()),
        BlocProvider(create: (_) => di.sl<SearchBloc>()),
        BlocProvider(create: (_) => di.sl<FavoritesBloc>()),
      ],
      child: MaterialApp(
        title: 'Movie Browser',
        theme: ThemeData(
          scaffoldBackgroundColor: const Color(0xFF1B1B1B),
          primaryColor: Colors.white, 
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF1B1B1B),
            elevation: 0, // Optional: removes the shadow under the app bar
        ),
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
          textTheme: TextTheme(
            // Apply the style to all body text variants
            bodyLarge: TextStyle(color: globalTextColor),
            bodyMedium: TextStyle(color: globalTextColor),
            bodySmall: TextStyle(color: globalTextColor),
            
            // Apply to all display/headline variants
            displayLarge: TextStyle(color: globalTextColor),
            displayMedium: TextStyle(color: globalTextColor),
            displaySmall: TextStyle(color: globalTextColor),
            
            // Apply to all title/label variants
            titleLarge: TextStyle(color: globalTextColor),
            titleMedium: TextStyle(color: globalTextColor),
            titleSmall: TextStyle(color: globalTextColor),
            
            // Apply to button labels
            labelLarge: TextStyle(color: globalTextColor),
          ),
        ),
        home: const HomePage(),
      ),
    );
  }
}
