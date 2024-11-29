import 'package:flutter/material.dart';
import 'package:gnsa/common/widgets/custom_button.dart';
import 'package:get/get.dart';
import 'package:gnsa/common/widgets/text_widget.dart';
import 'package:gnsa/core/configs/theme/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomDialog {
  Future<bool?> showConfirmationDialog(String title, String content,
      {dynamic? data}) {
    return Get.dialog<bool>(
      Dialog(
        child: Container(
          width: MediaQuery.of(Get.context!).size.width *
              0.9, 
          padding: EdgeInsets.all(20), // Padding cho nội dung
          child: Column(
            mainAxisSize: MainAxisSize.min, // Để chiều cao tự động điều chỉnh
            children: [
              20.verticalSpace,
              TextWidget(
                  text: title,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black), // Đổi màu tiêu đề thành đen
              SizedBox(height: 10), // Khoảng cách giữa tiêu đề và nội dung
              TextWidget(
                  text: content,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: AppColors.grey), // Đổi màu nội dung thành xám
              30.verticalSpace, // Khoảng cách dưới nội dung
              Row(
                // Sử dụng Row để chứa các nút
                children: [
                  Expanded(
                    child: CustomButton(
                      text: 'Hủy',
                      color: AppColors.primary,
                      textColor: AppColors.black,
                      onPressed: () {
                        Get.back(result: false);
                      },
                      isOutlined: true,
                    ),
                  ),
                  SizedBox(width: 10), // Khoảng cách giữa hai nút
                  Expanded(
                    child: CustomButton(
                      text: 'Có',
                      color: AppColors.primary,
                      textColor: AppColors.white,
                      onPressed: (data == null ||
                              (data != null && data.isNotEmpty))
                          ? () {
                              Get.back(result: true);
                            }
                          : () => Get.snackbar("Thông báo",
                              "Vui lòng đợi 3 giây rồi thử lại"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
}
