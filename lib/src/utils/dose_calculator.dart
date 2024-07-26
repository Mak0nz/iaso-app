class DoseCalculator {
  double calculateTotalDoses(double currentQuantity, double takeQuantityPerDay) {
    if (takeQuantityPerDay == 0) {
      return currentQuantity;
    }
    return (currentQuantity / takeQuantityPerDay).floorToDouble();
  }
}