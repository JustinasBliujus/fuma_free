
double calculateCigarettesSmokedSince(DateTime startDate, int cigsPerDay, DateTime initiationDate, int relapseTimes) {
  final duration = initiationDate.difference(startDate);
  final totalDays = duration.inMinutes / (60 * 24);
  final totalCigs = totalDays * cigsPerDay + relapseTimes;
  return totalCigs;
}

double calculateTotalMoneySpent(DateTime startDate, int cigsPerDay, double costPerPack, int cigsPerPack,DateTime initiationDate,int relapseTimes){
  final double totalCigsSmoked = calculateCigarettesSmokedSince(startDate, cigsPerDay,initiationDate,relapseTimes);
  final double totalMoneySpent = (totalCigsSmoked/cigsPerPack) * costPerPack;
  return totalMoneySpent;
}

Duration calculateTotalLifetimeLost(DateTime startDate, int cigsPerDay, double costPerPack, int cigsPerPack,DateTime initiationDate,int relapseTimes){
  final double totalCigsSmoked = calculateCigarettesSmokedSince(startDate, cigsPerDay,initiationDate,relapseTimes);
  final double timeLostInMinutes = totalCigsSmoked*11;
  return Duration(minutes: timeLostInMinutes.round());
}

double calculateCurrentCigarettesAvoided(DateTime lastSmoke, int cigsPerDay,DateTime initiationDate,int relapseTimes){
  final duration = DateTime.now().difference(lastSmoke);
  final totalDays = duration.inMinutes / (60 * 24);
  final totalCigs = totalDays * cigsPerDay;
  return totalCigs;
}

double calculateCurrentMoneySaved(DateTime lastSmoke, int cigsPerDay, double costPerPack, int cigsPerPack,DateTime initiationDate,int relapseTimes){
  final duration = DateTime.now().difference(lastSmoke);
  final totalDays = duration.inMinutes / (60 * 24);
  final double totalCigsNotSmoked = totalDays * cigsPerDay;
  final double totalMoneySaved = (totalCigsNotSmoked/cigsPerPack) * costPerPack;
  return totalMoneySaved;
}

Duration calculateCurrentLifetimeSaved(DateTime lastSmoke, int cigsPerDay, double costPerPack, int cigsPerPack,DateTime initiationDate,int relapseTimes){
  final double totalCigsNotSmoked = calculateCurrentCigarettesAvoided(lastSmoke,cigsPerDay,initiationDate,relapseTimes);
  final double timeSavedInMinutes = totalCigsNotSmoked*11;
  return Duration(minutes: timeSavedInMinutes.round());
}

int getMillisecondsSinceLastSmoke(DateTime lastSmoke) {
  final now = DateTime.now();
  final duration = now.difference(lastSmoke);
  return duration.inMilliseconds;
}
