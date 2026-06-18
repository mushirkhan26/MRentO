import 'package:flutter/material.dart';

class AppColors {
  // ─────────────────────────────────────────
  // MRentO Primary Colors
  // ─────────────────────────────────────────
  static const Color primaryYellow = Color(0xFFFFD000);
  static const Color primaryDarkYellow = Color(0xFFF5A800);
  static const Color primaryBlack = Color(0xFF1A1A1A);
  static const Color primaryDarkBlack = Color(0xFF0D0D0D);

  // ─────────────────────────────────────────
  // Fashion app legacy aliases
  // (purani files compile hone ke liye — baad mein hata sakte ho)
  // ─────────────────────────────────────────
  static const Color primaryDarkGreen = Color(0xFF1A1A1A);   // black se map
  static const Color primaryAmber = Color(0xFFFFD000);        // yellow se map
  static const Color lightGreenBadge = Color(0xFFFFF9C4);     // light yellow
  static const Color darkGreenText = Color(0xFF856404);
  static const Color successColor = Color(0xFF22C55E);

  // ─────────────────────────────────────────
  // Background Colors
  // ─────────────────────────────────────────
  static const Color background = Color(0xFFF5F5F5);
  static const Color exploreBackground = Color(0xFFF9F9F7);
  static const Color cardBackground = Color(0xFFFFFFFF);

  // ─────────────────────────────────────────
  // Status Colors
  // ─────────────────────────────────────────
  static const Color warningColor = Color(0xFFF59E0B);
  static const Color errorRed = Color(0xFFEF4444);
  static const Color infoColor = Color(0xFF3B82F6);

  // ─────────────────────────────────────────
  // Grey Shades
  // ─────────────────────────────────────────
  static const Color grey100 = Color(0xFFF3F4F6);
  static const Color grey200 = Color(0xFFE5E7EB);
  static const Color grey300 = Color(0xFFD1D5DB);
  static const Color grey400 = Color(0xFF9CA3AF);
  static const Color grey500 = Color(0xFF6B7280);
  static const Color grey600 = Color(0xFF4B5563);
  static const Color grey707070 = Color(0xFF707070);
  static const Color grey808080 = Color(0xFF808080);
  static const Color grey7B7B7B = Color(0xFF7B7B7B);
  static const Color grey5C5C5C = Color(0xFF5C5C5C);
  static const Color greyOutline = Color(0xFFD0D5DD);
  static const Color greyE5E7EB = Color(0xFFE5E7EB);
  static const Color greyDFDFDF = Color(0xFFDFDFDF);
  static const Color greyAAAAAA = Color(0xFFAAAAAA);
  static const Color greyDBDDE1 = Color(0xFFDBDDE1);
  static const Color greyD9D9D9 = Color(0xFFD9D9D9);
  static const Color dividerD9D9D9 = Color(0xFFD9D9D9);

  // ─────────────────────────────────────────
  // Category Colors — Hardware
  // ─────────────────────────────────────────
  static const Color categoryPowerBg = Color(0xFFFFF3CD);
  static const Color categoryPowerText = Color(0xFF856404);
  static const Color categoryConstructionBg = Color(0xFFFFE0B2);
  static const Color categoryConstructionText = Color(0xFFE65100);
  static const Color categoryLiftingBg = Color(0xFFE3F2FD);
  static const Color categoryLiftingText = Color(0xFF1565C0);
  static const Color categoryCleaningBg = Color(0xFFE8F5E9);
  static const Color categoryCleaningText = Color(0xFF2E7D32);
  static const Color categoryMeasurementBg = Color(0xFFF3E5F5);
  static const Color categoryMeasurementText = Color(0xFF6A1B9A);

  // ─────────────────────────────────────────
  // Legacy Category Colors (fashion se)
  // ─────────────────────────────────────────
  static const Color categoryWomenBg = Color(0xFFFFE5EC);
  static const Color categoryWomenText = Color(0xFFD63384);
  static const Color categoryMenBg = Color(0xFFE2F0D9);
  static const Color categoryMenText = Color(0xFF388E3C);
  static const Color categoryBridalBg = Color(0xFFFFF4E5);
  static const Color categoryBridalText = Color(0xFFE67E22);
  static const Color categoryLocalBg = Color(0xFFE8EAF6);
  static const Color categoryLocalText = Color(0xFF3F51B5);

  // ─────────────────────────────────────────
  // Badge Colors
  // ─────────────────────────────────────────
  static const Color lightYellowBadge = Color(0xFFFFF9C4);
  static const Color darkYellowText = Color(0xFF856404);

  // ─────────────────────────────────────────
  // Misc
  // ─────────────────────────────────────────
  static const Color dividerColor = Color(0xFFEAECF0);
  static const Color black121212 = Color(0xFF121212);
  static const Color black151515 = Color(0xFF151515);
  static const Color black2E2E2E = Color(0xFF2E2E2E);
  static const Color black354055 = Color(0xFF354055);
  static const Color bottomNavIconColor = Color(0xFF121212);
  static const Color bottomNavColor = Color(0xFFFFFAF6);
  static const Color blue0056FB = Color(0xFF0056FB);
  static const Color blue4A76CD = Color(0xFF4A76CD);
  static const Color blue699BF7 = Color(0xFF699BF7);
  static const Color blue = Color(0xFF2F82EF);
  static const Color blue00ABE9 = Color(0xFF00ABE9);
  static const Color activeGreen = Color(0xFF12DD1B);
  static const Color green22C55E = Color(0xFF22C55E);
  static const Color gray50 = Color(0xFFEBECEE);
  static const Color gray475467 = Color(0xFF475467);
  static const Color trendingChipBg = Colors.white;
  static const Color searchBarBgColor = Color(0xFFECE6F0);
  static const Color formFields = Color(0xFFEBEBEB);
  static const Color borderColor = Color(0xFFC7C7C7);
  static const Color redF11515 = Color(0xFFF11515);
  static const Color greyB2BACD = Color(0xFFB2BACD);
  static const Color grey474747 = Color(0xFF474747);
  static const Color greyA8B5CB = Color(0xFFA8B5CB);

  static var shadowColor = Colors.black.withValues(alpha: 0.15);
  static var shadowColor25 = Colors.black.withValues(alpha: 0.25);
  static var black60opac = Colors.black.withValues(alpha: 0.60);
  static var foregroundMutedGrey = const Color(0xFFAAAAAA);
  static var helperOrange = const Color(0xFFDF6D14);
  static var salarySlipTileColor = const Color(0xFF02A6A6).withValues(alpha: 0.05);
  static var backgroundEEEDED = const Color(0xFFEEEDED).withValues(alpha: 0.46);
  static var buttonRed = const Color(0xFFFF2323).withValues(alpha: 0.72);
}