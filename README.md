# SoldierFit

Military gamified fitness system with XP progression, AI coach, and seasonal battle pass.

## Features

- **XP Engine**: Dynamic XP system with streaks, multipliers, and level progression
- **Rank Progression**: Military rank hierarchy from Recruit to Commander
- **Missions System**: Challenging fitness missions with varying difficulty levels
- **AI Coach**: Personality-based coaching with advanced memory system (Strict, Elite, Friendly modes)
- **Seasonal Battle Pass**: Season 1 - Operation: Iron Dawn with 50 levels and exclusive rewards
- **Motion System**: Game-grade animations and transitions
- **Design System**: Figma-level design tokens with glassmorphism and glowing nodes
- **Admin Dashboard**: Web-based control panel with real-time Firestore streams
- **CI/CD Pipeline**: Automated testing, building, and deployment

## Stack

- **Flutter**: Cross-platform framework (Android, iOS, Web)
- **Firebase**: Authentication, Firestore, Analytics, Admin SDK
- **OpenAI API**: AI-powered coaching system
- **Provider**: State management
- **Go Router**: Navigation
- **Flutter Animate**: Advanced animations
- **GitHub Actions**: CI/CD automation

## Project Structure

```
soldierfit/
├── .github/
│   └── workflows/
│       ├── flutter_ci.yml
│       └── firebase_deploy.yml
├── lib/
│   ├── main.dart
│   ├── app/
│   │   ├── app.dart
│   │   ├── bootstrap.dart
│   ├── core/
│   │   ├── theme/
│   │   │   ├── app_theme.dart
│   │   │   └── design_tokens.dart
│   │   ├── motion/
│   │   ├── constants/
│   │   └── utils/
│   ├── features/
│   │   ├── home/
│   │   ├── missions/
│   │   ├── rank/
│   │   ├── coach/
│   │   └── season/
│   ├── services/
│   │   ├── firebase/
│   │   │   ├── firebase_service.dart
│   │   │   └── admin_firebase_service.dart
│   │   ├── xp/
│   │   ├── ai/
│   │   │   ├── user_memory_model.dart
│   │   │   ├── memory_builder.dart
│   │   │   ├── adaptive_personality_engine.dart
│   │   │   └── enhanced_ai_coach_service.dart
│   │   ├── rank/
│   │   └── season/
│   ├── shared/
│   │   ├── widgets/
│   │   ├── animations/
│   │   └── components/
│   └── admin/
│       ├── users_view/
│       ├── missions_editor/
│       ├── xp_tuning/
│       ├── season_manager/
│       ├── season_creator/
│       └── analytics/
├── test/
│   ├── services/
│   └── core/
├── assets/
│   ├── images/
│   ├── sounds/
│   └── animations/
├── android/
├── ios/
├── web/
├── firebase.json
├── .firebaserc
└── pubspec.yaml
```

## Getting Started

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK
- Firebase account
- OpenAI API key

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd soldierfit
```

2. Install dependencies:
```bash
flutter pub get
```

3. Configure Firebase:
- Create a Firebase project at https://console.firebase.google.com
- Add Android, iOS, and Web apps
- Download configuration files and place them in the respective directories
- Enable Authentication (Email/Password)
- Create Firestore database
- Enable Analytics

4. Configure OpenAI:
- Get your API key from https://platform.openai.com
- Add the API key to your environment variables or configuration

5. Run the app:
```bash
# For mobile
flutter run

# For web
flutter run -d chrome
```

## Architecture

### Clean Architecture

The project follows clean architecture principles:

```
UI → Feature Logic → Service Layer → Firebase / AI
```

### Core Components

#### Motion System
- Game-grade animations with configurable durations and curves
- XP explosion effects
- Rank-up cinematic transitions
- Page flow animations

#### XP Engine
- Dynamic XP calculation
- Streak bonuses
- Multipliers based on consistency
- Level progression

#### Rank System
- 10 military ranks from Recruit to Commander
- XP-based progression
- Rank-up celebrations

#### AI Coach
- Three personality modes: Strict, Elite, Friendly
- Advanced memory system with user profile and workout history
- Context-aware responses based on performance analysis
- Adaptive personality engine that adjusts coaching style
- Long-term memory strategy with Firestore integration

#### Season System
- 30-day seasonal cycles (Operation: Iron Dawn)
- Battle pass with 50 levels and detailed reward structure
- Exclusive rewards (themes, boosts, titles, animations)
- Premium and free rewards with claiming system
- Automatic season reset with partial XP preservation

## Admin Dashboard

Access the admin dashboard by running the web version:

```bash
flutter run -d chrome
```

The admin dashboard includes:
- **Users View**: Real-time user management with Firestore streams, add XP, promote ranks, reset progress
- **Missions Editor**: Create and edit fitness missions with difficulty and XP rewards
- **XP Tuning**: Adjust XP values and multipliers for workouts, missions, and streaks
- **Season Manager**: View and manage current season details
- **Season Creator**: Create new seasons with custom duration, levels, and rewards
- **Analytics**: View user engagement, retention metrics, XP distribution, and rank distribution

## Configuration

### XP Constants

Edit `lib/core/constants/app_constants.dart` to adjust:
- XP per workout
- XP per mission
- Streak bonuses
- Rank thresholds
- Season duration

### Theme Customization

Edit `lib/core/theme/app_theme.dart` to customize:
- Color palette
- Text styles
- Component themes
- Season-specific themes

Edit `lib/core/theme/design_tokens.dart` to customize:
- Design tokens (colors, spacing, typography)
- Glassmorphism effects
- Glowing node styles
- Animation durations

## Development

### Running Tests

```bash
flutter test
```

### CI/CD Pipeline

The project uses GitHub Actions for automated testing and deployment:

#### Flutter CI Workflow
- Runs on every push to main and develop branches
- Performs code formatting check
- Runs static analysis
- Executes test suite with coverage
- Builds Android APK, iOS (testing), and Web versions
- Uploads build artifacts

#### Firebase Deploy Workflow
- Automatically deploys web version to Firebase Hosting
- Triggered on push to main branch
- Requires `FIREBASE_TOKEN` secret in GitHub repository

### Setting Up CI/CD

1. Add Firebase Token to GitHub Secrets:
   - Go to repository Settings → Secrets and variables → Actions
   - Add `FIREBASE_TOKEN` with your Firebase deployment token
   - Get token by running: `firebase login:ci`

2. Configure Firebase Hosting:
   - Update `firebase.json` with your project details
   - Update `.firebaserc` with your Firebase project ID

### Building for Production

#### Android
```bash
flutter build apk --release
```

#### iOS
```bash
flutter build ios --release
```

#### Web
```bash
flutter build web --release
```

#### Firebase Deployment
```bash
# Build web version
flutter build web --release

# Deploy to Firebase Hosting
firebase deploy
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

## License

This project is licensed under the MIT License.

## Support

For support, email support@soldierfit.com or create an issue in the repository.

---

**SoldierFit** - Transform your fitness journey with military-grade gamification.
