import 'package:flutter/material.dart';
import '../../../config/theme/app_colors.dart';

// ─────────────────────────────────────────────────────────────────
// PAGE 1 — Welcome
// ─────────────────────────────────────────────────────────────────
class WelcomePage extends StatelessWidget {
  final VoidCallback onGetStarted;
  const WelcomePage({super.key, required this.onGetStarted});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryBlack,
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Spacer(),
                        // Logo
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.primaryYellow,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(
                            Icons.construction_rounded,
                            size: 48,
                            color: AppColors.primaryBlack,
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Title
                        const Text(
                          'MRentO',
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            height: 1.0,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Subtitle
                        const Text(
                          'Machinery & Equipment\nRent Karo Aasani Se',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            color: Colors.white70,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Badge
                        Container(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: AppColors.primaryYellow.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: AppColors.primaryYellow.withValues(alpha: 0.4)),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.verified_rounded,
                                  color: AppColors.primaryYellow, size: 16),
                              SizedBox(width: 6),
                              Text(
                                '500+ Verified Machines Available',
                                style: TextStyle(
                                  color: AppColors.primaryYellow,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),

                        // CTA
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: onGetStarted,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryYellow,
                              foregroundColor: AppColors.primaryBlack,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                              elevation: 0,
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Shuru Karo',
                                  style: TextStyle(
                                      fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                                SizedBox(width: 8),
                                Icon(Icons.arrow_forward_rounded, size: 22),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// PAGE 2 — Stats
// ─────────────────────────────────────────────────────────────────
class StatsPage extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onNext;
  const StatsPage({super.key, required this.onBack, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Spacer(),
                        const Text(
                          'Sahi machine,\nsahi time pe',
                          style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.w900,
                            color: AppColors.primaryBlack,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Construction se leke gardening tak\n— har zarurat ke liye MRentO',
                          style: TextStyle(
                            fontSize: 15,
                            color: AppColors.grey707070,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 40),
                        Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: AspectRatio(
                                    aspectRatio: 1.3,
                                    child: _StatCard(
                                        value: '500+',
                                        label: 'Machines',
                                        icon: Icons.construction_rounded,
                                        color: AppColors.primaryYellow),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: AspectRatio(
                                    aspectRatio: 1.3,
                                    child: _StatCard(
                                        value: '6+',
                                        label: 'Categories',
                                        icon: Icons.category_rounded,
                                        color: AppColors.categoryLiftingBg),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: AspectRatio(
                                    aspectRatio: 1.3,
                                    child: _StatCard(
                                        value: '100%',
                                        label: 'Verified Vendors',
                                        icon: Icons.verified_rounded,
                                        color: AppColors.categoryCleaningBg),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: AspectRatio(
                                    aspectRatio: 1.3,
                                    child: _StatCard(
                                        value: 'Free',
                                        label: 'Pickup & Drop',
                                        icon: Icons.local_shipping_outlined,
                                        color: AppColors.categoryMeasurementBg),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Spacer(),
                        // Navigation
                        Row(
                          children: [
                            IconButton(
                              onPressed: onBack,
                              icon: const Icon(Icons.arrow_back_rounded,
                                  color: AppColors.primaryBlack),
                              style: IconButton.styleFrom(
                                padding: const EdgeInsets.all(16),
                                backgroundColor: AppColors.background,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: SizedBox(
                                height: 56,
                                child: ElevatedButton(
                                  onPressed: onNext,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primaryBlack,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16)),
                                    elevation: 0,
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Aage Chalo',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(width: 8),
                                      Icon(Icons.arrow_forward_rounded, size: 20),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color color;
  const _StatCard({
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primaryBlack, size: 24),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primaryBlack),
              ),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.grey707070,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// PAGE 3 — Features
// ─────────────────────────────────────────────────────────────────
class FeaturesPage extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onNext;
  const FeaturesPage({super.key, required this.onBack, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryBlack,
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Spacer(),
                        Container(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primaryYellow.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text('MRentO Features',
                              style: TextStyle(
                                  color: AppColors.primaryYellow,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Jo Aapko\nChaahiye',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 32),
                        const _FeatureItem(
                          icon: Icons.verified_rounded,
                          color: AppColors.primaryYellow,
                          title: 'Verified Machines',
                          subtitle: 'Quality-checked equipment, har baar',
                        ),
                        const SizedBox(height: 20),
                        const _FeatureItem(
                          icon: Icons.local_shipping_outlined,
                          color: Color(0xFF4FC3F7),
                          title: 'Doorstep Delivery & Pickup',
                          subtitle: 'Ghar pe aata hai, wapas bhi le jaata hai',
                        ),
                        const SizedBox(height: 20),
                        const _FeatureItem(
                          icon: Icons.calendar_today_outlined,
                          color: Color(0xFF81C784),
                          title: 'Flexible Rental Duration',
                          subtitle: '1 din, 3 din, ya 1 hafta — aap decide karo',
                        ),
                        const SizedBox(height: 20),
                        const _FeatureItem(
                          icon: Icons.security_rounded,
                          color: Color(0xFFFFB74D),
                          title: 'Security Deposit Protection',
                          subtitle: '100% refundable — machine wapas karo, deposit pao',
                        ),
                        const Spacer(),
                        // Navigation
                        Row(
                          children: [
                            IconButton(
                              onPressed: onBack,
                              icon: const Icon(Icons.arrow_back_rounded,
                                  color: Colors.white70),
                              style: IconButton.styleFrom(
                                padding: const EdgeInsets.all(16),
                                backgroundColor: Colors.white.withValues(alpha: 0.1),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: SizedBox(
                                height: 56,
                                child: ElevatedButton(
                                  onPressed: onNext,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primaryYellow,
                                    foregroundColor: AppColors.primaryBlack,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16)),
                                    elevation: 0,
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Sahi Hai',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(width: 8),
                                      Icon(Icons.arrow_forward_rounded, size: 20),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  const _FeatureItem({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15)),
              const SizedBox(height: 2),
              Text(subtitle,
                  style: const TextStyle(
                      color: Colors.white60, fontSize: 12, height: 1.3)),
            ],
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// PAGE 4 — City Selection
// ─────────────────────────────────────────────────────────────────
class CityPage extends StatefulWidget {
  final VoidCallback onBack;
  final ValueChanged<String> onCitySelected;
  const CityPage({super.key, required this.onBack, required this.onCitySelected});

  @override
  State<CityPage> createState() => _CityPageState();
}

class _CityPageState extends State<CityPage> {
  String? _selectedCity;

  static const List<Map<String, String>> _cities = [
    {'name': 'Jodhpur', 'count': '340+ machines'},
    {'name': 'Jaipur', 'count': '280+ machines'},
    {'name': 'Udaipur', 'count': '190+ machines'},
    {'name': 'Delhi NCR', 'count': '500+ machines'},
    {'name': 'Mumbai', 'count': '450+ machines'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Spacer(),
                        const Text(
                          'Apna shehar\nchuniye',
                          style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.w900,
                            color: AppColors.primaryBlack,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Aapke area mein available machines dikhayenge',
                          style: TextStyle(color: AppColors.grey707070, fontSize: 14),
                        ),
                        const SizedBox(height: 28),
                        ...(_cities.map((city) => _CityCard(
                              city: city['name']!,
                              count: city['count']!,
                              isSelected: _selectedCity == city['name'],
                              onTap: () => setState(() => _selectedCity = city['name']),
                            ))),
                        const Spacer(),
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: _selectedCity == null
                                ? null
                                : () => widget.onCitySelected(_selectedCity!),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryYellow,
                              foregroundColor: AppColors.primaryBlack,
                              disabledBackgroundColor: AppColors.greyD9D9D9,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                              elevation: 0,
                            ),
                            child: Text(
                              _selectedCity == null
                                  ? 'Shehar chuniye'
                                  : '$_selectedCity — Continue ↗',
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _CityCard extends StatelessWidget {
  final String city;
  final String count;
  final bool isSelected;
  final VoidCallback onTap;
  const _CityCard({
    required this.city,
    required this.count,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryYellow.withValues(alpha: 0.12)
              : AppColors.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryYellow
                : AppColors.greyOutline.withValues(alpha: 0.4),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.location_on_rounded,
              color: isSelected ? AppColors.primaryBlack : AppColors.grey707070,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                city,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  fontSize: 15,
                  color: AppColors.primaryBlack,
                ),
              ),
            ),
            Text(
              count,
              style: const TextStyle(fontSize: 11, color: AppColors.grey707070),
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              const Icon(Icons.check_circle_rounded,
                  color: AppColors.primaryYellow, size: 18),
            ],
          ],
        ),
      ),
    );
  }
}