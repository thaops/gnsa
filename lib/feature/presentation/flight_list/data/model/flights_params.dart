class FlightsParams {
  final bool isMySchedule;
  final int pageIndex;
  final int pageSize;
  final String? keyword;
  final String? airlineCode;
  final String? status;
  final DateTime? fromDate;
  final DateTime? toDate;


  FlightsParams({
    required this.isMySchedule,
    required this.pageIndex,
    required this.pageSize,
    this.keyword,
    this.airlineCode,
    this.status,
    this.fromDate,
    this.toDate,
  });

Map<String, dynamic> toQueryParams() {
  return {
    'IsMySchedule': isMySchedule,
    'PageIndex': pageIndex,
    'PageSize': pageSize,
    if (keyword != null) 'Keyword': keyword,
    if (airlineCode != null) 'AirlineCode': airlineCode,
    if (status != null) 'Status': status,
    if (fromDate != null) 'FromDate': fromDate!.toIso8601String(),
    if (toDate != null) 'ToDate': toDate!.toIso8601String(),
  };
}

}