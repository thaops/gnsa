import 'package:flutter/material.dart';
import 'package:gnsa/common/design_system/tokens/app_sizes.dart';
import 'package:gnsa/common/img/img.dart';
import 'package:gnsa/common/widgets/app_bar_widget.dart';
import 'package:gnsa/common/widgets/custom_button.dart';
import 'package:gnsa/core/configs/theme/app_colors.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PreviewView extends StatelessWidget {
  const PreviewView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Xem trước',
      ),
      body:   SizedBox.expand(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                // child: WebViewWidget(
                //   controller: WebViewController()
                //     ..setJavaScriptMode(JavaScriptMode.unrestricted)
                //     ..loadRequest(Uri.parse('https://assets.grok.com/users/26f2a6a3-36eb-459b-92ac-666cfb4dab7b/6eddd8f9-0bec-4a7d-86a3-6896c0173535/content')),
                // ),
                child: Image.asset(
                  Img.preview,
                  fit: BoxFit.contain,
                ),
              ),
              CustomButton(
                horizontalPadding: AppSizes.paddingLarge,
                width: MediaQuery.of(context).size.width * 0.4,
                text: 'In phiếu',
                color: AppColors.primary,
                onPressed: () {},
              ),
              SizedBox(height: AppSizes.paddingSmall)
            ],
          ),
      ),
      
    );
  }
}