import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_provider_local_save/domain/models/post/post_model.dart';

class FeaturedNewsSlider extends StatefulWidget {
  final List<PostModel> posts;
  final List<Map<String, String>> featuredNews;
  const FeaturedNewsSlider({
    super.key,
    required this.posts,
    required this.featuredNews,
  });

  @override
  State<FeaturedNewsSlider> createState() => _FeaturedNewsSliderState();
}

class _FeaturedNewsSliderState extends State<FeaturedNewsSlider> {
  int _currentIndex = 0;
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    // Responsive values
    final double sliderHeight = isTablet ? 400 : 240;
    final double borderRadius = isTablet ? 24 : 16;
    final double paddingAll = isTablet ? 32 : 16;
    final double tagFont = isTablet ? 16 : 12;
    final double tagPaddingH = isTablet ? 18 : 12;
    final double tagPaddingV = isTablet ? 10 : 6;
    final double titleFont = isTablet ? 32 : 24;
    final double actionBtnSize = isTablet ? 56 : 40;
    final double actionIconSize = isTablet ? 28 : 20;
    final double dotHeight = isTablet ? 12 : 8;
    final double dotWidth = isTablet ? 32 : 24;
    final double dotSmallWidth = isTablet ? 12 : 8;
    final double dotRadius = isTablet ? 6 : 4;

    return Column(
      children: [
        CarouselSlider.builder(
          carouselController: _carouselController,
          options: CarouselOptions(
            height: sliderHeight,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 5),
            enlargeCenterPage: true,
            viewportFraction: 0.9,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          itemCount: widget.posts.length,
          itemBuilder: (context, index, realIndex) {
            final post = widget.posts[index];
            final news = widget.featuredNews[index];
            return Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadius),
                image: DecorationImage(
                  image: NetworkImage(news['image']!),
                  fit: BoxFit.cover,
                ),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(borderRadius),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                  ),
                ),
                padding: EdgeInsets.all(paddingAll),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category and time
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: tagPaddingH,
                            vertical: tagPaddingV,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            post.tags.join(', ').toUpperCase(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: tagFont,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          news['time']!,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: tagFont,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    // Title
                    Text(
                      post.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: titleFont,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                    SizedBox(height: isTablet ? 24 : 16),
                    // Action buttons
                    Row(
                      children: [
                        _buildActionButton(
                          Icons.chat_bubble_outline,
                          actionBtnSize,
                          actionIconSize,
                        ),
                        SizedBox(width: isTablet ? 24 : 16),
                        _buildActionButton(
                          Icons.bookmark_border,
                          actionBtnSize,
                          actionIconSize,
                        ),
                        const Spacer(),
                        _buildActionButton(
                          Icons.share,
                          actionBtnSize,
                          actionIconSize,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        SizedBox(height: isTablet ? 24 : 16),
        _DotIndicator(
          count: widget.featuredNews.length,
          currentIndex: _currentIndex,
          onDotTap: (index) {
            _carouselController.animateToPage(index);
          },
          dotHeight: dotHeight,
          dotWidth: dotWidth,
          dotSmallWidth: dotSmallWidth,
          dotRadius: dotRadius,
        ),
      ],
    );
  }

  Widget _buildActionButton(IconData icon, double btnSize, double iconSize) {
    return Container(
      width: btnSize,
      height: btnSize,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(btnSize / 2),
      ),
      child: Icon(icon, color: Colors.white, size: iconSize),
    );
  }
}

/// Widget tách riêng cho dot indicator
class _DotIndicator extends StatelessWidget {
  final int count;
  final int currentIndex;
  final ValueChanged<int> onDotTap;
  final double dotHeight;
  final double dotWidth;
  final double dotSmallWidth;
  final double dotRadius;
  const _DotIndicator({
    required this.count,
    required this.currentIndex,
    required this.onDotTap,
    required this.dotHeight,
    required this.dotWidth,
    required this.dotSmallWidth,
    required this.dotRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        count,
        (index) => GestureDetector(
          onTap: () => onDotTap(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            height: dotHeight,
            width: currentIndex == index ? dotWidth : dotSmallWidth,
            decoration: BoxDecoration(
              color: currentIndex == index ? Colors.blue : Colors.grey[300],
              borderRadius: BorderRadius.circular(dotRadius),
            ),
          ),
        ),
      ),
    );
  }
}
