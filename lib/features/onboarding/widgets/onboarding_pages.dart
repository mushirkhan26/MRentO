import 'package:flutter/material.dart';
import '../../../config/theme/app_colors.dart';

class WelcomePage extends StatelessWidget {
  final VoidCallback onContinue;
  const WelcomePage({super.key, required this.onContinue});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryBlack,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          // Logo
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              color: AppColors.primaryYellow,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryYellow.withValues(alpha: 0.4),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 28),
          // App Name
          const Text(
            'MRentO',
            style: TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Machinery, 90 min mein',
            style: TextStyle(
              color: Colors.white60,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 32),
          // Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.primaryYellow.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.primaryYellow.withValues(alpha: 0.4),
              ),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.timer_outlined, color: AppColors.primaryYellow, size: 16),
                SizedBox(width: 8),
                Text(
                  '90-min delivery guarantee',
                  style: TextStyle(
                    color: AppColors.primaryYellow,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          // Continue Button
          GestureDetector(
            onTap: onContinue,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: const BoxDecoration(
                    color: AppColors.primaryYellow,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.keyboard_arrow_down,
                    color: AppColors.primaryBlack,
                    size: 24,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Tap to continue',
                  style: TextStyle(color: Colors.white38, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 60),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
// PAGE 2 — Stats
// ─────────────────────────────────────────
class StatsPage extends StatelessWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  const StatsPage({super.key, required this.onNext, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryBlack,
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    // Logo small
                    Container(
                      width: 80,
                      height: 80,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryYellow,
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/logo.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    const Text(
                      '90 min mein\nMachinery ghar pe!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Drill se lekar Concrete Mixer tak —\nsab kuch rent pe, 90 min mein.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white60,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 40),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1.4,
                      children: [
                        _statCard('90', 'Min\ndelivery'),
                        _statCard('50+', 'Tools\navailable'),
                        _statCard('5', 'Local\nvendors'),
                        _statCard('Zero', 'Purchase\ncost'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            _buildStickyFooter(1, onBack, onNext, 'Aage'),
          ],
        ),
      ),
    );
  }

  Widget _statCard(String value, String label) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryYellow.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primaryYellow.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: const TextStyle(
              color: AppColors.primaryYellow,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white60, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
// PAGE 3 — Features
// ─────────────────────────────────────────
class FeaturesPage extends StatelessWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  const FeaturesPage({super.key, required this.onNext, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryBlack,
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    Container(
                      width: 80,
                      height: 80,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryYellow,
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/logo.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    const Text(
                      'Rent karo, tension nahi',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Jo features koi nahi deta',
                      style: TextStyle(color: Colors.white60, fontSize: 15),
                    ),
                    const SizedBox(height: 32),
                    _featureRow(
                      Icons.timer_outlined,
                      '90-Min Delivery',
                      'Order karo — 90 min mein machine ghar pe',
                    ),
                    _featureRow(
                      Icons.currency_rupee,
                      'Sirf Rent Karo',
                      'Lakh ki machine, sirf ₹149/din mein',
                    ),
                    _featureRow(
                      Icons.verified_outlined,
                      'Verified Vendors',
                      'Jodhpur ke trusted hardware shops',
                    ),
                    _featureRow(
                      Icons.assignment_return_outlined,
                      'Easy Return',
                      'Kaam khatam — rider le jaayega',
                    ),
                  ],
                ),
              ),
            ),
            _buildStickyFooter(2, onBack, onNext, 'Aage'),
          ],
        ),
      ),
    );
  }

  Widget _featureRow(IconData icon, String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primaryYellow.withValues(alpha: 0.15),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primaryYellow.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primaryYellow, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.white60, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
// PAGE 4 — City
// ─────────────────────────────────────────
class CityPage extends StatelessWidget {
  final VoidCallback onFinish;
  final VoidCallback onBack;
  const CityPage({super.key, required this.onFinish, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryBlack,
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.primaryYellow.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.location_on_outlined,
                        color: AppColors.primaryYellow,
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Apna shehar chuniye',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '90-min delivery aapke ghar tak',
                      style: TextStyle(color: Colors.white60, fontSize: 15),
                    ),
                    const SizedBox(height: 32),
                    _cityTile('Jodhpur', '5 verified vendors', true, isLive: true),
                    _cityTile('Jaipur', '12+ vendors', false, isLive: true),
                    _cityTile('Udaipur', '8 vendors', false, isLive: true),
                    _cityTile('Delhi NCR', '25+ vendors', false, isLive: true),
                    _cityTile('Mumbai', 'Coming soon', false, isLive: false),
                  ],
                ),
              ),
            ),
            _buildStickyFooter(3, onBack, onFinish, 'Shuru karo'),
          ],
        ),
      ),
    );
  }

  Widget _cityTile(String name, String info, bool isSelected, {required bool isLive}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.primaryYellow.withValues(alpha: 0.15)
            : Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected
              ? AppColors.primaryYellow.withValues(alpha: 0.5)
              : Colors.white.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        children: [
          Icon(
            isSelected ? Icons.check_circle : Icons.circle_outlined,
            color: isSelected ? AppColors.primaryYellow : Colors.white38,
            size: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  info,
                  style: const TextStyle(color: Colors.white60, fontSize: 11),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: isLive
                  ? AppColors.primaryYellow.withValues(alpha: 0.2)
                  : Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              isLive ? 'Live' : 'Soon',
              style: TextStyle(
                color: isLive ? AppColors.primaryYellow : Colors.white38,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
// SHARED FOOTER WIDGETS
// ─────────────────────────────────────────
Widget _buildStickyFooter(
    int pageIndex,
    VoidCallback onBack,
    VoidCallback onNext,
    String nextLabel,
    ) {
  return Container(
    padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.primaryBlack.withValues(alpha: 0),
          AppColors.primaryBlack,
        ],
        stops: const [0.0, 0.3],
      ),
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _pageIndicator(pageIndex),
        const SizedBox(height: 24),
        _navigationButtons(onBack, onNext, nextLabel),
      ],
    ),
  );
}

Widget _navigationButtons(
    VoidCallback onBack,
    VoidCallback onNext,
    String nextLabel,
    ) {
  return Row(
    children: [
      GestureDetector(
        onTap: onBack,
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
          ),
          child: const Center(
            child: Icon(Icons.arrow_back, color: Colors.white, size: 20),
          ),
        ),
      ),
      const SizedBox(width: 16),
      Expanded(
        child: GestureDetector(
          onTap: onNext,
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.primaryYellow,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  nextLabel,
                  style: const TextStyle(
                    color: AppColors.primaryBlack,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.arrow_forward,
                  color: AppColors.primaryBlack,
                  size: 18,
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}

Widget _pageIndicator(int activePage) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: List.generate(3, (index) {
      final pageIndex = index + 1;
      return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: pageIndex == activePage ? 24 : 8,
        height: 6,
        margin: const EdgeInsets.symmetric(horizontal: 3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          color: pageIndex == activePage
              ? AppColors.primaryYellow
              : Colors.white.withValues(alpha: 0.3),
        ),
      );
    }),
  );
}