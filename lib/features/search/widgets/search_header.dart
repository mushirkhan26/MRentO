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
      padding: const EdgeInsets.fromLTRB(16, 40, 16, 16),
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios_new,
                  color: AppColors.primaryBlack, size: 20),
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
                  decoration: InputDecoration(
                    // ✅ Rental-appropriate hint text
                    hintText: 'Search drills, mixers, scaffolding...',
                    hintStyle: TextStyle(
                        color: Colors.grey.shade500, fontSize: 15),
                    border: InputBorder.none,
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
            ),IconButton(
              icon: BlocBuilder<SearchBloc, SearchState>(
                builder: (context, state) {
                  return Icon(
                    state.isListening ? Icons.mic : Icons.mic_none,
                    color: state.isListening
                        ? AppColors.primaryYellow
                        : AppColors.primaryBlack,
                    size: 24,
                  );
                },
              ),
              onPressed: () {
                context.read<SearchBloc>().add(const StartVoiceSearch());
              },
            ),
          ],
        ),
      ),
    );
  }
}