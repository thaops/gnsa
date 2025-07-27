import 'package:flutter/material.dart';
import 'package:gnsa/common/design_system/tokens/app_sizes.dart';
import 'package:gnsa/common/img/img.dart';
import 'package:gnsa/common/widgets/app_bar_widget.dart';
import 'package:gnsa/common/widgets/custom_button.dart';
import 'package:gnsa/core/configs/theme/app_colors.dart';
import 'package:gnsa/feature/presentation/flight_detail/provider/flight_preview_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PreviewView extends ConsumerWidget {
  final String id;
  const PreviewView({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flightState = ref.watch(flightPreviewProviderProvider(id));
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Xem trước',
      ),
      body:   SizedBox.expand(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
               child: flightState.when(
                 data: (data) {
                 return ListView.builder(
                   itemCount: data.supplyFormDetails?.length ?? 0,
                   itemBuilder: (context, index) {
                     return Text(data.supplyFormDetails![index].supplyName);
                   },
                 );
                 },
                 loading: () => const Center(child: CircularProgressIndicator()),
                 error: (error, stackTrace) => Center(
                   child: Text(error.toString()),
                 ),
               ),
              ),
              CustomButton(
                horizontalPadding: AppSizes.paddingLarge,
                width: MediaQuery.of(context).size.width * 0.4,
                text: 'In phiếu',
                color: AppColors.primary,
                onPressed: () {},
              ),
              SizedBox(height: AppSizes.paddingSmall)
            ],
          ),
      ),
      
    );
  }
}