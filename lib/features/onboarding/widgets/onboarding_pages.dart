import 'package:flutter/material.dart';
import '../../../config/theme/app_colors.dart';

class WelcomePage extends StatelessWidget {
  final VoidCallback onContinue;
  const WelcomePage({super.key, required this.onContinue});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryDarkGreen,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white.withValues(alpha: 0.5),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            '90-Minutes',
            style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Fashion at the speed of life',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 40),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.timer_outlined, color: Colors.white, size: 16),
                SizedBox(width: 8),
                Text('90-min delivery guarantee',
                    style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: onContinue,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primaryAmber,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                  ),
                  child: const Icon(Icons.keyboard_arrow_down, color: Colors.white),
                ),
                const SizedBox(height: 12),
                const Text('Tap to continue', style: TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(height: 60),
        ],
      ),
    );
  }
}

class StatsPage extends StatelessWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  const StatsPage({super.key, required this.onNext, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryDarkGreen,
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white.withValues(alpha: 0.5),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            'assets/images/logo.png',
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      '90 minutes mein\nfashion ghar pe!',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Order karo — ghar pe aayega. India ka sabse\nfast fashion delivery.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.5),
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
                        _statCard('500+', 'Brands'),
                        _statCard('48+', 'Local\nshops'),
                        _statCard('Free', 'Returns'),
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
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(label, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70, fontSize: 11)),
        ],
      ),
    );
  }
}

class FeaturesPage extends StatelessWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;
  const FeaturesPage({super.key, required this.onNext, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryDarkGreen,
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white.withValues(alpha: 0.5),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            'assets/images/logo.png',
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      'Sirf 90-Minutes mein',
                      style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Features jo koi nahi deta',
                      style: TextStyle(color: Colors.white70, fontSize: 15),
                    ),
                    const SizedBox(height: 40),
                    _featureRow(Icons.auto_awesome_outlined, 'AI Virtual Try-On', 'Photo upload karo — virtually pehno'),
                    _featureRow(Icons.assignment_return_outlined, 'Try & Return — free', 'Pasand na aaye — rider le jaayega'),
                    _featureRow(Icons.group_outlined, 'Style Squad', 'Dosto ke saath live shopping'),
                    _featureRow(Icons.storefront_outlined, 'Local designers', 'Jodhpur ke 48+ boutiques'),
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
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CityPage extends StatelessWidget {
  final VoidCallback onFinish;
  final VoidCallback onBack;
  const CityPage({super.key, required this.onFinish, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryDarkGreen,
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    const CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white12,
                      child: Icon(Icons.location_on_outlined, color: Colors.white, size: 40),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Apna shehar chuniye',
                      style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '90-min delivery aapke ghar tak',
                      style: TextStyle(color: Colors.white70, fontSize: 15),
                    ),
                    const SizedBox(height: 32),
                    _cityTile('Jodhpur', '48 local designers', true, isLive: true),
                    _cityTile('Jaipur', '120+ stores', false, isLive: true),
                    _cityTile('Udaipur', '35 stores', false, isLive: true),
                    _cityTile('Delhi NCR', '250+ stores', false, isLive: true),
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

  Widget _cityTile(String name, String region, bool isSelected, {required bool isLive}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: isSelected ? 0.15 : 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isSelected ? Colors.white.withValues(alpha: 0.5) : Colors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Icon(
            isSelected ? Icons.check_circle : Icons.circle_outlined,
            color: isSelected ? AppColors.primaryAmber : Colors.white,
            size: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                Text(region, style: const TextStyle(color: Colors.white70, fontSize: 11)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: isLive ? AppColors.primaryAmber.withValues(alpha: 0.2) : Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              isLive ? 'Live' : 'Soon',
              style: TextStyle(
                color: isLive ? AppColors.primaryAmber : Colors.white70,
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

Widget _buildStickyFooter(int pageIndex, VoidCallback onBack, VoidCallback onNext, String nextLabel) {
  return Container(
    padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.primaryDarkGreen.withValues(alpha: 0),
          AppColors.primaryDarkGreen,
        ],
        stops: const [0.0, 0.3],
      ),
    ),

    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _pageIndicator(pageIndex),
        const SizedBox(height: 32),
        _navigationButtons(onBack, onNext, nextLabel),
      ],
    ),
  );
}

Widget _navigationButtons(VoidCallback onBack, VoidCallback onNext, String nextLabel) {
  return Row(
    children: [
      GestureDetector(
        onTap: onBack,
        child: Container(
          width: 100,
          height: 56,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
          ),
          child: const Center(child: Icon(Icons.arrow_back, color: Colors.white)),
        ),
      ),
      const SizedBox(width: 16),
      Expanded(
        child: GestureDetector(
          onTap: onNext,
          child: Container(
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.primaryAmber,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(nextLabel, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),
                const Icon(Icons.arrow_forward, color: Colors.white),
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
      int pageIndex = index + 1; // Indicator starts from page 1 (StatsPage)
      return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: pageIndex == activePage ? 24 : 8,
        height: 6,
        margin: const EdgeInsets.symmetric(horizontal: 3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          color: pageIndex == activePage ? Colors.white : Colors.white.withValues(alpha: 0.3),
        ),
      );
    }),
  );
}
