import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gnsa/common/design_system/tokens/app_sizes.dart';
import 'package:gnsa/core/configs/theme/app_colors.dart';
import 'package:gnsa/dio_api/providers/dio_provider.dart';
import 'package:gnsa/feature/presentation/flight_sign/data/model/flight_sign_arguments.dart';
import 'package:gnsa/feature/presentation/flight_sign/data/model/flight_sign_req.dart';
import 'package:gnsa/feature/presentation/flight_sign/domain/flight_sign_reponsitory.dart';
import 'package:gnsa/feature/presentation/flight_sign/presentation/provider/flight_sign_provider.dart';
import 'package:gnsa/feature/presentation/flight_sign/presentation/provider/providers.dart';
import 'package:gnsa/feature/presentation/flight_signature/data/model/flight_signature_model.dart';
import 'package:gnsa/feature/presentation/flight_signature/presentation/widget/custom_signature.dart';
import 'package:gnsa/router/app_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:gnsa/common/widgets/custom_button.dart';
import 'package:gnsa/common/widgets/text_widget.dart';
import 'package:path_provider/path_provider.dart';

const _idNotData = '00000000-0000-0000-0000-000000000000';

class SignatureContent extends HookConsumerWidget {
  final List<String> supplyfromId;
  final SignSupplyfrom signDetail;
  final VoidCallback onRefresh;
  final bool isSupplement;
  final bool isSignAll;
  final ValueChanged<bool> updateTempSignatureStatus; // Callback mới

  const SignatureContent({
    super.key,
    required this.supplyfromId,
    required this.signDetail,
    required this.onRefresh,
    required this.isSupplement,
    required this.isSignAll,
    required this.updateTempSignatureStatus, // Thêm callback mới
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tempCrewSignature = useState<Uint8List?>(null);
    final tempCrewName = useState<String?>(null);
    final tempEmployeeSignature = useState<Uint8List?>(null);
    final tempEmployeeName = useState<String?>(null);

    // Sử dụng effect để cập nhật trạng thái sau khi build
    useEffect(() {
      // Hàm kiểm tra trạng thái chữ ký tạm
      void checkTempSignature() {
        final hasTempSig = tempCrewSignature.value != null ||
            tempEmployeeSignature.value != null;
        updateTempSignatureStatus(hasTempSig);
      }

      // Kiểm tra lần đầu
      checkTempSignature();

      // Trả về hàm cleanup
      return () {};
    }, []);

    // Hàm cập nhật chữ ký và trạng thái
    void updateSignature(
      ValueNotifier<Uint8List?> signatureNotifier,
      ValueNotifier<String?> nameNotifier,
      dynamic result,
    ) {
      signatureNotifier.value = result['signatureBytes'] as Uint8List;
      nameNotifier.value = result['signedName'] as String;

      // Cập nhật trạng thái sau khi thay đổi
      final hasTempSig = tempCrewSignature.value != null ||
          tempEmployeeSignature.value != null;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        updateTempSignatureStatus(hasTempSig);
      });
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSizes.paddingMedium.r),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: AppSizes.spacingMedium.h,
        children: [
          Expanded(
            child: CustomSignature(
                crewInfo: signDetail.crew,
                isCrew: true,
                signatureBytes: tempCrewSignature.value,
                signedName: tempCrewName.value,
                onPressed: () async {
                  final result = await GoRouter.of(context).push(
                    AppRouter.flightSign,
                    extra: FlightSignArguments(
                      title: 'TIẾP VIÊN XÁC NHẬN',
                      supplyFormIds: supplyfromId,
                      signedName: tempCrewName.value ??
                          signDetail.crew?.signedInfo ??
                          '',
                      isSupplierSign: true,
                      isSupplement: isSupplement,
                    ),
                  );
                  if (result != null && result is Map) {
                    updateSignature(tempCrewSignature, tempCrewName, result);
                  }
                }),
          ),
          Expanded(
            child: CustomSignature(
                crewInfo: signDetail.employee,
                isCrew: false,
                signatureBytes: tempEmployeeSignature.value,
                signedName: tempEmployeeName.value,
                onPressed: () async {
                  final result = await GoRouter.of(context).push(
                    AppRouter.flightSign,
                    extra: FlightSignArguments(
                      title: 'NHÂN VIÊN XÁC NHẬN',
                      signedName: tempEmployeeName.value ??
                          signDetail.employee?.signedInfo ??
                          '',
                      supplyFormIds: supplyfromId,
                      isSupplierSign: false,
                      isSupplement: isSupplement,
                    ),
                  );
                  if (result != null && result is Map) {
                    updateSignature(
                        tempEmployeeSignature, tempEmployeeName, result);
                  }
                }),
          ),
          signDetail.employee?.id != _idNotData ||
                  signDetail.crew?.id != _idNotData ||
                  tempEmployeeSignature.value != null ||
                  tempCrewSignature.value != null ||
                  tempEmployeeName.value != null ||
                  tempCrewName.value != null
              ? _buildComfirm(
                  context: context,
                  ref: ref,
                  tempCrewSignature: tempCrewSignature.value,
                  tempCrewName: tempCrewName.value,
                  tempEmployeeSignature: tempEmployeeSignature.value,
                  tempEmployeeName: tempEmployeeName.value,
                )
              : const SizedBox(),
        ],
      ),
    );
  }

  Column _buildComfirm({
    required BuildContext context,
    required WidgetRef ref,
    required Uint8List? tempCrewSignature,
    required String? tempCrewName,
    required Uint8List? tempEmployeeSignature,
    required String? tempEmployeeName,
  }) {
    return Column(
      spacing: AppSizes.spacingSmall,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextWidget(
              text: 'Tổng số vật tư',
              fontSize: 12.sp,
              fontWeight: FontWeight.w300,
              color: AppColors.black,
            ),
            TextWidget(
              text: signDetail.totalSupply.toString(),
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.black,
            ),
          ],
        ),
        CustomButton(
          horizontalPadding: AppSizes.paddingMedium.r,
          onPressed: () async {
            final result = await saveSignatures(
              context,
              ref,
              crewSignature: tempCrewSignature,
              crewName: tempCrewName,
              employeeSignature: tempEmployeeSignature,
              employeeName: tempEmployeeName,
              supplyfromId: supplyfromId,
              isSupplement: isSupplement,
            );
            if (result) {
              Navigator.pop(context, true);
            }
          },
          color: AppColors.primary,
          text: 'Xác nhận',
        ),
        SizedBox(height: AppSizes.spacingMedium.h),
      ],
    );
  }
}

