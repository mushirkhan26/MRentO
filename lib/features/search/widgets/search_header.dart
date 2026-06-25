import 'package:MRentO/features/search/bloc/search_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../config/navigation/app_routes.dart';
import '../../../config/theme/app_colors.dart';
import '../bloc/search_bloc.dart';
import '../bloc/search_event.dart';

class SearchHeader extends StatelessWidget {
  final TextEditingController controller;
  const SearchHeader({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryBlack,
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 20),
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.1), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.arrow_back_ios_new,
                  color: AppColors.primaryBlack, size: 18),
              onPressed: () {
                if (Navigator.of(context).canPop()) {
                  Navigator.pop(context);
                } else {
                  context.go(AppRoutes.homeRoute);
                }
              },
            ),
            Expanded(
              child: BlocListener<SearchBloc, SearchState>(
                listenWhen: (previous, current) =>
                    previous.currentQuery != current.currentQuery,
                listener: (context, state) {
                  if (controller.text != state.currentQuery) {
                    controller.text = state.currentQuery;
                    // Move cursor to the end
                    controller.selection = TextSelection.fromPosition(
                      TextPosition(offset: controller.text.length),
                    );
                  }
                },
                child: TextField(
                  controller: controller,
                  style: const TextStyle(
                    fontSize: 15,
                    color: AppColors.primaryBlack,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    // ✅ Rental-appropriate hint text
                    hintText: 'Search drills, mixers, scaffolding...',
                    hintStyle: TextStyle(
                        color: Colors.grey.shade400, fontSize: 14),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding:
                    const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onChanged: (query) {
                    context
                        .read<SearchBloc>()
                        .add(SearchQueryChanged(query));
                  },
                ),
              ),
            ),
            IconButton(
              icon: BlocBuilder<SearchBloc, SearchState>(
                builder: (context, state) {
                  return Icon(
                    state.isListening ? Icons.mic : Icons.mic_none,
                    color: state.isListening
                        ? AppColors.primaryYellow
                        : Colors.grey.shade600,
                    size: 22,
                  );
                },
              ),
              onPressed: () {
                context.read<SearchBloc>().add(const StartVoiceSearch());
              },
            ),
            const SizedBox(width: 4),
          ],
        ),
      ),
    );
  }
}