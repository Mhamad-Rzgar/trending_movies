# Trending Movies App

This project is a Dart application that interacts with the TMDB API to fetch and display trending movies and their details.

### Features

- View a list of trending movies
- Search for movies
- View detailed information about selected movies
- `Offline/Online` access to movie details


## Getting Started

### Prerequisites

- Dart SDK 3.4.X
- Flutter SDK `3.22.X`


### Configuration

Before running the app, you need to configure your API access token.

1. Rename the constants.test.dart file to constants.dart:

        mv lib/constants/constants.test.dart lib/constants/constants.dart

2. Open lib/constants/constants.dart and replace 'YOUR_ACCESS_TOKEN_HERE' with your actual TMDB API access token.


## Folder Structure

- `lib/`: Contains the main application code.
- **lib/api/**: API client for fetching data.
- **lib/constants/**: Constants used in the application.
- **lib/models/**: Data models for the application.
- **lib/providers/**: State management providers.
- **lib/screens/**: UI screens.
- **lib/utils/**: Utility functions.
- **lib/widgets/**: Reusable widgets.
- `test/`: Contains unit tests for the application.


## Running Tests

- Running All Tests:

        flutter test

- Run Specific Test Files

        flutter test test/utils/format_utils_test.dart

        flutter test test/utils/json_parsing_utils_test.dart


## Testing API Endpoints
To test API endpoints, you can use the REST Client extension in VS Code.

### Installing REST Client

1. Open VS Code.
2. Go to the Extensions view by clicking on the Extensions icon in the Activity Bar on the side of the window or by pressing Ctrl+Shift+X.
3. Search for REST Client and click Install.

### Using REST Client

1. open `test/api/test_api.rest`
2. Click on the `Send Request` button above the request to execute it and see the response.

## Notes:

This `README.md` provides a comprehensive guide for setting up and running your project, including the necessary configuration for the API access token.