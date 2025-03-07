import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gnsa/common/widgets/text_widget.dart';
import 'package:gnsa/core/configs/theme/app_colors.dart' show AppColors;

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final double? heightAppBar;
  final bool? isTrueBack;
  final IconData? iconRightfirst;
  final IconData? iconRightSecond;
  final Color? colorfirst;
  final Color? colorSecond;
  final bool? isBack;
  final bool? isTitleCenter;
  final Function()? functionfirst;
  final Function()? functionSecond;
  final String? image;

  const AppBarWidget(
      {super.key,
       this.title,
      this.heightAppBar = 45,
      this.isTrueBack,
      this.iconRightfirst,
      this.iconRightSecond,
      this.colorfirst,
      this.colorSecond,
      this.functionfirst,
      this.functionSecond,
      this.isBack = true,
      this.image,
      this.isTitleCenter = true});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: heightAppBar,
      backgroundColor: AppColors.white,
      leading: isBack == false
          ? null
          : IconButton(
              onPressed: () {
                Get.back(result: isTrueBack ?? false);
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: AppColors.primary,
              ),
            ),
      centerTitle: isTitleCenter,
      title: title == null
          ? Image.asset(image!,fit: BoxFit.cover, width: 100,)
          : TextWidget(
              text: title!,
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
            ),
      actions: [
        iconRightSecond != null
            ? IconButton(
                onPressed: () {
                  functionSecond?.call();
                },
                icon: Icon(
                  iconRightSecond,
                  color: colorSecond,
                ),
              )
            : const SizedBox(),
        iconRightfirst != null
            ? IconButton(
                onPressed: () {
                  functionfirst?.call();
                },
                icon: Icon(
                  iconRightfirst,
                  color: colorfirst,
                ))
            : const SizedBox(),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(heightAppBar ?? kToolbarHeight);
}
