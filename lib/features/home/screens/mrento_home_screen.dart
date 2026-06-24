import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import '../../../config/theme/app_colors.dart';
import '../../../config/navigation/app_routes.dart';
import '../bloc/category_bloc.dart';
import '../bloc/product_bloc.dart';
import '../bloc/product_event.dart';
import '../bloc/product_state.dart';
import '../bloc/banner_bloc.dart';
import '../bloc/banner_state.dart';
import '../bloc/location_bloc.dart';
import '../bloc/location_state.dart';
import '../../search/bloc/search_bloc.dart';
import '../../search/bloc/search_event.dart';
import '../../cart/bloc/cart_bloc.dart';
import '../../cart/bloc/cart_state.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_state.dart';
import 'package:shimmer/shimmer.dart';

import '../widgets/location_picker_sheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedCategoryIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<CategoryBloc>().add(FetchCategories());
    context.read<ProductBloc>().add(
      const FetchProductsByCategory('power-tools'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: AppColors.primaryDarkGreen,
      ),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              // Header
              SliverToBoxAdapter(child: _buildHeader()),

              // Search Bar
              SliverToBoxAdapter(child: _buildSearchBar()),

              // Banner
              SliverToBoxAdapter(child: _buildPromoBanner()),

              // Categories
              SliverToBoxAdapter(child: _buildCategories()),

              // Products
              SliverToBoxAdapter(child: _buildProductsSection()),

              const SliverToBoxAdapter(child: SizedBox(height: 32)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        String userName = 'User';
        if (authState is AuthAuthenticated) {
          userName = authState.user.name.split(' ')[0];
        }

        return BlocBuilder<LocationBloc, LocationState>(
          builder: (context, state) {
            String displayLocation = 'Detecting...';
            if (state is LocationLoaded) {
              displayLocation = state.address;
            } else if (state is LocationError) {
              displayLocation = 'Tap to set';
            }

            return Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 8, 16),
              color: AppColors.primaryBlack,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _showLocationPicker(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Namaste, $userName 👋',
                                style: const TextStyle(
                                  color: AppColors.primaryYellow,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    color: Colors.white70,
                                    size: 14,
                                  ),
                                  const SizedBox(width: 4),
                                  const Text(
                                    'Deliver karein',
                                    style: TextStyle(
                                      color: Colors.white60,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      displayLocation,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                  const Icon(
                                    Icons.keyboard_arrow_down,
                                    color: AppColors.primaryYellow,
                                    size: 18,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          _HomeHeaderCartIcon(),
                          _buildHeaderIcon(
                            'assets/icons/notifications.svg',
                            () => context.push(AppRoutes.notifications),
                          ),
                          _buildHeaderIcon(
                            'assets/icons/profile.svg',
                            () => context.push(AppRoutes.userProfile),
                            isProfile: true,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildHeaderIcon(String asset, VoidCallback onTap, {bool isProfile = false}) {
    return IconButton(
      onPressed: onTap,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      icon: Container(
        margin: const EdgeInsets.only(left: 10),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isProfile 
              ? AppColors.primaryYellow.withValues(alpha: 0.15)
              : Colors.white.withValues(alpha: 0.08),
          shape: BoxShape.circle,
          border: isProfile ? Border.all(color: AppColors.primaryYellow.withValues(alpha: 0.3), width: 1) : null,
        ),
        child: SvgPicture.asset(
          asset,
          width: 24,
          height: 24,
          colorFilter: isProfile
              ? const ColorFilter.mode(
            AppColors.primaryYellow,
            BlendMode.srcIn,
          )
              : null,
        )
      ),
    );
  }

  Widget _buildSearchBar() {
    return GestureDetector(
      onTap: () => context.push(AppRoutes.searchRoute),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.search, color: AppColors.primaryYellow, size: 24),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                'Drill, Mixer, Scaffolding...',
                style: TextStyle(
                  color: AppColors.grey500,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.mic_none_rounded, color: AppColors.grey400, size: 22),
              onPressed: () {
                context.read<SearchBloc>().add(const StartVoiceSearch());
                context.push(AppRoutes.searchRoute);
              },
            ),
            const SizedBox(width: 12),
            Container(
              height: 24,
              width: 1,
              color: AppColors.grey200,
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primaryBlack,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.tune_rounded, color: AppColors.primaryYellow, size: 14),
                  const SizedBox(width: 4),
                  const Text(
                    'Filter',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
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

  Widget _buildPromoBanner() {
    return BlocBuilder<BannerBloc, BannerState>(
      builder: (context, state) {
        if (state is BannerLoading) {
          return _buildBannerShimmer();
        }

        if (state is BannerLoaded && state.banners.isNotEmpty) {
          return SizedBox(
            height: 180,
            child: PageView.builder(
              itemCount: state.banners.length,
              itemBuilder: (context, index) {
                final banner = state.banners[index];
                return GestureDetector(
                  onTap: () {
                    // Logic to handle redirection
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      image: DecorationImage(
                        image: NetworkImage(banner.imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }

        // Optimized Fallback banner
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          height: 160,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: const LinearGradient(
              colors: [AppColors.primaryBlack, Color(0xFF323232)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                right: -20,
                bottom: -20,
                child: Icon(
                  Icons.construction_rounded,
                  size: 160,
                  color: Colors.white.withValues(alpha: 0.05),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primaryYellow,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'LIMITED OFFER',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                color: AppColors.primaryBlack,
                                letterSpacing: 1,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const FittedBox(
                            fit: BoxFit.scaleDown,
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'FREE Delivery\nPehle order pe!',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                height: 1.1,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Use Code: MRENTO100',
                            style: TextStyle(
                              color: Colors.white60,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.electric_bolt_rounded,
                      size: 80,
                      color: AppColors.primaryYellow,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBannerShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        height: 160,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  void _showLocationPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const FractionallySizedBox(
        heightFactor: 0.85,
        child: LocationPickerSheet(),
      ),
    );
  }

  Widget _buildCategories() {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        if (state is CategoryLoading) {
          return const SizedBox(
            height: 100,
            child: Center(child: CircularProgressIndicator(
              color: AppColors.primaryYellow,
            )),
          );
        }

        // Fallback categories agar Firestore se nahi aai
        final categories = state is CategoryLoaded
            ? state.categories
            : [];

        if (categories.isEmpty) return const SizedBox(height: 8);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Categories',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryBlack,
                      letterSpacing: -0.5,
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.push(AppRoutes.searchRoute),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      foregroundColor: AppColors.primaryYellow,
                    ),
                    child: const Text(
                      'See All',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 110,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  final isSelected = _selectedCategoryIndex == index;

                  return GestureDetector(
                    onTap: () {
                      setState(() => _selectedCategoryIndex = index);
                      context.read<SearchBloc>().add(SearchQueryChanged(category.name));
                      context.push(AppRoutes.searchRoute);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      width: 90,
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primaryYellow : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: isSelected 
                                ? AppColors.primaryYellow.withValues(alpha: 0.3)
                                : Colors.black.withValues(alpha: 0.04),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isSelected 
                                  ? Colors.white.withValues(alpha: 0.3)
                                  : AppColors.grey100,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _getCategoryIcon(category.name),
                              color: isSelected ? AppColors.primaryBlack : AppColors.grey600,
                              size: 26,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            category.name,
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                              color: isSelected ? AppColors.primaryBlack : AppColors.grey707070,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
  
  Widget _buildCategoryFallbackIcon(String name, bool isSelected) {
    return Icon(
      _getCategoryIcon(name),
      color: isSelected ? AppColors.primaryBlack : AppColors.grey500,
      size: 40,
    );
  }

  Widget _buildProductsSection() {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state is ProductLoading) {
          return _buildProductsShimmer();
        }

        if (state is ProductLoaded) {
          if (state.products.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(40),
                child: Column(
                  children: [
                    Icon(Icons.inventory_2_outlined, size: 64, color: AppColors.grey300),
                    SizedBox(height: 16),
                    Text(
                      'Is category mein abhi koi item nahi hai',
                      style: TextStyle(color: AppColors.grey500, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Available Near You',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryBlack,
                            letterSpacing: -0.5,
                          ),
                        ),
                        Text(
                          '${state.products.length} items found nearby',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.grey500,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () => context.push(AppRoutes.searchRoute),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        foregroundColor: AppColors.primaryYellow,
                      ),
                      child: const Row(
                        children: [
                          Text(
                            'See All',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(Icons.chevron_right, size: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.68, // Increased from 0.70 to give more vertical space
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: state.products.length,
                itemBuilder: (context, index) {
                  final product = state.products[index];
                  return _buildProductCard(product);
                },
              ),
            ],
          );
        }

        if (state is ProductError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Text(state.message),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
  
  Widget _buildProductsShimmer() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(width: 150, height: 20, color: Colors.white),
              Container(width: 60, height: 20, color: Colors.white),
            ],
          ),
        ),
        GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.70,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: 4,
          itemBuilder: (context, index) => Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductCard(dynamic product) {
    return GestureDetector(
      onTap: () => context.push('/product-details', extra: product),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            Expanded(
              flex: 11,
              child: Stack(
                children: [
                  Hero(
                    tag: 'product_${product.id}',
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                      child: product.images.isNotEmpty
                          ? Image.network(
                        product.images[0],
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: AppColors.grey100,
                          child: const Icon(
                            Icons.construction,
                            size: 40,
                            color: AppColors.grey300,
                          ),
                        ),
                      )
                          : Container(
                        color: AppColors.grey100,
                        child: const Icon(
                          Icons.construction,
                          size: 40,
                          color: AppColors.grey300,
                        ),
                      ),
                    ),
                  ),
                  // Badges
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildBadge('90 Min', AppColors.primaryYellow, AppColors.primaryBlack),
                        const SizedBox(height: 4),
                        _buildBadge('Nearby', Colors.white, AppColors.primaryBlack),
                      ],
                    ),
                  ),
                  // Favorite toggle (Optional but adds to UI feel)
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.favorite_border, size: 16, color: AppColors.grey600),
                    ),
                  ),
                ],
              ),
            ),
            // Info Section
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryBlack,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 12, color: AppColors.grey500),
                      const SizedBox(width: 2),
                      const Text(
                        '1.2 km away',
                        style: TextStyle(fontSize: 10, color: AppColors.grey500, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Rent per day',
                            style: TextStyle(fontSize: 9, color: AppColors.grey400, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            '₹${product.rentPerDay?.toInt() ?? 0}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primaryBlack,
                            ),
                          ),
                        ],
                      ),

                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primaryYellow,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(Icons.add, color: AppColors.primaryBlack, size: 20),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String text, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          color: textColor,
        ),
      ),
    );
  }

  
  IconData _getCategoryIcon(String name) {
    switch (name.toLowerCase()) {
      case 'power tools': return Icons.electrical_services;
      case 'construction': return Icons.construction;
      case 'lifting': return Icons.arrow_upward;
      case 'cleaning': return Icons.cleaning_services;
      case 'measurement': return Icons.straighten;
      case 'gardening': return Icons.grass;
      default: return Icons.handyman;
    }
  }
}

class _HomeHeaderCartIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        final count = state is CartLoaded ? state.cart.items.length : 0;
        return IconButton(
          onPressed: () => context.push(AppRoutes.cartRoute),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          icon: Badge(
            label: Text(count.toString()),
            isLabelVisible: count > 0,
            backgroundColor: AppColors.errorRed,
            textColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Container(
              margin: const EdgeInsets.only(left: 10),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(
                'assets/icons/cart.svg',
                width: 24,
                height: 24,
              ),
            ),
          ),
        );
      },
    );
  }
}

