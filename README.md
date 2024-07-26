# Iaso - Medication Tracking App

## Overview

Iaso is a Flutter-based mobile application designed to help users track their medications, manage dosages, and monitor health statistics. The app provides features such as medication reminders, dose calculations, and health stat tracking.

## Features

- Medication tracking and management
- Customizable medication schedules
- Health statistics monitoring (weight, temperature, blood pressure and blood sugar)
- Notifications for low medication quantities
- Multi-language support (English and Hungarian)
- Dark and light theme options

## Project Structure

The project follows a layered architecture for better organization and separation of concerns:

```
lib/
├── l10n/
├── src/
│   ├── app_services/
│   ├── constants/
│   ├── data/
│   ├── domain/
│   ├── presentation/
│   │   ├── views/
│   │   ├── widgets/
│   │   └── routing/
│   ├── utils/
```

- `app_services/`: Houses core application logic and services.
- `constants/`: Houses core application constants for consistency.
- `data/`: Implements the repository pattern for data access.
- `domain/`: Includes data models representing core entities.
- `presentation/`: Contains all UI-related code, including views, widgets, and routing.
- `utils/`: Contains utility functions and helper classes.

## Setup and Installation

1. Ensure you have Flutter installed on your machine. If not, follow the [official Flutter installation guide](https://flutter.dev/docs/get-started/install).

2. Clone the repository:
   ```
   git clone https://github.com/Mak0nz/iaso-app.git
   ```

3. Navigate to the project directory:
   ```
   cd iaso-app
   ```

4. Install dependencies:
   ```
   flutter pub get
   ```

5. Set up Firebase:
   - Create a new Firebase project in the [Firebase Console](https://console.firebase.google.com/).
   - Add an Android and/or iOS app to your Firebase project and follow the setup instructions.
   - Download the `google-services.json` (for Android) and/or `GoogleService-Info.plist` (for iOS) and place them in the appropriate directories in your project.

6. Run the app:
   ```
   flutter run
   ```

## Configuration

- Language: The app supports English and Hungarian. Users can change the language in the app settings.
- Theme: Users can choose between light and dark themes in the app settings.
- Notifications: The app uses the `awesome_notifications` package for local notifications. Ensure notifications are properly configured for your platform.

## Testing

Initially generate mock data using:

```
dart run build_runner build
```

To run the tests:

```
flutter test
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the Apache License - see the [LICENSE](https://github.com/Mak0nz/iaso-app/wiki#license) wiki page for details.

## Acknowledgments

- [Flutter](https://flutter.dev/) for the cross-platform framework.
- [Firebase](https://firebase.google.com/) for backend services.
- All contributors and users of the Iaso app.