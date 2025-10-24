import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_app/controllers/news_controller.dart';
import 'package:news_app/routes/app_pages.dart';
import 'package:news_app/widgets/news_card.dart';
import 'package:news_app/widgets/loading_shimmer.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class HomeView extends GetView<NewsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'News Today',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Get.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              Get.changeThemeMode(
                  Get.isDarkMode ? ThemeMode.light : ThemeMode.dark);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔍 Search bar langsung di bawah AppBar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                onSubmitted: (value) {
                  if (value.isNotEmpty) controller.searchNews(value);
                },
                decoration: InputDecoration(
                  hintText: 'Search news...',
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                ),
              ),
            ),

            // 🗂️ Category list
            _buildCategoryList(),
            const SizedBox(height: 16),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Top Headlines',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // 📰 Main content
            Expanded(
              child: Obx(() {
                if (controller.isLoading && controller.articles.isEmpty) {
                  return const LoadingShimmer();
                }
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: _buildContent(),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  // 🧠 Build main content
  Widget _buildContent() {
    if (controller.error.isNotEmpty && controller.articles.isEmpty) {
      return _buildErrorWidget();
    }

    if (controller.articles.isEmpty && !controller.isLoading) {
      return _buildEmptyWidget();
    }

    return RefreshIndicator(
      onRefresh: controller.refreshNews,
      child: AnimationLimiter(
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: controller.displayedArticles.length + 1,
          itemBuilder: (context, index) {
            if (index == controller.displayedArticles.length) {
              return Obx(() =>
                  controller.displayedArticles.length < controller.articles.length
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Center(
                            child: ElevatedButton(
                              onPressed: controller.loadMoreArticles,
                              child: const Text('Read More'),
                            ),
                          ),
                        )
                      : const SizedBox.shrink());
            }

            final article = controller.displayedArticles[index];

            // ✨ Efek animasi tekan (scale halus)
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 375),
              child: SlideAnimation(
                verticalOffset: 40.0,
                child: FadeInAnimation(
                  child: GestureDetector(
                    onTapDown: (_) =>
                        controller.selectedArticleIndex.value = index,
                    onTapUp: (_) {
                      controller.selectedArticleIndex.value = -1;
                      Get.toNamed(Routes.NEWS_DETAIL, arguments: article);
                    },
                    onTapCancel: () =>
                        controller.selectedArticleIndex.value = -1,
                    child: Obx(() {
                      final isPressed =
                          controller.selectedArticleIndex.value == index;
                      return AnimatedScale(
                        scale: isPressed ? 0.97 : 1.0,
                        duration: const Duration(milliseconds: 120),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: NewsCard(
                            article: article,
                            onTap: () {
                              controller.selectedArticleIndex.value = index;
                              Future.delayed(const Duration(milliseconds: 30), () {
                                controller.selectedArticleIndex.value = -1;
                                Get.toNamed(Routes.NEWS_DETAIL, arguments: article);
                              });
                            },
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // 🏷️ Category list (tanpa animasi membesar)
  Widget _buildCategoryList() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: controller.categories.length,
        itemBuilder: (context, index) {
          final category = controller.categories[index];
          return Obx(
            () {
              final isSelected = controller.selectedCategory == category;
              return Container(
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey[300]!,
                    width: 1.2,
                  ),
                ),
                child: InkWell(
                  onTap: () => controller.selectCategory(category),
                  borderRadius: BorderRadius.circular(20),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 6),
                    child: Text(
                      category.capitalize ?? category,
                      style: TextStyle(
                        fontSize: 14,
                        color: isSelected
                            ? (Get.isDarkMode ? Colors.black : Colors.white)
                            : Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // ⚠️ Error widget
  Widget _buildErrorWidget() {
    return Center(
      key: const ValueKey('error'),
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cloud_off_outlined, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 24),
            const Text(
              'Oops, Something Went Wrong',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Please check your connection and try again.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              onPressed: controller.refreshNews,
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 📭 Empty widget
  Widget _buildEmptyWidget() {
    return Center(
      key: const ValueKey('empty'),
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.article_outlined, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 24),
            const Text(
              'No News Found',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'We couldn\'t find any articles for this category.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
