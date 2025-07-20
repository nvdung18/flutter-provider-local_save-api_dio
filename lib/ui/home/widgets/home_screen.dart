import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_provider_local_save/configs/getit_config.dart';
import 'package:flutter_provider_local_save/domain/models/post/post_model.dart';
import 'package:flutter_provider_local_save/ui/core/ui/app_future_builder.dart';
import 'package:flutter_provider_local_save/ui/home/view_model/home_viewmodel.dart';
import 'package:flutter_provider_local_save/ui/home/widgets/featured_news_slider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<PostModel>> _postsFuture;

  final HomeViewModel homeViewModel = locator<HomeViewModel>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _postsFuture = homeViewModel.posts.isEmpty
        ? homeViewModel.fetchPosts()
        : Future.value(homeViewModel.posts);
  }

  // Danh sách featured news
  final List<Map<String, String>> featuredNews = [
    {
      'category': 'TECHNOLOGY',
      'title':
          'Microsoft launches a deepfake detector tool ahead of US election',
      'time': '3 min ago',
      'image':
          'https://res.cloudinary.com/dwbgxpb0o/image/upload/f_auto,q_auto/v1/aaaa/News_z5vgv3',
    },
    {
      'category': 'BUSINESS',
      'title': 'Apple announces new MacBook Pro with M3 chip',
      'time': '5 min ago',
      'image':
          'https://res.cloudinary.com/dwbgxpb0o/image/upload/f_auto,q_auto/v1/aaaa/Image_2_n2gdwi',
    },
    {
      'category': 'SCIENCE',
      'title': 'NASA successfully launches new Mars rover mission',
      'time': '10 min ago',
      'image':
          'https://res.cloudinary.com/dwbgxpb0o/image/upload/f_auto,q_auto/v1/aaaa/Image_1_nwfxdx',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    // Responsive values
    final double horizontalPadding = isTablet ? 32 : 16;
    final double verticalPadding = isTablet ? 24 : 16;
    final double newsImageSize = isTablet ? 120 : 80;
    final double newsImageRadius = isTablet ? 20 : 12;
    final double newsItemSpacing = isTablet ? 24 : 16;
    final double newsTitleFont = isTablet ? 22 : 16;
    final double newsCategoryFont = isTablet ? 16 : 12;
    final double latestNewsFont = isTablet ? 24 : 18;

    return AppFutureBuilder<List<PostModel>>(
      future: _postsFuture,
      isEmpty: (data) => data.isEmpty,
      emptyMessage: 'No posts available.',
      builder: (context, snapshot) {
        final posts = snapshot.data!;
        return Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                      horizontalPadding,
                      verticalPadding,
                      horizontalPadding,
                      isTablet ? 20 : 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FeaturedNewsSlider(
                          posts: posts.take(3).toList(),
                          featuredNews: featuredNews,
                        ),
                        SizedBox(height: isTablet ? 36 : 24),
                        _buildLatestNewsSection(latestNewsFont),
                        SizedBox(height: isTablet ? 24 : 16),
                        _buildNewsList(
                          posts,
                          newsImageSize,
                          newsImageRadius,
                          newsItemSpacing,
                          newsTitleFont,
                          newsCategoryFont,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildLatestNewsSection(double fontSize) {
    return Row(
      children: [
        Text(
          'Latest News',
          style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        Icon(Icons.more_horiz, color: Colors.grey[600]),
      ],
    );
  }

  Widget _buildNewsList(
    List<PostModel> posts,
    double imageSize,
    double imageRadius,
    double itemSpacing,
    double titleFont,
    double categoryFont,
  ) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: posts.length,
      itemBuilder: (context, index) {
        return ChangeNotifierProvider.value(
          value: posts[index],
          child: _buildNewsItem(
            posts[index],
            index,
            imageSize,
            imageRadius,
            itemSpacing,
            titleFont,
            categoryFont,
          ),
        );
      },
    );
  }

  Widget _buildNewsItem(
    PostModel post,
    int index,
    double imageSize,
    double imageRadius,
    double itemSpacing,
    double titleFont,
    double categoryFont,
  ) {
    final List<String> listImage = [
      'https://res.cloudinary.com/dwbgxpb0o/image/upload/f_auto,q_auto/v1/aaaa/Image_2_n2gdwi',
      'https://res.cloudinary.com/dwbgxpb0o/image/upload/f_auto,q_auto/v1/aaaa/Image_1_nwfxdx',
      'https://res.cloudinary.com/dwbgxpb0o/image/upload/f_auto,q_auto/v1/aaaa/Image_w6rgq5',
    ];

    final List<String> randomTitles = [
      'Breaking News: Flutter 4 Released!',
      'AI is changing the world!',
      'Discover the new Mars rover!',
      'Tech stocks are rising!',
      'New features in Dart 3!',
    ];

    final randomIndex = Random().nextInt(listImage.length);
    final randomImage = listImage[randomIndex];
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;
    return Consumer<PostModel>(
      builder: (context, post, child) {
        return Container(
          margin: EdgeInsets.only(bottom: itemSpacing),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.shuffle, color: Colors.blue),
                onPressed: () {
                  homeViewModel.updatePostTitle(
                    post,
                    (randomTitles..shuffle()).first,
                    index,
                  );
                },
              ),
              Container(
                width: imageSize,
                height: imageSize,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(imageRadius),
                  image: DecorationImage(
                    image: NetworkImage(randomImage),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: isTablet ? 24 : 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.tags.join(', ').toUpperCase(),
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: categoryFont,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: isTablet ? 8 : 4),
                    Text(
                      post.title,
                      style: TextStyle(
                        fontSize: titleFont,
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
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
}