Future<bool> saveSignatures(
  BuildContext context,
  WidgetRef ref, {
  Uint8List? crewSignature,
  String? crewName,
  Uint8List? employeeSignature,
  String? employeeName,
  required List<String> supplyfromId,
  required bool isSupplement,
}) async {
  final flightSignUseCase = ref.read(flightSignUserCaseProvider);
  final notifier = ref.read(flightSignNotifierProvider.notifier);

  if (crewSignature != null && crewName != null) {
    await _saveSignature(
      notifier,
      flightSignUseCase,
      signatureBytes: crewSignature,
      signedName: crewName,
      isCrew: true,
      ref: ref,
      supplyFormDetailIds: supplyfromId,
      isSupplement: isSupplement,
    );
  }

  if (employeeSignature != null && employeeName != null) {
    await _saveSignature(
      notifier,
      flightSignUseCase,
      signatureBytes: employeeSignature,
      signedName: employeeName,
      isCrew: false,
      ref: ref,
      supplyFormDetailIds: supplyfromId,
      isSupplement: isSupplement,
    );
  }

  return true;
}

Future<void> _saveSignature(
  FlightSignNotifier notifier,
  FlightSignUserCase flightSignUseCase, {
  required Uint8List signatureBytes,
  required String signedName,
  required bool isCrew,
  required WidgetRef ref,
  required List<String> supplyFormDetailIds,
  required bool isSupplement,
}) async {
  final asyncRequestHandler = ref.read(asyncRequestHandlerProvider.notifier);

  final tempDir = await getTemporaryDirectory();
  final file = File(
      '${tempDir.path}/signature_${DateTime.now().millisecondsSinceEpoch}.png');
  await file.writeAsBytes(signatureBytes);

  notifier.state = const AsyncValue.loading();
  await asyncRequestHandler.execute(
    apiCall: () async {
      return await flightSignUseCase.saveSignature(
        FlightSignReq(
          supplyFormDetailIds: supplyFormDetailIds,
          signedName: signedName,
          isCrew: isCrew,
          signedFile: file,
          isSupplement: isSupplement,
        ),
      );
    },
    onSuccess: (response) {},
  );
}
