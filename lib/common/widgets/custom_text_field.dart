import 'package:flutter/material.dart';
import 'package:gnsa/core/configs/theme/app_colors.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final Function()? onTap;
  final bool obscureText; // Trạng thái ẩn/hiện mật khẩu
  final IconData? suffixIcon; // Icon hiển thị bên phải
  final Function(String)? onSubmit;
  final Function(String)? onChanged;
  final FocusNode? focusNode;
  final double? width;
  final bool isMobile;
  final IconData? prefixIcon;
  final double? borderWidth;
  final Color? backgroundColor;
  final double? borderRadius;
  final Color? borderColor;
  final double? fontSize;
  final int? maxLength;
  final int? maxLines;
  final int? minLines;
  final double? paddingVertical;
  final double? paddingHorizontal;
  final Color? colorIconSuffix;
  final Function()? onSuffixTap;
  final bool? isNumberic;
  final Function()? onPrefixTap;
  final TextInputType? keyboardType;


  CustomTextField({
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.suffixIcon,
    this.onTap,
    this.onSubmit,
    this.focusNode,
    this.width,
    this.isMobile = false,
    this.prefixIcon,
    this.borderWidth,
    this.backgroundColor,
    this.borderRadius = 12,
    this.borderColor,
    this.fontSize,
    this.maxLength,
    this.maxLines = 1,
    this.minLines = 1,
    this.paddingVertical,
    this.paddingHorizontal,
    this.colorIconSuffix,
    this.onSuffixTap,
    this.isNumberic = false,
    this.onChanged,
    this.onPrefixTap,
    this.keyboardType
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: widget.paddingHorizontal ?? 0,
          vertical: widget.paddingVertical ?? 0),
      child: Container(
        width: widget.width,
        decoration: widget.backgroundColor != null
            ? BoxDecoration(
                color: widget.backgroundColor ?? Colors.transparent,
                borderRadius: BorderRadius.circular(widget.borderRadius ?? 12),
              )
            : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              focusNode: widget.focusNode,
              controller: widget.controller,
              maxLength: widget.maxLength,
              minLines: widget.minLines,
              maxLines: widget.maxLines,
              keyboardType:widget.keyboardType ?? (widget.isNumberic == true ? TextInputType.number : TextInputType.text) , 
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: AppColors.black),
              textAlignVertical: TextAlignVertical.center,
              onTap: widget.onTap,
              obscureText: _obscureText,
              onSubmitted: widget.onSubmit,
              onChanged: widget.onChanged,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                    horizontal: widget.isMobile ? 12 : 24,
                    vertical: widget.isMobile ? 12 : 12),
                hintText: widget.hintText,
                errorBorder: InputBorder.none,
                hintStyle: TextStyle(
                    fontSize: widget.fontSize ?? 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade600),
                focusedBorder: OutlineInputBorder(
                  borderRadius:
                      BorderRadius.circular(widget.borderRadius ?? 12),
                  borderSide: BorderSide(
                      color: widget.borderColor ?? AppColors.primary),
                  // Màu border khi focus
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                      widget.borderRadius ?? 12), // Đặt độ bo tròn
                  borderSide: BorderSide(
                      color: widget.borderColor ?? Colors.grey.shade400,
                      width: widget.borderWidth ??
                          1), // Màu border khi không focus
                ),
                prefixIcon: widget.prefixIcon != null
                    ? IconButton(
                      onPressed: widget.onPrefixTap,
                      icon: Icon(
                          widget.prefixIcon,
                          size: 24,
                        ),
                    )
                    : null,
                suffixIcon: widget.suffixIcon != null
                    ? IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_off
                              : widget.suffixIcon,
                          size: 24,
                        ),
                        color:widget.colorIconSuffix ?? AppColors.colorIcon,
                        onPressed: widget.onSuffixTap ?? _togglePasswordVisibility,
                      )
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
