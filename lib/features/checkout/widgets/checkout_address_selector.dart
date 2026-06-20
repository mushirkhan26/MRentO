import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../config/navigation/app_routes.dart';
import '../../../config/theme/app_colors.dart';
import '../../../core/models/address_model.dart';
import '../../settings/bloc/address_bloc.dart';
import '../../settings/bloc/address_state.dart';

class CheckoutAddressSelector extends StatelessWidget {
  final AddressModel? selectedAddress;
  final Function(AddressModel) onAddressSelected;

  const CheckoutAddressSelector({
    super.key,
    required this.selectedAddress,
    required this.onAddressSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Delivery address',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              TextButton(
                onPressed: () => context.push(AppRoutes.addressBook),
                child: const Text(
                  'Manage',
                  style: TextStyle(
                    color: AppColors.primaryDarkGreen,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        BlocBuilder<AddressBloc, AddressState>(
          builder: (context, state) {
            if (state is AddressLoading) {
              return const Center(
                  child: Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              ));
            }

            if (state is AddressLoaded) {
              if (state.addresses.isEmpty) {
                return _buildNoAddress(context);
              }

              // Default selection logic if none selected
              if (selectedAddress == null && state.addresses.isNotEmpty) {
                final defaultAddr = state.addresses.firstWhere(
                  (a) => a.isDefault,
                  orElse: () => state.addresses.first,
                );
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  onAddressSelected(defaultAddr);
                });
              }

              return Column(
                children: state.addresses.map((address) {
                  return _addressCard(address);
                }).toList(),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  Widget _buildNoAddress(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.errorRed.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.errorRed.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          const Text(
            'Koi saved address nahi mila',
            style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.errorRed),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () => context.push(AppRoutes.addressBook),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlack,
              foregroundColor: Colors.white,
            ),
            child: const Text('Add Address'),
          ),
        ],
      ),
    );
  }

  Widget _addressCard(AddressModel address) {
    final bool isSelected = selectedAddress?.id == address.id;

    return GestureDetector(
      onTap: () => onAddressSelected(address),
      child: Container(
        margin: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryYellow
                : AppColors.greyOutline.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              isSelected ? Icons.check_circle : Icons.circle_outlined,
              color: isSelected ? AppColors.primaryYellow : AppColors.grey300,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        address.tag,
                        style: const TextStyle(
                          color: AppColors.grey500,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (address.isDefault) ...[
                        const SizedBox(width: 8),
                        const Text(
                          'DEFAULT',
                          style: TextStyle(
                            color: AppColors.primaryYellow,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    address.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${address.streetAddress}, ${address.city} - ${address.zipCode}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.grey707070,
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
