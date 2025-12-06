import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../core/common_widgets.dart';
import '../../core/localization.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(context.loc('privacy_policy')),
        backgroundColor: AppColors.backgroundLight,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: AppContainers.card(
          context: context,
          padding: const EdgeInsets.all(16),
          child: Text(
            context.loc('privacy_policy_message'),
            style: AppTextStyles.getAdaptiveStyle(context, fontSize: 14),
          ),
        ),
      ),
    );
  }
}
