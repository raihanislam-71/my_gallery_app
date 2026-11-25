import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/constants/app_colors.dart';
import '../../core/services/auth_controller.dart';
import '../login/login_screen.dart';
import 'bloc/home_bloc.dart';
import 'bloc/home_event.dart';
import 'bloc/home_state.dart';
import 'widgets/dashboard_bottom_bar.dart';
import 'widgets/dashboard_header.dart';
import 'widgets/dashboard_stats.dart';
import 'widgets/photo_grid.dart';
import 'widgets/profile_tab.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeBloc()..add(const HomeFetchPhotos()),
      child: _DashboardView(email: email),
    );
  }
}

class _DashboardView extends StatelessWidget {
  const _DashboardView({required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: state.selectedTab == 3
                ? ProfileTab(
                    email: email.isEmpty
                        ? AuthController.userEmail ?? 'samimcse7@gmail.com'
                        : email,
                    onNotificationTap: () =>
                        _showMessage(context, 'You are all caught up.'),
                    onLogout: () async {
                      await AuthController().clearUserData();
                      if (context.mounted) {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute<void>(
                            builder: (_) => const LoginScreen(),
                          ),
                        );
                      }
                    },
                  )
                : _buildGalleryTab(context, state),
          ),
          bottomNavigationBar: DashboardBottomBar(
            selectedIndex: state.selectedTab,
            onTabSelected: (index) {
              context.read<HomeBloc>().add(DashboardTabChanged(index));
            },
            onAddPhoto: () =>
                _showMessage(context, 'Photo upload feature coming soon.'),
          ),
        );
      },
    );
  }

  Widget _buildGalleryTab(BuildContext context, HomeState state) {
    final isHome = state.selectedTab == 0;
    final isFavorites = state.selectedTab == 2;
    final photos = isFavorites
        ? state.photos.where((photo) => state.isFavorite(photo.id)).toList()
        : state.photos;
    final title = isHome
        ? 'My Gallery'
        : isFavorites
        ? 'Favorites'
        : 'Gallery';
    final eyebrow = isHome
        ? 'Welcome back'
        : isFavorites
        ? 'Your favorite photos'
        : 'All your photos';

    return RefreshIndicator(
      onRefresh: () async {
        context.read<HomeBloc>().add(const HomeFetchPhotos());
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DashboardHeader(
              eyebrow: eyebrow,
              title: title,
              onNotificationTap: () =>
                  _showMessage(context, 'You are all caught up.'),
            ),
            if (isHome) ...[
              const SizedBox(height: 19),
              DashboardStats(
                totalPhotos: state.isLoading || state.errorMessage.isNotEmpty
                    ? null
                    : state.photos.length,
                storageUsed: state.isLoading || state.errorMessage.isNotEmpty
                    ? '—'
                    : state.storageUsedLabel,
              ),
              const SizedBox(height: 19),
              const Text(
                'Recent Uploads',
                style: TextStyle(
                  color: AppColors.text,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 18),
            ] else
              const SizedBox(height: 22),
            if (state.isLoading)
              const Padding(
                padding: EdgeInsets.only(top: 80),
                child: Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              )
            else if (state.errorMessage.isNotEmpty)
              _buildLoadError(context, state.errorMessage)
            else if (photos.isEmpty)
              _buildEmptyState(isFavorites)
            else
              PhotoGrid(
                photos: photos,
                state: state,
                onFavoriteTap: (photoId) {
                  context.read<HomeBloc>().add(GalleryFavoriteToggled(photoId));
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isFavorites) {
    return Padding(
      padding: const EdgeInsets.only(top: 80),
      child: Column(
        children: [
          Icon(
            isFavorites ? Icons.favorite_border : Icons.photo_library_outlined,
            color: AppColors.mutedText,
            size: 44,
          ),
          const SizedBox(height: 12),
          Text(
            isFavorites ? 'No favorites yet' : 'No photos found',
            style: const TextStyle(
              color: AppColors.text,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            isFavorites
                ? 'Tap the heart on a photo to save it here.'
                : 'Upload photos to see them displayed in your gallery.',
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.mutedText, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadError(BuildContext context, String message) {
    return Padding(
      padding: const EdgeInsets.only(top: 64),
      child: Column(
        children: [
          const Icon(
            Icons.cloud_off_outlined,
            color: AppColors.mutedText,
            size: 44,
          ),
          const SizedBox(height: 12),
          const Text(
            'Could not load photos',
            style: TextStyle(
              color: AppColors.text,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.mutedText, fontSize: 13),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () =>
                context.read<HomeBloc>().add(const HomeFetchPhotos()),
            child: const Text('Try again'),
          ),
        ],
      ),
    );
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}
