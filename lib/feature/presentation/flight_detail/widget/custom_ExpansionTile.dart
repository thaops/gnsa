import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gnsa/common/widgets/custom_text_field.dart';
import 'package:gnsa/common/widgets/text_widget.dart';
import 'package:gnsa/core/configs/theme/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gnsa/feature/presentation/flight_detail/controller/flight_Detail_controller.dart';

class CustomExpansionTile extends StatefulWidget {
  final Color? backgroundColor;
  const CustomExpansionTile({super.key, this.backgroundColor});

  @override
  State<CustomExpansionTile> createState() => _CustomExpansionTileState();
}

class _CustomExpansionTileState extends State<CustomExpansionTile> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FlightDetailController());
    return   Container(
      width: Get.width * 0.9,
      padding:  EdgeInsets.all(8.r),
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? AppColors.backgroundTab,
        borderRadius: BorderRadius.circular(18),
      ),
      child:  ExpansionTile(
          collapsedShape: const RoundedRectangleBorder(
            side: BorderSide.none,
          ),
          shape: const RoundedRectangleBorder(
            side: BorderSide.none,
          ),
          trailing: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const TextWidget(
                text: '15',
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              SizedBox(height: 10.h),
              Container(
                height: 16.h,
                width: 80.w,
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: AppColors.textSuccess,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check, color: AppColors.white, size: 12.sp),
                    SizedBox(width: 3.w),
                    const TextWidget(
                      text: 'Đã Xác nhận',
                      fontSize: 8,
                      fontWeight: FontWeight.w500,
                      color: AppColors.white,
                    ),
                  ],
                ),
              ),
            ],
          ),
          title: const TextWidget(
            text: 'Suất ăn - Hạng PE & Y',
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          leading: Icon(
            Icons.airplane_ticket,
            color: AppColors.iconFlight,
          ),
          subtitle: const TextWidget(
            text: 'Mã code: 1234',
            fontSize: 14,
            fontWeight: FontWeight.w300,
          ),
          children: <Widget>[
            SizedBox(
              child: ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: 2,
                itemBuilder: (context, index) => ExpansionTile(
                  backgroundColor: AppColors.backgroundTab,
                  iconColor: AppColors.primary,
                  collapsedIconColor: AppColors.primary,
                  title: const TextWidget(
                    text: 'HÀNG KHO NGOẠI QUAN',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  children: <Widget>[
                    SizedBox(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: 2,
                        itemBuilder: (context, index) => Container(
                          color: AppColors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 8),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      TextWidget(
                                        text: 'Nước tinh khiết Aquafina 1,5L',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      SizedBox(height: 6.h),
                                      TextWidget(
                                        text: 'Cung ứng: 10',
                                        fontSize: 14,
                                        color: AppColors.iconFlight,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ],
                                  ),
                                  Obx(
                                    () => controller.isEdit.value
                                        ? Row(
                                            children: [
                                              IconButton(
                                                onPressed: () {
                                                  controller.isEdit.value =
                                                      !controller.isEdit.value;
                                                },
                                                icon: Icon(
                                                  Icons.delete,
                                                  color: AppColors.iconFlight,
                                                ),
                                              ),
                                              Icon(
                                                Icons.check,
                                                color: AppColors.iconFlight,
                                              ),
                                            ],
                                          )
                                        : IconButton(
                                            onPressed: () {
                                              controller.isEdit.value =
                                                  !controller.isEdit.value;
                                            },
                                            icon: Icon(
                                              Icons.edit_note_sharp,
                                              color: AppColors.iconFlight,
                                            ),
                                          ),
                                  ),
                                ],
                              ),
                              Obx(() => controller.isEdit.value
                                  ? Container(
                                      margin: EdgeInsets.only(top: 8.h),
                                      width: Get.width,
                                      child: CustomTextField(
                                        borderColor: Colors.transparent,
                                        backgroundColor:
                                            AppColors.backgroundTab,
                                        hintText: 'Ghi chú',
                                        controller:
                                            controller.noteController.value,
                                      ),
                                    )
                                  : SizedBox()),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      
    );
  }
}
