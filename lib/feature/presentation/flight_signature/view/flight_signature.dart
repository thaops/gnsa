import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gnsa/common/widgets/app_bar_widget.dart';
import 'package:gnsa/common/widgets/container_loading.dart';
import 'package:gnsa/common/widgets/loading_shimmer.dart';
import 'package:gnsa/common/widgets/text_widget.dart';
import 'package:gnsa/feature/presentation/flight_signature/controller/flight_signature_controller.dart';
import 'package:gnsa/feature/presentation/flight_signature/model/sign_supplyfrom.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gnsa/feature/presentation/flight_signature/widget/signature_section.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Constants
const _kPadding = EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0);
const _kSpacing = 4.0;

class FlightSignature extends HookConsumerWidget {
  final List<String> supplyfromId;

  const FlightSignature({super.key, required this.supplyfromId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flightSignatureAsync = ref.watch(flightSignatureProvider);

    _fetchInitialData(ref.read(flightSignatureProvider.notifier));

    return Scaffold(
      appBar: const AppBarWidget(title: 'Xác nhận'),
      body: SizedBox(
        width: double.infinity,
        child: flightSignatureAsync.when(
          data: (data) => SignatureContent(
            supplyfromId: supplyfromId,
            flightSignature: data,
            onRefresh: () =>
                _refreshSignature(ref.read(flightSignatureProvider.notifier)),
          ),
          error: (err, _) => Center(child: Text(err.toString())),
          loading: () => _buildLoading(context),
        ),
      ),
    );
  }

  LoadingShimmer _buildLoading(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return LoadingShimmer(
        child: Padding(
      padding: EdgeInsets.all(16.r),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TextWidget(
              paddingHorizontal: 16,
              text: 'TIẾP VIÊN XÁC NHẬN',
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            SizedBox(height: _kSpacing.h),
            ContainerLoading(
              height: height * 0.26,
            ),
            SizedBox(height: _kSpacing.h),
            const TextWidget(
              paddingHorizontal: 16,
              text: 'NHÂN VIÊN XÁC NHẬN',
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            SizedBox(height: _kSpacing.h),
            ContainerLoading(
              height: height * 0.26,
            )
          ],
        ),
      ),
    ));
  }

  void _fetchInitialData(FlightSignatureController flightSignState) {
    useEffect(() {
      Future.microtask(
          () => flightSignState.getSingSupplyfrom(supplyfromId.first));
      return null;
    }, [supplyfromId]);
  }

  void _refreshSignature(FlightSignatureController flightSignState) {
    Future.microtask(
        () => flightSignState.getSingSupplyfrom(supplyfromId.first));
  }
}

class SignatureContent extends StatelessWidget {
  final List<String> supplyfromId;
  final SignSupplyfrom flightSignature;
  final VoidCallback onRefresh;

  const SignatureContent({
    super.key,
    required this.supplyfromId,
    required this.flightSignature,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: _kPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SignatureSection(
            title: 'TIẾP VIÊN XÁC NHẬN',
            imageUrl: flightSignature.supplierSign ?? '',
            isSupplierSign: true,
            supplyfromId: supplyfromId,
            onRefresh: onRefresh,
          ),
          SizedBox(height: _kSpacing.h),
          SignatureSection(
            title: 'NHÂN VIÊN XÁC NHẬN',
            imageUrl: flightSignature.receiveSign ?? '',
            isSupplierSign: false,
            supplyfromId: supplyfromId,
            onRefresh: onRefresh,
          ),
        ],
      ),
    );
  }
}
