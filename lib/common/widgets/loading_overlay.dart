import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:gnsa/common/img/img.dart';

class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final bool? istwoloading;

  const LoadingOverlay({
    Key? key,
    required this.isLoading,
    required this.child,
    this.istwoloading
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child, 
        if (isLoading)
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.01), 
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  height: Get.height * 0.15,
                  width: Get.width * 0.3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white.withOpacity(0.8), // Nền sáng hơn cho loading
                  ),
                  child: Center(
                    child: Lottie.network(
                      Img.loading,
                      width: Get.width * 0.4,
                    ),
                  ),
                ),
              ),
            ),
          ),
          if(istwoloading == true)    
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.01), 
            ),
          ),
      ],
    );
  }
}
