import 'package:flutter/material.dart';
import 'package:gnsa/common/widgets/text_widget.dart';
import 'package:gnsa/core/configs/theme/app_colors.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final double heightAppBar;
  final bool isBack;
  final IconData? iconRightFirst;
  final IconData? iconRightSecond;
  final Color? colorFirst;
  final Color? colorSecond;
  final bool isTitleCenter;
  final VoidCallback? onPressedFirst;
  final VoidCallback? onPressedSecond;
  final String? image;

  const AppBarWidget({
    Key? key,
    this.title,
    this.heightAppBar = 45,
    this.iconRightFirst,
    this.iconRightSecond,
    this.colorFirst,
    this.colorSecond,
    this.onPressedFirst,
    this.onPressedSecond,
    this.isBack = true,
    this.image,
    this.isTitleCenter = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: heightAppBar,
      backgroundColor: AppColors.white,
      leading: isBack
          ? IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back_ios,
                color: AppColors.primary,
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
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: AppColors.black,
      );
    } else if (image != null) {
      return Image.asset(
        image!,
        fit: BoxFit.cover,
        width: 100,
      );
    }
    return null;
  }

  List<Widget> _buildActions() {
    final actions = <Widget>[];
    if (iconRightSecond != null) {
      actions.add(
        IconButton(
          onPressed: onPressedSecond,
          icon: Icon(
            iconRightSecond,
            color: colorSecond,
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
            color: colorFirst,
          ),
        ),
      );
    }
    return actions;
  }

  @override
  Size get preferredSize => Size.fromHeight(heightAppBar);
}
