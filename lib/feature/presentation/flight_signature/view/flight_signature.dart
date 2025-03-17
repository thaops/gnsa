import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gnsa/common/widgets/app_bar_widget.dart';
import 'package:gnsa/feature/presentation/flight_signature/controller/flight_signature_controller.dart';
import 'package:gnsa/feature/presentation/flight_signature/model/sign_supplyfrom.dart';
import 'package:gnsa/feature/presentation/flight_signature/widget/custom_signature.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gnsa/feature/presentation/flight_signature/widget/signature_section.dart';
import 'package:gnsa/router/app_router.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Constants
const _kPadding = EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0);
const _kSpacing = 4.0;

class FlightSignature extends HookConsumerWidget {
  final List<String> supplyfromId;

  const FlightSignature({super.key, required this.supplyfromId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flightSignatureAsync =
        ref.watch(flightSignatureProvider); // Đang theo dõi dữ liệu từ provider

    _fetchInitialData(
        ref.read(flightSignatureProvider.notifier)); // Lấy dữ liệu ban đầu

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
          loading: () => const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
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
