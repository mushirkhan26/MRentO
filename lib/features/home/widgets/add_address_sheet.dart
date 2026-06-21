import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../config/theme/app_colors.dart';
import '../../../core/models/address_model.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_state.dart';
import '../../settings/bloc/address_bloc.dart';
import '../../settings/bloc/address_event.dart';

class AddAddressSheet extends StatefulWidget {
  const AddAddressSheet({super.key});

  @override
  State<AddAddressSheet> createState() => _AddAddressSheetState();
}

class _AddAddressSheetState extends State<AddAddressSheet> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _streetController = TextEditingController();
  final _cityController = TextEditingController(text: 'Jodhpur'); // Default for now
  final _areaController = TextEditingController(text: 'Baldev Nagar'); // Default for now
  final _mapsLinkController = TextEditingController();
  String _selectedTag = 'Home';
  bool _isMyself = true;

  @override
  void initState() {
    super.initState();
    _prefillUserInfo();
  }

  void _prefillUserInfo() {
    if (_isMyself) {
      final authState = context.read<AuthBloc>().state;
      if (authState is AuthAuthenticated) {
        _nameController.text = authState.user.name;
        _phoneController.text = authState.user.mobile ?? '';
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _areaController.dispose();
    _mapsLinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.exploreBackground,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Pull Handle
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.grey300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back, color: AppColors.primaryBlack),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'Add address details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryBlack,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. Address Details Card
                      _buildSectionTitle('Address details'),
                      _buildSectionCard([
                        _buildAddressSelector('City', _cityController.text, Icons.apartment),
                        const Divider(height: 1),
                        _buildAddressSelector('Area, street', _areaController.text, Icons.location_on_outlined),
                        const SizedBox(height: 12),
                        _buildPlainTextField(_streetController, 'Enter complete address*', 
                          hint: 'Example: 4th Floor, Plot No. B-17, Block B, South Extension Part I'),
                        const SizedBox(height: 12),
                        _buildGoogleMapsField(),
                      ]),

                      const SizedBox(height: 24),

                      // 2. Contact Details Card
                      _buildSectionTitle('Contact details'),
                      _buildSectionCard([
                        _buildContactTypeSelector(),
                        const SizedBox(height: 16),
                        _buildPlainTextField(_nameController, 'Receiver\'s name*'),
                        const SizedBox(height: 12),
                        _buildPhoneTextField(_phoneController, 'Receiver\'s phone number*'),
                        const SizedBox(height: 24),
                        const Text(
                          'Save address as',
                          style: TextStyle(fontSize: 14, color: AppColors.grey500),
                        ),
                        const SizedBox(height: 12),
                        _buildTagChips(),
                      ]),

                      const SizedBox(height: 32),

                      // Next Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _saveAddress,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Next',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.primaryBlack),
      ),
    );
  }

  Widget _buildSectionCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildAddressSelector(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: AppColors.grey100, borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: AppColors.primaryYellow, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: AppColors.grey500, fontSize: 12)),
                Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              ],
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const Text('Change', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildPlainTextField(TextEditingController controller, String label, {String? hint}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.grey400, fontSize: 12),
        labelStyle: const TextStyle(color: AppColors.grey400, fontSize: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.grey100)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.grey100)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget _buildGoogleMapsField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.grey100),
      ),
      child: Row(
        children: [
          Image.network('https://upload.wikimedia.org/wikipedia/commons/thumb/3/39/Google_Maps_icon_%282015-2020%29.svg/1024px-Google_Maps_icon_%282015-2020%29.svg.png', width: 20, height: 20, errorBuilder: (c, e, s) => const Icon(Icons.map, size: 20, color: Colors.blue)),
          const SizedBox(width: 12),
          const Expanded(
            child: Text('Add google maps link (optional)', style: TextStyle(color: AppColors.grey400, fontSize: 13)),
          ),
        ],
      ),
    );
  }

  Widget _buildContactTypeSelector() {
    return Row(
      children: [
        _buildRadioOption('Myself', _isMyself, () {
          setState(() {
            _isMyself = true;
            _prefillUserInfo();
          });
        }),
        const SizedBox(width: 24),
        _buildRadioOption('Someone else', !_isMyself, () {
          setState(() {
            _isMyself = false;
            _nameController.clear();
            _phoneController.clear();
          });
        }),
      ],
    );
  }

  Widget _buildRadioOption(String title, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(isSelected ? Icons.radio_button_checked : Icons.radio_button_off, 
            color: isSelected ? Colors.green : AppColors.grey400, size: 22),
          const SizedBox(width: 8),
          Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildPhoneTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.grey400, fontSize: 14),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.grey100)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.grey100)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        suffixIcon: const Icon(Icons.contact_page_outlined, color: AppColors.primaryBlack),
      ),
    );
  }

  Widget _buildTagChips() {
    final tags = [
      {'label': 'Home', 'icon': Icons.home_outlined},
      {'label': 'Work', 'icon': Icons.work_outline},
      {'label': 'Hotel', 'icon': Icons.apartment_outlined},
      {'label': 'Other', 'icon': Icons.people_outline},
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: tags.map((tag) {
        final isSelected = _selectedTag == tag['label'];
        return GestureDetector(
          onTap: () => setState(() => _selectedTag = tag['label'] as String),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? Colors.green.withValues(alpha: 0.1) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isSelected ? Colors.green : AppColors.grey100),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(tag['icon'] as IconData, color: isSelected ? Colors.green : AppColors.grey500, size: 18),
                const SizedBox(width: 6),
                Text(tag['label'] as String, style: TextStyle(color: isSelected ? Colors.green : AppColors.grey500, fontSize: 13, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  void _saveAddress() {
    if (_nameController.text.isEmpty || _phoneController.text.isEmpty || _streetController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      final newAddress = AddressModel(
        id: '',
        name: _nameController.text,
        phone: _phoneController.text,
        streetAddress: _streetController.text,
        city: _cityController.text,
        state: 'Rajasthan', // Default for now
        zipCode: '342001', // Default for now
        tag: _selectedTag,
      );

      context.read<AddressBloc>().add(AddAddress(authState.user.userId, newAddress));
      Navigator.pop(context);
    }
  }
}
