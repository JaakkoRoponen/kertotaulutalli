enum Difficulty { easy, medium, hard, master }

class GameConstants {
  static const int totalRounds = 10;

  static int getTimerSeconds(Difficulty difficulty) {
    switch (difficulty) {
      case Difficulty.easy:
        return 20;
      case Difficulty.medium:
        return 10;
      case Difficulty.hard:
        return 6;
      case Difficulty.master:
        return 3;
    }
  }

  static String getDifficultyName(Difficulty difficulty) {
    switch (difficulty) {
      case Difficulty.easy:
        return 'Käynti';
      case Difficulty.medium:
        return 'Ravi';
      case Difficulty.hard:
        return 'Laukka';
      case Difficulty.master:
        return 'Kiitolaukka';
    }
  }
}
