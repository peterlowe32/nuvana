class DailyVerse {
  static const Map<String, List<Map<String, String>>> categorizedVerses = {
    "strength": [
      {"reference": "Philippians 4:13", "text": "I can do all things through Christ who strengthens me."},
      {"reference": "Isaiah 40:31", "text": "But those who hope in the Lord will renew their strength..."},
    ],
    "peace": [
      {"reference": "John 14:27", "text": "Peace I leave with you; my peace I give you."},
      {"reference": "Isaiah 26:3", "text": "You will keep in perfect peace those whose minds are steadfast..."},
    ],
    "wisdom": [
      {"reference": "James 1:5", "text": "If any of you lacks wisdom, let him ask God..."},
      {"reference": "Proverbs 3:5-6", "text": "Trust in the Lord with all your heart..."},
    ],
    "love": [
      {"reference": "1 Corinthians 13:4-5", "text": "Love is patient, love is kind..."},
      {"reference": "Romans 5:8", "text": "But God demonstrates his own love for us in this..."},
    ],
  };

  static Map<String, String> getTodaysVerse() {
    final categories = categorizedVerses.keys.toList();
    final now = DateTime.now();
    final dayOfYear = int.parse(DateFormat("D").format(now));
    final category = categories[dayOfYear % categories.length];
    final verse = categorizedVerses[category]![dayOfYear % categorizedVerses[category]!.length];
    return verse;
  }
}
