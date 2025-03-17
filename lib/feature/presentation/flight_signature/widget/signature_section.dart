
import 'package:flutter/widgets.dart';
import 'package:gnsa/feature/presentation/flight_signature/widget/custom_signature.dart';
import 'package:gnsa/router/app_router.dart';
import 'package:go_router/go_router.dart';

class SignatureSection extends StatelessWidget {
  final String title;
  final String imageUrl;
  final bool isSupplierSign;
  final List<String> supplyfromId;
  final VoidCallback onRefresh;

  const SignatureSection({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.isSupplierSign,
    required this.supplyfromId,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CustomSignature(
        title: title,
        imageUrl: imageUrl,
        onPressed: () => _navigateToSignature(context),
        onEditPressed: () => _navigateToSignature(context),
      ),
    );
  }

  Future<void> _navigateToSignature(BuildContext context) async {
    final result = await context.push(
      AppRouter.flightSign,
      extra: {
        'title': title,
        'supplyFormIds': supplyfromId,
        'isSupplierSign': isSupplierSign,
      },
    );

    if (result == true) {
      Future.microtask(onRefresh);
    }
  }
}