// lib/widgets/news_card.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:news_app/models/news_article.dart';

class NewsCard extends StatelessWidget {
  final NewsArticle article;
  final VoidCallback onTap;

  const NewsCard({Key? key, required this.article, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.urlToImage != null)
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                child: CachedNetworkImage(
                  imageUrl: article.urlToImage!,
                  height: 270,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    height: 200,    
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => Container(
                    height: 200,
                    child: Center(
                      child: Icon(
                        Icons.image_not_supported,
                        size: 40,
                      ),
                    ),
                  ),
                ),
              ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (article.source?.name != null) ...[
                        Expanded(
                          child: Text(
                            article.source!.name!,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 8),
                      ],
                      if (article.publishedAt != null)
                        Text(
                          timeago.format(DateTime.parse(article.publishedAt!)),
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: 12),
                  if (article.title != null)
                    Text(
                      article.title!,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  SizedBox(height: 8),
                  if (article.description != null)
                    Text(
                      article.description!,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Read More...',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
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
}