class Data {
  // Intro questions
  DateTime startedSmoking;
  double costPerPack;
  int cigsPerDay;
  int amountPerPack;

  // Current stats (calculated dynamically)
  DateTime lastSmoke;
  int cigsAvoided = 0; // Calculated based on last smoke and cigs per day
  Duration lifeExpectancyImprovedBy = Duration.zero; // Calculated
  Duration longestTimeWithoutSmoke = Duration.zero; // Calculated
  Duration timeTillRecordWithoutSmoking = Duration.zero; // Calculated
  double moneySaved = 0.0; // Calculated
  double moneyWasted = 0.0; // Calculated

  // Total stats
  int cigsSmoked = 0; // Calculated
  Duration lifeExpectancyWasted = Duration.zero; // Calculated

  // Constructor
  Data({
    required this.startedSmoking,
    required this.costPerPack,
    required this.cigsPerDay,
    required this.amountPerPack,
    required this.lastSmoke,
  });

  // Calculate cigs avoided based on the time since last smoke
  int calculateCigsAvoided() {
    Duration timeSinceLastSmoke = DateTime.now().difference(lastSmoke);
    // Calculate number of days since last smoke
    int daysSinceLastSmoke = timeSinceLastSmoke.inDays;
    // Calculate cigs avoided based on cigs per day
    return cigsPerDay * daysSinceLastSmoke;
  }
  // Calculate money saved
  double calculateMoneySaved() {
    int totalCigsAvoided = calculateCigsAvoided();
    return (totalCigsAvoided / amountPerPack) * costPerPack;
  }

  // Calculate time since last smoke
  Duration calculateTimeSinceLastSmoke() {
    return DateTime.now().difference(lastSmoke);
  }

  // Calculate life expectancy improved by (a rough estimate based on cigs avoided)
  Duration calculateLifeExpectancyImprovedBy() {
    // This is just a rough estimate. You can use actual research to refine this.
    int avoidedCigs = calculateCigsAvoided();
    // Assuming 11 minutes lost for every 1 cigarette smoked (this is an estimate)
    int minutesSaved = avoidedCigs * 11;
    return Duration(minutes: minutesSaved);
  }
  String getFormattedLifeExpectancyImproved() {
    final duration = calculateLifeExpectancyImprovedBy();
    final days = duration.inDays;
    final hours = duration.inHours.remainder(24);
    final minutes = duration.inMinutes.remainder(60);

    return '${days}d ${hours}h ${minutes}m';
  }
  // Calculate longest time without smoking (this can be tracked over time)
  Duration calculateLongestTimeWithoutSmoke() {
    // Implement logic to track longest time without smoking
    return Duration(days: 0); // Placeholder
  }

  // Calculate time till record without smoking
  Duration calculateTimeTillRecordWithoutSmoking() {
    // Placeholder logic, assuming record without smoking is in 30 days
    return Duration(days: 30);
  }
  String calculateTimeTillRecordWithoutSmokingFormatted() {
    final duration = calculateTimeTillRecordWithoutSmoking();
    final days = duration.inDays;
    final hours = duration.inHours.remainder(24);
    final minutes = duration.inMinutes.remainder(60);

    return '${days}d ${hours}h ${minutes}m';
  }
  // Calculate life expectancy wasted by smoking
  Duration calculateLifeExpectancyWasted() {
    // Assuming 11 minutes lost for every cigarette smoked (estimate)
    int minutesWasted = cigsSmoked * 11;
    return Duration(minutes: minutesWasted);
  }

  // Update the data after each smoke (for stats like cigs smoked)
  void updateOnSmoke() {
    // Increase cigs smoked count
    cigsSmoked += cigsPerDay;
    // Update other stats based on the current state
    lifeExpectancyWasted = calculateLifeExpectancyWasted();
    moneyWasted = (cigsSmoked / amountPerPack) * costPerPack;
  }

  // Update stats on a successful smoke-free streak (for longest time without smoke)
  void updateOnSmokeFreeStreak(Duration streakDuration) {
    if (streakDuration > longestTimeWithoutSmoke) {
      longestTimeWithoutSmoke = streakDuration;
    }
  }
}
