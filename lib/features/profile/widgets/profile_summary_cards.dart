import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../config/theme/app_colors.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_state.dart';

class ProfileSummaryCards extends StatelessWidget {
  const ProfileSummaryCards({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        String ordersCount = '0';
        String totalSpent = '₹0';

        if (state is AuthAuthenticated) {
          // Future plan: Fetch these from a real OrdersBloc
          // For now, let's keep them dynamic-looking but with defaults
          ordersCount = '0';
          totalSpent = '₹0';
        }

        return Transform.translate(
          offset: const Offset(0, -20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                    child: SummaryCard(value: ordersCount, label: 'Total orders')),
                const SizedBox(width: 12),
                Expanded(
                    child: SummaryCard(value: totalSpent, label: 'Total spent')),
              ],
            ),
          ),
        );
      },
    );
  }
}

class SummaryCard extends StatelessWidget {
  final String value;
  final String label;

  const SummaryCard({super.key, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        children: [
          Text(value,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black121212)),
          Text(label,
              style: const TextStyle(fontSize: 12, color: AppColors.grey707070)),
        ],
      ),
    );
  }
}
