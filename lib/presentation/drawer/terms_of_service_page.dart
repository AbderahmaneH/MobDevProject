import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../core/common_widgets.dart';
import '../../core/localization.dart';

class TermsOfServicePage extends StatelessWidget {
  const TermsOfServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(title: Text(context.loc('terms_of_service')),
        backgroundColor: AppColors.backgroundLight,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: AppContainers.card(
          context: context,
          padding: const EdgeInsets.all(16),
          child: Text(context.loc('terms_of_service_message'),
            style: AppTextStyles.getAdaptiveStyle(context, fontSize: 14),
          ),
        ),
      ),
    );
  }
}