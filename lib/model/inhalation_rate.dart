class InhalationRate {
  // this class models the inhalation rate of a person at a given time, which is calculated by multiplying the ventilation rate with the PM2.5 concentration
  final DateTime timestamp;
  final double value;

  InhalationRate({required this.timestamp, required this.value});
}
