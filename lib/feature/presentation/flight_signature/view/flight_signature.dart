import 'package:flutter/material.dart';
import 'package:gnsa/common/widgets/app_bar_widget.dart';
import 'package:gnsa/common/widgets/container_loading.dart';
import 'package:gnsa/common/widgets/loading_shimmer.dart';
import 'package:gnsa/common/widgets/text_widget.dart';
import 'package:gnsa/feature/presentation/flight_signature/provider/flight_signature_provider.dart';
import 'package:gnsa/feature/presentation/flight_signature/data/model/flight_signature_model.dart';
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
    final flightSignatureAsync = ref.watch(flightSignatureControllerProvider(supplyfromId.first));
    final flightSignState =
        ref.read(flightSignatureControllerProvider(supplyfromId.first).notifier);

    // useEffect(() {
    //   Future.microtask(
    //       () => flightSignState.getSingSupplyfrom(supplyfromId.first));
    //   return null;
    // }, [supplyfromId]);

    return Scaffold(
      appBar: const AppBarWidget(title: 'Xác nhận'),
      body: SizedBox(
        width: double.infinity,
        child: flightSignatureAsync.when(
          data: (data) => SignatureContent(
            supplyfromId: supplyfromId,
            signDetail: data.details!,
            onRefresh: () => flightSignState.getSingSupplyfrom(supplyfromId.first),
          ),
          error: (err, _) =>SignatureContent(
            supplyfromId: supplyfromId,
            signDetail: [],
            onRefresh: () => flightSignState.getSingSupplyfrom(supplyfromId.first),
          ),
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
}

class SignatureContent extends StatelessWidget {
  final List<String> supplyfromId;
  final List<SignDetail> signDetail;
  final VoidCallback onRefresh;

  const SignatureContent({
    super.key,
    required this.supplyfromId,
    required this.signDetail,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 16.r),
      itemCount: signDetail.length,
      itemBuilder: (context, index) {
        final detail = signDetail[index];
        return SignatureSection(
          title: detail.isCrew == true ? 'TIẾP VIÊN XÁC NHẬN' : 'NHÂN VIÊN XÁC NHẬN',
          imageUrl: detail.imageUrl ?? '',
          isSupplierSign: detail.isCrew ?? false,
          supplyfromId: supplyfromId,
          onRefresh: onRefresh,
        );
      },
    );
  }
}
