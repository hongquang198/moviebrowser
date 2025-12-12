# Movie Browser

A Flutter application for browsing movies using The Movie Database (TMDB) API, built with Clean Architecture and BLoC pattern, getIt as dependency injection.

## Architecture

This app follows **Clean Architecture** principles with clear separation of concerns:

### Domain Layer
- **Entities**: Core business objects (Movie)
- **Use Cases**: Business logic operations (GetPopularMovies, SearchMovies, etc.)
- **Repository Interfaces**: Abstract contracts for data operations

### Data Layer
- **Models**: Data transfer objects that extend entities
- **Data Sources**: Remote (API) and Local (SharedPreferences) data sources
- **Repository Implementations**: Concrete implementations using dartz for error handling

### Presentation Layer
- **BLoC**: State management using flutter_bloc
- **Pages**: UI screens (Home, Search, Movie Detail)
- **Widgets**: Reusable UI components

### Key Features

✅ **Clean Architecture** - Separation of concerns with Domain, Data, and Presentation layers  
✅ **BLoC Pattern** - Reactive state management  
✅ **Error Handling** - Using dartz Either type for functional error handling  
✅ **Offline Support** - Cached movies available when offline  
✅ **Favorites** - Local storage of favorite movies with carousel display  
✅ **Smooth Animations** - Fade-in, scale, and slide animations throughout  
✅ **Search** - Real-time movie search with autocomplete support  
✅ **Video Playback** - YouTube trailer integration  
✅ **Unit Tests** - Comprehensive test coverage for use cases and BLoC

## Setup Instructions

### Prerequisites
- Flutter SDK (3.7.0 or higher. This project uses 3.29.0)
- Dart SDK
- TMDB API key (free at https://www.themoviedb.org/settings/api)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd moviebrowser
   ```

2. **Get dependencies**
   ```bash
   flutter pub get
   ```

3. **Add your TMDB API key**
   
   Open `lib/data/datasources/movie_remote_data_source.dart` and replace `YOUR_TMDB_API_KEY` with your actual API key:
   ```dart
   static const String _apiKey = 'your_actual_api_key_here';
   ```

4. **Generate mock files for tests** (optional, for running tests)
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

5. **Run the app**
   ```bash
   flutter run
   ```

## Running Tests

```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage
```

## Project Structure

```
lib/
├── core/
│   ├── error/
│   │   └── failures.dart          # Error types
│   └── usecases/
│       └── usecase.dart            # Base use case interface
├── data/
│   ├── datasources/               # Remote and local data sources
│   ├── models/                    # Data models
│   └── repositories/              # Repository implementations
├── domain/
│   ├── entities/                  # Business entities
│   ├── repositories/              # Repository interfaces
│   └── usecases/                  # Business logic use cases
├── injection_container.dart       # Dependency injection setup
├── main.dart                      # App entry point
└── presentation/
    ├── bloc/                      # BLoC classes
    ├── pages/                     # UI screens
    └── widgets/                   # Reusable widgets
```

## Highlights

### Code Quality
- **Clean Architecture**: Strict separation between business logic and implementation details
- **Error Handling**: All repository methods return `Either<Failure, T>` using dartz
- **Dependency Injection**: Using GetIt for clean dependency management
- **Type Safety**: Strong typing throughout with Equatable for value comparison

### UI/UX Features
- **Smooth Animations**: Staggered fade-in animations for movie cards
- **Responsive Design**: Grid layout adapts to screen size
- **Offline Indicator**: Clear visual feedback when in offline mode
- **Favorite Carousel**: Horizontal scrolling carousel for favorite movies
- **Search Autocomplete**: Suggestions dropdown for search queries
- **Movie Details**: Full-screen detail page with backdrop image and trailer support

### Technical Implementation
- **Caching Strategy**: Movies cached for 1 hour, automatically used when offline
- **Pagination**: Infinite scroll for loading more movies
- **State Management**: Reactive BLoC pattern with clear event/state separation
- **Image Caching**: Using cached_network_image for efficient image loading

## Known Limitations

1. **API Key Required**: You must obtain a free TMDB API key and add it to the code
2. **No Video Player**: Video trailers open in external YouTube app/browser (not embedded)
3. **Limited Search History**: Search autocomplete suggestions are not persisted
4. **Cache Expiry**: Cached movies expire after 1 hour (configurable in `MovieLocalDataSourceImpl`)
5. **Cache decision**: Listing page with cache: Implemented
Listing page without cache: Basic (error + button)
Search page: Not handled
Movie detail page: Works but no offline indicator

## Future Enhancements

- [ ] Embedded video player for trailers
- [ ] Search history persistence
- [ ] Movie genres and filtering
- [ ] Actor/crew information
- [ ] Movie recommendations
- [ ] Dark mode support
- [ ] Internationalization (i18n)

## Dependencies

- `flutter_bloc`: State management
- `dartz`: Functional programming (Either for error handling)
- `equatable`: Value equality
- `http`: HTTP client
- `shared_preferences`: Local storage
- `cached_network_image`: Image caching
- `connectivity_plus`: Network status
- `url_launcher`: Opening YouTube links
- `get_it`: Dependency injection

## License

This project is created for educational purposes.
