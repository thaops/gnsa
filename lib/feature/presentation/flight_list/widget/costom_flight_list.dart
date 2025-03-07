import 'package:flutter/material.dart';
import 'package:gnsa/common/img/img.dart';
import 'package:gnsa/common/utils/date_utils.dart';
import 'package:gnsa/common/widgets/text_widget.dart';
import 'package:gnsa/core/configs/theme/app_colors.dart';
import 'package:gnsa/feature/presentation/flight_list/model/flights_model.dart';

class CustomFightList extends StatelessWidget {
  const CustomFightList({super.key, required this.onTap, required this.data});
  final VoidCallback onTap;
  final FlightData data;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          height: 100,
          decoration: BoxDecoration(
            color: AppColors.backgroundTab,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: FlightInfoColumn(
                      flightNo: data.depart!,
                      flightDate: data.actualTimeDepart!,
                      crossAxisAlignment: CrossAxisAlignment.start,
                    ),
                  ),
                  Expanded(
                    child: FlightInfoColumn(
                        flightNo: data.flightNo!,
                        flightDate: data.actualTimeArrival!,
                        isDepart: true,
                        crossAxisAlignment: CrossAxisAlignment.center),
                  ),
                  Expanded(
                    child: FlightInfoColumn(
                      flightNo: data.arrival!,
                      flightDate: data.actualTimeArrival!,
                      crossAxisAlignment: CrossAxisAlignment.end,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FlightInfoColumn extends StatelessWidget {
  final String flightNo;
  final DateTime flightDate;
  final bool? isDepart;
  final CrossAxisAlignment crossAxisAlignment;
  const FlightInfoColumn({
    super.key,
    required this.flightNo,
    required this.flightDate,
    this.isDepart,
    required this.crossAxisAlignment,
  });
  @override
  Widget build(BuildContext context) {
    return   Column(
          crossAxisAlignment: crossAxisAlignment,
          mainAxisAlignment: MainAxisAlignment.center,
           children: [
            TextWidget(
              text: flightNo,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              textAlign: TextAlign.center,
            ),
            if (isDepart == true)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Image.asset(Img.iconFlight),
              ),
            if (isDepart != true) const SizedBox(height: 4),
            TextWidget(
              text: isDepart == true
                  ? DateUtilsCustom.formatStringDate(flightDate.toIso8601String())
                  : DateUtilsCustom.formatStringTime(
                      flightDate.toIso8601String()),
              fontSize: 12,
              textAlign: TextAlign.center,
              fontWeight: FontWeight.w300,
              
            ),
          ],
        
      );
    
  }
}
