# 🐴 Kertotaulutalli

A fun, horse-themed multiplication practice game for children! Built with Flutter.

## 📖 About

Kertotaulutalli (Multiplication Stable) is an educational game designed to help children practice their multiplication tables in a fun, engaging way. The game features a horse stable theme with colorful animations and encouraging sound effects.

## ✨ Features

- 🐴 **Horse Stable Theme** - Fun horse emojis and themed UI elements throughout
- 🎯 **Practice Any Table** - Choose from multiplication tables 1-10
- 🏃 **4 Difficulty Levels**:
  - 🐎 Käynti (Walk) - 20 seconds per question
  - 🐎 Ravi (Trot) - 10 seconds per question
  - 🐎 Laukka (Canter) - 6 seconds per question
  - 🐎 Kiitolaukka (Gallop) - 3 seconds per question
- 🎨 **Beautiful Animations**:
  - Bounce effects on correct answers
  - Shake effects on wrong answers
  - Falling stars for perfect scores
  - Sparkles for good scores
  - Score increment animations
- 🔊 **Sound Effects**:
  - Horse galloping when starting
  - Gentle neigh for first correct answer
  - Horse snort for wrong answers
  - Triumphant whinny for perfect scores
  - Toggle sound on/off option
- 📊 **Progress Tracking** - See your score and current round
- 🎮 **10 Questions Per Game** - Perfect length for practice sessions

## 🎮 How to Play

1. Select a multiplication table (1-10)
2. Choose your difficulty level (speed)
3. Answer 10 random multiplication questions
4. Race against the timer!
5. See your results with fun animations

## 🛠️ Tech Stack

- **Framework**: Flutter 3.38.3
- **Language**: Dart
- **Audio**: audioplayers package
- **Platforms**: Android, iOS, Web

## 🏗️ Project Structure

```
lib/
├── main.dart                           # App entry point
├── screens/
│   ├── table_selection_screen.dart    # Home screen
│   ├── quiz_screen.dart                # Game screen
│   └── result_screen.dart              # Results screen
├── widgets/
│   ├── animated_press_button.dart      # Button animation widget
│   ├── falling_stars.dart              # Perfect score animation
│   └── sparkles.dart                   # Good score animation
└── utils/
    ├── constants.dart                  # Game constants & difficulty settings
    └── audio_helper.dart               # Sound effect helper

assets/
└── sounds/                             # Horse sound effects
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.38.3 or higher
- Dart SDK
- Android Studio / Xcode (for mobile development)

### Installation

1. Clone the repository:
```bash
git clone https://github.com/JaakkoRoponen/kertotaulutalli.git
cd kertotaulutalli
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
# Web
flutter run -d chrome

# Android
flutter run -d android

# iOS
flutter run -d ios
```

## 📦 Building for Release

### Android (Play Store)

```bash
flutter build appbundle --release
```

The release bundle will be at: `build/app/outputs/bundle/release/app-release.aab`

### iOS (App Store)

```bash
flutter build ios --release
```

### Web

```bash
flutter build web --release
```

## 🎨 Screenshots

Screenshots are available in the `play_store/screenshots/` directory.

## 🔒 Privacy

This app does NOT collect any personal data. All game progress is stored locally on the device.

For full privacy policy, see: [Privacy Policy](https://jaakkoroponen.github.io/kertotaulutalli/privacy-policy/)

## 📱 Download

- **Google Play Store**: Coming soon!
- **Web**: [Play Now!](https://jaakkoroponen.github.io/kertotaulutalli/) 🐴

## 👨‍💻 Developer

**Jaakko Roponen**
- Email: roponenjaakko@gmail.com
- GitHub: [@JaakkoRoponen](https://github.com/JaakkoRoponen)

## 📄 License

This project is open source and available for educational purposes.

## 🙏 Acknowledgments

- Sound effects from [Pixabay](https://pixabay.com/)
- Icons generated with [Icon Kitchen](https://icon.kitchen/)
- Built with [Flutter](https://flutter.dev/)

---

**Made with ❤️ for kids learning multiplication!** 🐴
