import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:news_app/models/news_article.dart';
import 'package:news_app/utils/app_colors.dart';

class NewsCard extends StatelessWidget {
  final NewsArticle article;
  final VoidCallback onTap;

  const NewsCard({Key? key, required this.article, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        // PERBAIKAN: Spasi antar kartu diatur di sini agar bayangan tidak terpotong
        margin: const EdgeInsets.only(bottom: 20.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          // PERBAIKAN: Menggunakan warna kartu dari tema agar mendukung dark mode
          color: theme.cardColor,
          boxShadow: [
            BoxShadow(
              color: AppColors.cardShadow.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Bagian Gambar dengan Overlay ---
            _buildImageWithOverlay(context),

            // --- Bagian Konten Teks ---
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Judul
                  if (article.title != null)
                    Text(
                      article.title!,
                      // PERBAIKAN: Menggunakan style dari tema (GoogleFonts)
                      style: theme.textTheme.titleMedium?.copyWith(
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  const SizedBox(height: 12),

                  // Deskripsi
                  if (article.description != null)
                    Text(
                      article.description!,
                      // PERBAIKAN: Menggunakan style dari tema (GoogleFonts)
                      style: theme.textTheme.bodyMedium?.copyWith(
                        height: 1.5,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageWithOverlay(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      child: Stack(
        children: [
          // --- Gambar Latar Belakang ---
          if (article.urlToImage != null)
            CachedNetworkImage(
              imageUrl: article.urlToImage!,
              height: 220,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                height: 220,
                color: Theme.of(context).dividerColor,
              ),
              errorWidget: (context, url, error) => Container(
                height: 220,
                color: Theme.of(context).dividerColor,
                child: Center(
                  child: Icon(
                    Icons.broken_image_outlined,
                    size: 40,
                    color: Theme.of(context).hintColor,
                  ),
                ),
              ),
            ),
          // --- Gradient Overlay ---
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: const [0.0, 0.7],
                ),
              ),
            ),
          ),

          // --- Konten Atas (Sumber, Waktu) ---
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Chip Sumber
                if (article.source?.name != null)
                  Flexible(
                    child: Chip(
                      label: Text(
                        article.source!.name!,
                        overflow: TextOverflow.ellipsis,
                      ),
                      backgroundColor: AppColors.primary,
                      labelStyle: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                const SizedBox(width: 8),
                if (article.publishedAt != null)
                  Text(
                    timeago.format(DateTime.parse(article.publishedAt!)),
                    style: GoogleFonts.lato(
                      color: Colors.white,
                      fontSize: 13,
                      shadows: [
                        const Shadow(blurRadius: 6, color: Colors.black87)
                      ],
                    ),
                  ),
              ],
            ),
          ),
          
          // --- Tombol Bookmark ---
          Positioned(
            bottom: 12,
            right: 12,
            child: Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.4),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.bookmark_border_rounded, color: Colors.white),
                onPressed: () {
                  // Aksi untuk bookmark bisa ditambahkan di sini
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}