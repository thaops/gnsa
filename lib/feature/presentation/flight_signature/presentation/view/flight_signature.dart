import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gnsa/common/design_system/tokens/app_sizes.dart';
import 'package:gnsa/common/widgets/app_bar_widget.dart';
import 'package:gnsa/common/widgets/container_loading.dart';
import 'package:gnsa/common/widgets/loading_shimmer.dart';
import 'package:gnsa/common/widgets/text_widget.dart';
import 'package:gnsa/feature/presentation/flight_sign/presentation/provider/flight_sign_provider.dart';
import 'package:gnsa/feature/presentation/flight_signature/data/model/flight_signature_model.dart';
import 'package:gnsa/feature/presentation/flight_signature/presentation/provider/flight_signature_provider.dart';
import 'package:gnsa/feature/presentation/flight_signature/presentation/widget/signature_content.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

const _kSpacing = 6.0;

class FlightSignature extends HookConsumerWidget {
  final bool isSupplement;
  final bool isSignAll;
  final List<String> supplyfromdetailId;

  const FlightSignature({
    super.key,
    required this.supplyfromdetailId,
    required this.isSupplement,
    required this.isSignAll,
  });

  Future<bool> _confirmExit(BuildContext context, WidgetRef ref, 
      {required bool hasTempSignature}) async {
    // Nếu có chữ ký tạm, hiển thị dialog xác nhận
    if (hasTempSignature) {
      final result = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Thông báo'),
          content: const Text(
            'Bạn có chắc muốn thoát? Toàn bộ chữ ký sẽ bị xóa.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
      
      // Xử lý kết quả từ dialog
      if (result == true) {
        ref.read(flightSignNotifierProvider.notifier).clearSignature();
        return true; // Cho phép thoát
      }
      return false; // Không thoát
    }
    // Nếu không có chữ ký tạm, cho phép thoát ngay
    return true;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final flightSignatureAsync = ref.watch(
      flightSignatureControllerProvider(supplyfromdetailId.first),
    );
    final signState = ref.watch(flightSignNotifierProvider);
    
    final hasTempSignature = useState(false);

    return WillPopScope(
      onWillPop: () async {
        // Gọi hàm xác nhận thoát
        final shouldPop = await _confirmExit(
          context, 
          ref, 
          hasTempSignature: hasTempSignature.value
        );
        return shouldPop;
      },
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBarWidget(
              title: 'Xác nhận',
              onWillPop: () async {
                if (hasTempSignature.value) {
                  final shouldPop = await _confirmExit(
                    context, 
                    ref, 
                    hasTempSignature: hasTempSignature.value
                  );
                  return shouldPop;
                }else{
                  Navigator.pop(context);
                }
              },
            ),
            body: flightSignatureAsync.when(
              data: (data) => SignatureContent(
                supplyfromId: supplyfromdetailId,
                signDetail: data,
                onRefresh: () => ref
                    .read(flightSignatureControllerProvider(supplyfromdetailId.first).notifier)
                    .getSingSupplyfrom(supplyfromdetailId.first),
                isSupplement: isSupplement,
                isSignAll: isSignAll,
                updateTempSignatureStatus: (hasSignature) {
                  hasTempSignature.value = hasSignature;
                },
              ),
              error: (_, __) => SignatureContent(
                supplyfromId: supplyfromdetailId,
                signDetail: SignSupplyfrom(),
                onRefresh: () => ref
                    .read(flightSignatureControllerProvider(supplyfromdetailId.first).notifier)
                    .getSingSupplyfrom(supplyfromdetailId.first),
                isSupplement: isSupplement,
                isSignAll: isSignAll,
                updateTempSignatureStatus: (hasSignature) {
                  hasTempSignature.value = hasSignature;
                },
              ),
              loading: () => _buildLoading(context),
            ),
          ),
          if (signState.isLoading)
            Container(
              color: Colors.black.withOpacity(0.2),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  Widget _buildLoading(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return LoadingShimmer(
      child: Padding(
        padding: EdgeInsets.all(16.r),
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
            Expanded(
              child: ContainerLoading(height: height * 0.26),
            ),
            SizedBox(height: AppSizes.spacingLarge.h),
            const TextWidget(
              paddingHorizontal: 16,
              text: 'NHÂN VIÊN XÁC NHẬN',
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            SizedBox(height: _kSpacing.h),
            Expanded(
              child: ContainerLoading(height: height * 0.26),
            ),
          ],
        ),
      ),
    );
  }
}