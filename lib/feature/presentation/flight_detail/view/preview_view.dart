import 'package:flutter/material.dart';
import 'package:gnsa/common/design_system/tokens/app_sizes.dart';
import 'package:gnsa/common/img/img.dart';
import 'package:gnsa/common/widgets/app_bar_widget.dart';
import 'package:gnsa/common/widgets/custom_button.dart';
import 'package:gnsa/core/configs/theme/app_colors.dart';
import 'package:gnsa/feature/presentation/flight_detail/provider/flight_preview_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

// class PreviewView extends ConsumerWidget {
//   final String id;
//    PreviewView({super.key, required this.id});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final flightState = ref.watch(flightPreviewProviderProvider(id));
//     return Scaffold(
//       appBar: AppBarWidget(
//         title: 'Xem trước',
//       ),
//       body:   SizedBox.expand(
//         child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Expanded(
//                child: flightState.when(
//                  data: (data) {
//                  },
//                  loading: () =>  Center(child: CircularProgressIndicator()),
//                  error: (error, stackTrace) => Center(
//                    child: Text(error.toString()),
//                  ),
//                ),
//               ),
//               CustomButton(
//                 horizontalPadding: AppSizes.paddingLarge,
//                 width: MediaQuery.of(context).size.width * 0.4,
//                 text: 'In phiếu',
//                 color: AppColors.primary,
//                 onPressed: () {},
//               ),
//               SizedBox(height: AppSizes.paddingSmall)
//             ],
//           ),
//       ),
      
//     );
//   }
// }


class PreviewView extends ConsumerWidget {
  final String id;
   PreviewView({super.key, required this.id});

  // Format date to match vi-VN locale
  String formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final dateFormat = DateFormat('dd/MM/yyyy HH:mm', 'vi_VN');
      return dateFormat.format(date);
    } catch (e) {
      return dateString; // Fallback to raw string if parsing fails
    }
  }

  // Placeholder for print functionality
  void handlePrint() {
    // Implement printing logic here (e.g., using 'printing' package)
    print('Printing supply form...');
    // For actual printing, you can use a package like `printing`:
    // Printing.layoutPdf(onLayout: (format) => generatePdf());
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flightState = ref.watch(flightPreviewProviderProvider(id));
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Xem trước',
      ),
      body: flightState.when(
        data: (data) => SingleChildScrollView(
          child: Padding(
            padding:  EdgeInsets.all(AppSizes.paddingMedium),
            child: ConstrainedBox(
              constraints:  BoxConstraints(maxWidth: 400),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Flight Information Card
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding:  EdgeInsets.all(AppSizes.paddingMedium),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           Text(
                            'Flight Information',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                           SizedBox(height: AppSizes.paddingSmall),
                          _buildFlightInfoRow('Flight', data.flightInfo?.routing ?? ''),
                          _buildFlightInfoRow('Flight No', data.flightInfo?.flightNo ?? ''),
                          _buildFlightInfoRow('Aircraft', data.flightInfo?.acfNo ?? ''),
                          _buildFlightInfoRow('Departure', formatDate(data.flightInfo?.departureDate ?? '')),
                          _buildFlightInfoRow('Arrival', formatDate(data.flightInfo?.arrivalDate ?? '')),
                          _buildFlightInfoRow('Aircraft Type', data.flightInfo?.typeApl ?? ''),
                        ],
                      ),
                    ),
                  ),
                   SizedBox(height: AppSizes.paddingMedium),
                  // Supply Details Cards
                  ...data.supplyFormDetails!.map((supply) {
                    return Padding(
                      padding:  EdgeInsets.only(bottom: AppSizes.paddingMedium),
                      child: Card(
                        elevation: 2,
                        child: Padding(
                          padding:  EdgeInsets.all(AppSizes.paddingMedium),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    supply.supplyType ?? '',
                                    style:  TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    supply.supplyCode ?? '',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                               SizedBox(height: AppSizes.paddingSmall),
                              ...supply.detailItems!.asMap().entries.map((entry) {
                                final index = entry.key;
                                final item = entry.value;
                                return Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          item.itemName ?? '',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[700],
                                          ),
                                        ),
                                        Text(
                                          item.quantity.toString() ?? '',
                                          style:  TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (index < supply.detailItems!.length - 1)
                                      Divider(color: Colors.grey.withOpacity(0.3)),
                                  ],
                                );
                              }).toList(),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                   SizedBox(height: AppSizes.paddingMedium),
                  // Print Button
                  CustomButton(
                    horizontalPadding: AppSizes.paddingLarge,
                    width: MediaQuery.of(context).size.width * 0.4,
                    text: 'In phiếu',
                    color: AppColors.primary,
                    onPressed: handlePrint,
                  ),
                   SizedBox(height: AppSizes.paddingSmall),
                ],
              ),
            ),
          ),
        ),
        loading: () =>  Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Text(error.toString()),
        ),
      ),
    );
  }

  // Helper widget for flight info rows
  Widget _buildFlightInfoRow(String label, String value) {
    return Padding(
      padding:  EdgeInsets.symmetric(vertical: AppSizes.paddingXSmall),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          Text(
            value,
            style:  TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}