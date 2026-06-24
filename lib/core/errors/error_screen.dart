import 'package:flutter/material.dart';

import '../../config/theme/app_colors.dart';
import '../../widgets/custom_button.dart';
import '../constants/app_constants.dart';

class ErrorScreen extends StatelessWidget {
  final String error;
  final String? title;
  final VoidCallback? onRetry;

  const ErrorScreen({super.key, required this.error, this.title, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.paddingLarge),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Error Icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.errorRed.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.error_outline_rounded, size: 60, color: AppColors.errorRed),
              ),

              const SizedBox(height: AppConstants.spacingLarge),

              // Error Title
              Text(title ?? 'Arre! Kuch gadbad ho gayi', textAlign: TextAlign.center),

              const SizedBox(height: AppConstants.spacingMedium),

              // Error Message
              Container(
                padding: const EdgeInsets.all(AppConstants.paddingMedium),
                decoration: BoxDecoration(
                  color: AppColors.errorRed.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                  border: Border.all(color: AppColors.errorRed.withValues(alpha: 0.2), width: 1),
                ),
                child: Text(
                  _getFormattedError(),
                  // style: theme.textTheme.bodyMedium?.copyWith(
                  //   color: AppTheme.textSecondary,
                  // ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: AppConstants.spacingXLarge),

              // Action Buttons
              Column(
                children: [
                  // Retry Button (if onRetry is provided)
                  if (onRetry != null) ...[
                    CustomButton(
                      text: 'Phir se try karein',
                      onPressed: onRetry!,
                      icon: Icons.refresh_rounded,
                    ),

                    const SizedBox(height: AppConstants.spacingMedium),
                  ],

                  // Go Home Button
                  CustomButton(text: 'Home par jayein', onPressed: () => {}, icon: Icons.home_rounded),
                ],
              ),

              const SizedBox(height: AppConstants.spacingLarge),

              // Support Link
              TextButton.icon(
                onPressed: () => {},
                icon: Icon(Icons.support_agent_rounded, size: 18, color: AppColors.primaryDarkGreen),
                label: Text('Support se baat karein'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getFormattedError() {
    // Format common error messages for better user experience
    final lowerError = error.toLowerCase();

    if (lowerError.contains('network') || lowerError.contains('connection')) {
      return 'Internet nahi chal raha hai. Connection check karke phir se try karein.';
    }

    if (lowerError.contains('timeout')) {
      return 'Request mein zyada time lag raha hai. Network check karein.';
    }

    if (lowerError.contains('not found') || lowerError.contains('404')) {
      return 'Maaf kijiye, humein yeh nahi mila.';
    }

    if (lowerError.contains('unauthorized') || lowerError.contains('401')) {
      return 'Aapko login karna padega.';
    }

    if (lowerError.contains('forbidden') || lowerError.contains('403')) {
      return 'Aapko yahan jaane ki permission nahi hai.';
    }

    if (lowerError.contains('server') || lowerError.contains('500')) {
      return 'Humare server mein kuch dikkat hai. Thodi der baad try karein.';
    }

    // Return original error if no specific formatting applies
    return error.length > 100 ? '${error.substring(0, 100)}...' : error;
  }
}

// Specialized error screens
class NetworkErrorScreen extends ErrorScreen {
  const NetworkErrorScreen({super.key, super.onRetry})
    : super(
        error: 'Internet nahi chal raha hai. Connection check karke phir se try karein.',
        title: 'Network nahi mil raha',
      );
}

class NotFoundErrorScreen extends ErrorScreen {
  const NotFoundErrorScreen({super.key})
    : super(error: 'Maaf kijiye, humein yeh nahi mila.', title: 'Nahi mila');
}

class ServerErrorScreen extends ErrorScreen {
  const ServerErrorScreen({super.key, super.onRetry})
    : super(
        error: 'Humare server mein kuch dikkat hai. Thodi der baad try karein.',
        title: 'Server ki dikat',
      );
}

class UnauthorizedErrorScreen extends ErrorScreen {
  const UnauthorizedErrorScreen({super.key})
    : super(error: 'Aapko login karna padega.', title: 'Login zaroori hai');
}
