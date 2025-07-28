class PreviewArgs {
  final String flightId;
  final List<String>? type;

  PreviewArgs({required this.flightId, this.type});
  
  Map<String, dynamic> toJson() {
    return {
      'FlightId': flightId,
      'Types': type ?? [],
    };
  }
}