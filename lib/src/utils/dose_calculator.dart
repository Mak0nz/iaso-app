class DoseCalculator {
  double calculateTotalDoses(double currentQuantity, double takeQuantityPerDay, bool isAlternatingSchedule) {
    if (takeQuantityPerDay == 0) {
      return currentQuantity;
    }
    double effectiveDailyDose = isAlternatingSchedule ? takeQuantityPerDay / 2 : takeQuantityPerDay;
    return (currentQuantity / effectiveDailyDose).floorToDouble();
  }
}