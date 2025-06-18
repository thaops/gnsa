import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gnsa/common/widgets/text_widget.dart';
import 'package:gnsa/core/configs/theme/app_colors.dart';
import 'custom_popup_menu_button.dart'; // Import file chứa CustomPopupMenuButton

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final double heightAppBar;
  final bool isBack;
  final IconData? iconRightFirst;
  final IconData? iconRightSecond;
  final Color? colorFirst;
  final Color? colorSecond;
  final double? sizeTitle;
  final bool isTitleCenter;
  final VoidCallback? onPressedFirst;
  final VoidCallback? onPressedSecond;
  final String? image;
  final Widget? widgetRight;
  // Thêm thuộc tính cho CustomPopupMenuButton
  final List<PopupMenuEntry<String>>? popupMenuItems;
  final ValueChanged<String>? onPopupMenuSelected;

  const AppBarWidget({
    Key? key,
    this.title,
    this.heightAppBar = 45,
    this.iconRightFirst,
    this.iconRightSecond,
    this.colorFirst,
    this.colorSecond,
    this.sizeTitle,
    this.onPressedFirst,
    this.onPressedSecond,
    this.isBack = true,
    this.image,
    this.isTitleCenter = true,
    this.widgetRight,
    this.popupMenuItems,
    this.onPopupMenuSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: AppColors.white,
      leading: isBack
          ? IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                Icons.arrow_back_ios,
                color: AppColors.primary,
                size: 20.sp, 
              ),
            )
          : null,
      centerTitle: isTitleCenter,
      title: _buildTitle(),
      actions: _buildActions(),
    );
  }

  Widget? _buildTitle() {
    if (title != null) {
      return TextWidget(
        text: title!,
        fontSize: sizeTitle ?? 16.sp,
        fontWeight: FontWeight.w600,
        color: AppColors.black,
      );
    } else if (image != null) {
      return Image.asset(
        image!,
        fit: BoxFit.cover,
        width: 100.w, 
      );
    }
    return null;
  }

  List<Widget> _buildActions() {
    final actions = <Widget>[];

    // Thêm CustomPopupMenuButton nếu có popupMenuItems
    if (popupMenuItems != null && onPopupMenuSelected != null) {
      actions.add(
        CustomPopupMenuButton<String>(
          items: popupMenuItems!,
          onSelected: onPopupMenuSelected!,
          icon: Icon(
            Icons.more_horiz,
            color: AppColors.primary,
            size: 24.sp, 
          ),
          backgroundColor: AppColors.white,
          elevation: 8.0,
          borderRadius: BorderRadius.circular(8.r), 
          padding: EdgeInsets.all(8.w), 
          animationDuration: const Duration(milliseconds: 200),
          animationCurve: Curves.easeInOut,
          textStyle: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: AppColors.black,
          ),
          tooltip: 'Menu',
        ),
      );
    }

    if (widgetRight != null)
      actions.add(
        Container(
          constraints: BoxConstraints(maxWidth: 50, maxHeight: 50), // Ensure constraints
          child: widgetRight,
        ),
      );

    // Thêm các icon khác nếu có
    if (iconRightSecond != null) {
      actions.add(
        IconButton(
          onPressed: onPressedSecond,
          icon: Icon(
            iconRightSecond,
            color: colorSecond ?? AppColors.primary,
            size: 24.sp,
          ),
        ),
      );
    }
    if (iconRightFirst != null) {
      actions.add(
        IconButton(
          onPressed: onPressedFirst,
          icon: Icon(
            iconRightFirst,
            color: colorFirst ?? AppColors.primary,
            size: 24.sp,
          ),
        ),
      );
    }

    return actions;
  }

  @override
  Size get preferredSize => Size.fromHeight(heightAppBar.h); 
}