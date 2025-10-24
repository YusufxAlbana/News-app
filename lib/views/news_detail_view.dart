import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share_plus/share_plus.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';
import 'package:news_app/models/news_article.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:news_app/utils/app_colors.dart';

class NewsDetailView extends StatelessWidget {
  final NewsArticle article = Get.arguments as NewsArticle;

  @override
  Widget build(BuildContext context) {
    const iconColor = Colors.white; // <- semua ikon putih

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: Colors.transparent,
            iconTheme: const IconThemeData(color: iconColor),
            titleTextStyle: const TextStyle(
              color: iconColor,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: article.urlToImage != null
                  ? CachedNetworkImage(
                      imageUrl: article.urlToImage!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) => const Center(
                        child: Icon(Icons.image_not_supported, size: 50, color: Colors.white70),
                      ),
                    )
                  : const Center(
                      child: Icon(Icons.newspaper, size: 50, color: Colors.white70),
                    ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.share, color: iconColor),
                onPressed: () => _shareArticle(),
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: iconColor),
                color: Theme.of(context).cardColor,
                onSelected: (value) {
                  switch (value) {
                    case 'copy_link':
                      _copyLink();
                      break;
                    case 'open_browser':
                      _openInBrowser();
                      break;
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'copy_link',
                    child: Row(
                      children: [
                        Icon(Icons.copy, color: Colors.black87),
                        SizedBox(width: 8),
                        Text('Copy Link'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'open_browser',
                    child: Row(
                      children: [
                        Icon(Icons.open_in_browser, color: Colors.black87),
                        SizedBox(width: 8),
                        Text('Open in Browser'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: AnimationLimiter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: AnimationConfiguration.toStaggeredList(
                    duration: const Duration(milliseconds: 375),
                    childAnimationBuilder: (widget) => SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(child: widget),
                    ),
                    children: [
                      Row(
                        children: [
                          if (article.source?.name != null) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                article.source!.name!,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                          ],
                          if (article.publishedAt != null) ...[
                            Text(
                              timeago.format(
                                DateTime.parse(article.publishedAt!),
                              ),
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (article.title != null) ...[
                        Text(
                          article.title!,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                      if (article.description != null) ...[
                        Text(
                          article.description!,
                          style: const TextStyle(
                            fontSize: 16,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                      if (article.content != null) ...[
                        const Text(
                          'Content',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          article.content!,
                          style: const TextStyle(
                            fontSize: 16,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                      if (article.url != null) ...[
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _openInBrowser,
                            style: ElevatedButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Read Full Article',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Helper Methods ---

  void _shareArticle() {
    if (article.url != null && article.url!.isNotEmpty) {
      Share.share(
        '${article.title ?? "Lihat berita ini"}\n\n${article.url!}',
        subject: article.title ?? 'Berita Menarik',
      );
    } else {
      Get.snackbar(
        'Tidak Bisa Membagikan',
        'Tautan berita tidak tersedia.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange[700],
        colorText: Colors.white,
      );
    }
  }

  void _openInBrowser() async {
    if (article.url != null && article.url!.isNotEmpty) {
      final Uri uri = Uri.parse(article.url!);
      try {
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          Get.snackbar(
            'Gagal Membuka Tautan',
            'Tidak dapat menemukan aplikasi browser.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: AppColors.error,
            colorText: Colors.white,
          );
        }
      } catch (e) {
        Get.snackbar(
          'Error',
          'Terjadi kesalahan saat membuka tautan.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.error,
          colorText: Colors.white,
        );
      }
    } else {
      Get.snackbar(
        'Tautan Tidak Tersedia',
        'URL untuk berita ini tidak ditemukan.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange[700],
        colorText: Colors.white,
      );
    }
  }

  void _copyLink() async {
    if (article.url != null && article.url!.isNotEmpty) {
      await Clipboard.setData(ClipboardData(text: article.url!));
      Get.snackbar(
        'Success',
        'Copied to clipboard.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.success,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(8),
        borderRadius: 8,
      );
    } else {
      Get.snackbar(
        'Error',
        'Link news is not available to copy.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.error,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(8),
        borderRadius: 8,
      );
    }
  }
}
