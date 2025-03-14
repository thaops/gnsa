// custom_expansion_tile.dart
import 'package:flutter/material.dart';
import 'package:gnsa/common/widgets/text_widget.dart';
import 'package:gnsa/core/configs/theme/app_colors.dart';
import 'package:gnsa/feature/presentation/flight_detail/model/flight_detail_model.dart';
import 'package:gnsa/feature/presentation/flight_detail/widget/child_expansion.dart';

class CustomExpansionTile extends StatefulWidget {
  final Color? backgroundColor;
  final String title;
  final String subtitle;
  final IconData leadingIcon;
  final String trailingCount;
  final bool isConfirmed;
  final bool isExpanded;
  final VoidCallback? onTap;
  final SupplyForm? supplyForm;

  const CustomExpansionTile({
    Key? key,
    this.backgroundColor,
    required this.title,
    required this.subtitle,
    required this.leadingIcon,
    required this.trailingCount,
    required this.isConfirmed,
    required this.isExpanded,
    this.onTap,
    this.supplyForm,
  }) : super(key: key);

  @override
  State<CustomExpansionTile> createState() => _CustomExpansionTileState();
}

class _CustomExpansionTileState extends State<CustomExpansionTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? AppColors.backgroundTab,
        borderRadius: BorderRadius.circular(18),
      ),
      child: ExpansionTile(
        collapsedShape: const RoundedRectangleBorder(side: BorderSide.none),
        shape: const RoundedRectangleBorder(side: BorderSide.none),
        leading: Icon(widget.leadingIcon, color: AppColors.iconFlight),
        title: TextWidget(
          text: widget.title,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        subtitle: TextWidget(
          text: widget.subtitle,
          fontSize: 14,
          fontWeight: FontWeight.w300,
        ),
        trailing: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextWidget(
              text: widget.trailingCount,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            widget.isConfirmed ? _ComfimerWidget() : const SizedBox(),
          ],
        ),
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.supplyForm?.supplies?.length ?? 0,
            itemBuilder: (context, outerIndex) => ExpansionTile(
              backgroundColor: AppColors.backgroundTab,
              iconColor: AppColors.primary,    
              title:  TextWidget(
                text:widget.supplyForm?.supplies?[outerIndex].supplys.toString() ?? '',
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.supplyForm?.supplies?[outerIndex].items?.length ?? 0,
                  itemBuilder: (context, innerIndex) =>  ChildExpansion(
                    supplyItem: widget.supplyForm?.supplies?[outerIndex].items?[innerIndex],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _ComfimerWidget() {
    return Column(
      children: [
        const SizedBox(height: 10),
        Container(
                height: 16,
                width: 80,
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.textSuccess,
                  borderRadius: BorderRadius.circular(10),
                ),
                child:const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check, color: AppColors.white, size: 12),
                     SizedBox(width: 3),
                    TextWidget(
                      text: "Đã Xác nhận",
                      fontSize: 8,
                      fontWeight: FontWeight.w500,
                      color: AppColors.white,
                    ),
                  ],
                ),
              ),
      ],
    );
  }
}
