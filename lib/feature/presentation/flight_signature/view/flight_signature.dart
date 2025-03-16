import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gnsa/common/widgets/app_bar_widget.dart' show AppBarWidget;
import 'package:gnsa/feature/presentation/flight_sign/view/flight_sign.dart';
import 'package:gnsa/feature/presentation/flight_signature/controller/flight_signature_controller.dart';
import 'package:gnsa/feature/presentation/flight_signature/model/sign_supplyfrom.dart';
import 'package:gnsa/feature/presentation/flight_signature/widget/custom_signature.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gnsa/router/app_router.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FlightSignature extends HookConsumerWidget {
  final List<String> supplyfromId;
  const FlightSignature({super.key, required this.supplyfromId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flightSignatureAsync = ref.watch(flightSignatureProvider);
    final flightSignState = ref.read(flightSignatureProvider.notifier);

    useEffect(() {
      Future.microtask(
          () => flightSignState.getSingSupplyfrom(supplyfromId.first));
      return null;
    }, [supplyfromId]);

    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
        appBar: const AppBarWidget(
          title: 'Xác nhận',
        ),
        body: flightSignatureAsync.when(
            data: (data) => _buildSignatureWidget(screenSize, context, data),
            error: (err, stack) => Center(child: Text(err.toString())),
            loading: () => const Center(child: CircularProgressIndicator())));
  }

  Widget _buildSignatureWidget(Size screenSize, BuildContext context,
      SignSupplyfrom flightSignatureAsync) {
    return Container(
      width: screenSize.width,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: CustomSignature(
              title: 'TIẾP VIÊN XÁC NHẬN',
              onPressed: () {
                context.push(
                  AppRouter.flightSign,
                  extra: {
                    'title': 'TIẾP VIÊN XÁC NHẬN',
                    'supplyFormIds': supplyfromId,
                  },
                );
              },
              onEditPressed: () {
                context.push(
                  AppRouter.flightSign,
                  extra: {
                    'title': 'TIẾP VIÊN XÁC NHẬN',
                    'supplyFormIds': supplyfromId,
                  },
                );
              },
              imageUrl: flightSignatureAsync.supplierSign ?? "",
            ),
          ),
          SizedBox(height: 4.h),
          Expanded(
            child: CustomSignature(
              title: 'NHÂN VIÊN XÁC NHẬN',
              imageUrl: flightSignatureAsync.receiveSign ?? "",
              onPressed: () {
                context.push(
                  AppRouter.flightSign,
                  extra: {
                    'title': 'NHÂN VIÊN XÁC NHẬN',
                    'supplyFormIds': supplyfromId,
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
