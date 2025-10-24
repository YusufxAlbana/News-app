import 'package:get/get.dart';
import 'package:news_app/models/news_article.dart';
import 'package:news_app/services/news_service.dart';
import 'package:news_app/utils/constants.dart';

class NewsController extends GetxController {
  final NewsService _newsService = NewsService();

  // Observable variables
  final _isLoading = false.obs;
  final _articles = <NewsArticle>[].obs;
  final _displayedArticlesCount = 3.obs; // Initially show 3 articles
  final _selectedCategory = 'general'.obs;
  final _error = ''.obs;

  // ✨ Tambahan untuk animasi tekan artikel
  final selectedArticleIndex = (-1).obs;

  // Getters
  bool get isLoading => _isLoading.value;
  List<NewsArticle> get articles => _articles;
  List<NewsArticle> get displayedArticles =>
      _articles.take(_displayedArticlesCount.value).toList();
  int get displayedArticlesCount => _displayedArticlesCount.value;
  String get selectedCategory => _selectedCategory.value;
  String get error => _error.value;
  List<String> get categories => Constants.categories;

  @override
  void onInit() {
    super.onInit();
    fetchTopHeadlines();
  }

  Future<void> fetchTopHeadlines({String? category}) async {
    try {
      _isLoading.value = true;
      _error.value = '';
      _displayedArticlesCount.value = 3; // Reset count

      final response = await _newsService.getTopHeadlines(
        category: category ?? _selectedCategory.value,
      );

      _articles.value = response.articles;
    } catch (e) {
      _error.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to load news: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> refreshNews() async {
    await fetchTopHeadlines();
  }

  void selectCategory(String category) {
    if (_selectedCategory.value != category) {
      _selectedCategory.value = category;
      fetchTopHeadlines(category: category);
    }
  }

  Future<void> searchNews(String query) async {
    if (query.isEmpty) return;

    try {
      _isLoading.value = true;
      _error.value = '';
      _displayedArticlesCount.value = 3; // Reset count

      final response = await _newsService.searchNews(query: query);
      _articles.value = response.articles;
    } catch (e) {
      _error.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to search news: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      _isLoading.value = false;
    }
  }

  void loadMoreArticles() {
    if (_displayedArticlesCount.value < _articles.length) {
      _displayedArticlesCount.value += 3;
    }
  }
}
