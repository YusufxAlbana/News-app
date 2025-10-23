import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share_plus/share_plus.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';
import 'package:news_app/models/news_article.dart';
import 'package:news_app/utils/app_colors.dart';

class NewsDetailView extends StatelessWidget {
  final NewsArticle article = Get.arguments as NewsArticle;

  NewsDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    // Mengatur locale timeago ke Indonesia jika belum diatur di main
     try {
       timeago.setLocaleMessages('id', timeago.IdMessages());
     } catch (_) {
       // Locale might already be set
     }


    // Parsing tanggal dengan penanganan error
    DateTime? publishedDate;
    if (article.publishedAt != null) {
      try {
        publishedDate = DateTime.parse(article.publishedAt!);
      } catch (e) {
        // Handle error parsing date if necessary
      }
    }


    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverPadding( // Padding untuk konten di bawah AppBar
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 100), // Padding bawah untuk FAB
            sliver: SliverToBoxAdapter(
              child: _buildArticleContent(publishedDate),
            ),
          ),
        ],
      ),
      // Tombol 'Baca Selengkapnya' dibuat melayang di bawah
      floatingActionButton: _buildReadMoreButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  // SliverAppBar yang dinamis
  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 280, // Sedikit lebih kecil
      pinned: true,
      stretch: true,
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white, // Warna tombol back & actions
       // Mengatur status bar style saat AppBar di-expand dan collapse
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark, // Untuk iOS
        statusBarIconBrightness: Brightness.light, // Untuk Android
      ),
      iconTheme: const IconThemeData(color: Colors.white),
      flexibleSpace: FlexibleSpaceBar(
        background: _buildAppBarBackground(),
        stretchModes: const [
          StretchMode.zoomBackground,
          // StretchMode.blurBackground, // Blur bisa dihilangkan jika terasa berat
        ],
         // Menghilangkan judul default FlexibleSpaceBar jika tidak diperlukan
         titlePadding: EdgeInsets.zero,
         title: null, // Atau bisa diisi widget judul kustom jika mau
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.share_outlined),
          onPressed: _shareArticle,
          tooltip: 'Bagikan Artikel',
        ),
        IconButton(
          icon: const Icon(Icons.open_in_browser_outlined),
          onPressed: _openInBrowser,
          tooltip: 'Buka di Browser',
        ),
      ],
    );
  }

  // Latar belakang untuk AppBar dengan Hero animation dan gradient
  Widget _buildAppBarBackground() {
    return Hero(
      tag: article.url ?? UniqueKey().toString(), // Pastikan tag unik
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (article.urlToImage != null && article.urlToImage!.isNotEmpty)
            CachedNetworkImage(
              imageUrl: article.urlToImage!,
              fit: BoxFit.cover,
               placeholder: (context, url) => Container(color: AppColors.divider),
              errorWidget: (context, url, error) => _buildImagePlaceholder(),
               fadeInDuration: const Duration(milliseconds: 300), // Fade in image
            )
          else
            _buildImagePlaceholder(),
          // Gradient agar ikon AppBar kontras
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.6),
                  Colors.black.withOpacity(0.3), // Gradient lebih halus
                  Colors.transparent
                ],
                begin: Alignment.topCenter,
                end: Alignment.center, // Gradient hanya di bagian atas
                 stops: const [0.0, 0.4, 1.0], // Mengatur penyebaran gradient
              ),
            ),
          ),
        ],
      ),
    );
  }

 // Placeholder jika gambar tidak ada atau error
  Widget _buildImagePlaceholder() {
    return Container(
      color: AppColors.divider, // Warna placeholder yang lebih netral
      child: const Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          size: 50,
          color: AppColors.textHint,
        ),
      ),
    );
  }


  // Konten utama artikel berita
  Widget _buildArticleContent(DateTime? publishedDate) {
    // Membersihkan konten dari tag [+/- chars]
    String cleanedContent = article.content ?? '';
    int charMarkerIndex = cleanedContent.indexOf(' [+');
    if (charMarkerIndex != -1) {
      cleanedContent = cleanedContent.substring(0, charMarkerIndex).trim();
    }
     // Tambahkan titik di akhir jika belum ada
    if (cleanedContent.isNotEmpty && !cleanedContent.endsWith('.')) {
      cleanedContent += '...';
    }


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Judul Artikel
        if (article.title != null && article.title!.isNotEmpty) ...[
          Text(
            article.title!,
            style: const TextStyle(
              fontSize: 22, // Ukuran font judul
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              height: 1.4, // Spasi antar baris
            ),
          ),
          const SizedBox(height: 16), // Jarak antara judul dan source/date
        ],

         // Source dan Tanggal Publish
        _buildSourceAndDate(publishedDate),
        const SizedBox(height: 20), // Jarak antara source/date dan konten

        // Deskripsi (jika ada dan berbeda dari awal konten)
        if (article.description != null &&
            article.description!.isNotEmpty &&
            !cleanedContent.startsWith(article.description!.substring(0, (article.description!.length * 0.8).toInt()))) ...[
             Text(
              article.description!,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
                height: 1.7,
                 fontWeight: FontWeight.w500, // Sedikit penekanan
                 fontStyle: FontStyle.italic, // Gaya miring untuk deskripsi
              ),
            ),
          const SizedBox(height: 16),
        ],


        // Konten Artikel
        if (cleanedContent.isNotEmpty) ...[
          Text(
            cleanedContent,
            style: const TextStyle(
              fontSize: 15.5, // Ukuran font konten
              color: AppColors.textSecondary, // Warna teks konten
              height: 1.75, // Spasi antar baris lebih nyaman dibaca
              wordSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 24), // Jarak sebelum tombol 'Baca Selengkapnya' muncul
        ],

        // Tambahkan info penulis jika ada
         if (article.source?.name != null && article.source!.name!.isNotEmpty) ...[
          const Divider(height: 30, thickness: 0.5),
           Row(
             children: [
               const Icon(Icons.person_outline, size: 16, color: AppColors.textHint),
               const SizedBox(width: 8),
               Text(
                 'Sumber: ${article.source!.name}',
                 style: const TextStyle(
                   color: AppColors.textHint,
                   fontSize: 13,
                 ),
               ),
             ],
           ),
            const SizedBox(height: 8),
         ],
      ],
    );
  }

 // Widget untuk menampilkan sumber dan tanggal berita
  Widget _buildSourceAndDate(DateTime? publishedDate) {
    return Row(
      children: [
        if (article.source?.name != null && article.source!.name!.isNotEmpty) ...[
          // Chip untuk source
           Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.accent.withOpacity(0.15), // Warna chip lebih lembut
              borderRadius: BorderRadius.circular(15), // Lebih bulat
            ),
            child: Text(
              article.source!.name!,
              style: const TextStyle(
                color: AppColors.accent, // Warna teks sesuai aksen
                fontSize: 12,
                fontWeight: FontWeight.w600, // Sedikit lebih tebal
              ),
            ),
          ),
          const SizedBox(width: 12),
        ],
        // Tanggal Publish
        if (publishedDate != null)
          Expanded(
            child: Text(
              timeago.format(publishedDate, locale: 'id'),
              style: const TextStyle(
                color: AppColors.textHint, // Warna lebih soft
                fontSize: 12.5, // Sedikit lebih besar
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
      ],
    );
  }


  // Tombol "Baca Selengkapnya"
  Widget _buildReadMoreButton() {
    if (article.url == null || article.url!.isEmpty) return const SizedBox.shrink(); // Hide if no URL

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15), // Padding disesuaikan
      child: ElevatedButton.icon(
        onPressed: _openInBrowser,
        icon: const Icon(Icons.language_outlined, size: 20), // Icon yang lebih sesuai
        label: const Text('Baca Selengkapnya di Sumber', style: TextStyle(fontWeight: FontWeight.w600)),
        style: ElevatedButton.styleFrom(
           backgroundColor: AppColors.accent, // Warna tombol menggunakan accent
           foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 48), // Tinggi tombol
           shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Radius sudut tombol
          ),
          elevation: 3, // Sedikit shadow
        ),
      ),
    );
  }


  // --- Helper Methods ---

  void _shareArticle() {
    if (article.url != null && article.url!.isNotEmpty) {
      Share.share(
        '${article.title ?? "Lihat berita ini"}\n\n${article.url!}',
        subject: article.title ?? 'Berita Menarik', // Default subject
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
        // Coba buka di browser eksternal
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          // Fallback jika tidak bisa buka di eksternal (jarang terjadi)
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
}