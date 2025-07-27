import 'package:flutter/material.dart';
import 'package:gnsa/common/design_system/tokens/app_sizes.dart';
import 'package:gnsa/common/widgets/container_loading.dart';

class CustomLoadingCase extends StatelessWidget {
  const CustomLoadingCase({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
         ContainerLoading(height: AppSizes.heightXXXXLarge),
         SizedBox(height: AppSizes.paddingMedium),
         Expanded(
           child: ListView.separated(
            itemCount: 5,
            itemBuilder: (context, index) {
              return ContainerLoading(height: AppSizes.heightMedium);
            },
            separatorBuilder: (context, index) {
              return const SizedBox(height: 8);
            },
           ),
         )
      ],
    );
  }
}