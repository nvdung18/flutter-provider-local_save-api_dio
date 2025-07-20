import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_provider_local_save/ui/bookmark/widgets/bookmark_screen.dart';
import 'package:flutter_provider_local_save/ui/home/widgets/home_screen.dart';

class KUrls {
  static final String DUMMY_BASE = dotenv.env['BASE_URL_DUMMYJSON']!;
  static final String JSONPLACEHOLDER_BASE =
      dotenv.env['BASE_URL_JSONPLACEHOLDER']!;
}

class KSecureStorageKeys {
  static const String ACCESS_TOKEN = 'accessToken';
  static const String REFRESH_TOKEN = 'refreshToken';
}

class KNavbar {
  static List<Map<String, dynamic>> pageNavBar() {
    return [
      {
        'title': 'Home',
        'page': HomeScreen(),
        'icon': Icons.home_outlined,
        'selectedIcon': Icons.home,
      },
      {
        'title': 'Bookmarks',
        'page': BookmarkScreen(),
        'icon': Icons.bookmark_border,
        'selectedIcon': Icons.bookmark,
      },
      {
        'title': 'Search',
        'page': BookmarkScreen(),
        'icon': Icons.search,
        'selectedIcon': Icons.search,
      },
      {
        'title': 'Notification',
        'page': BookmarkScreen(),
        'icon': Icons.notifications_none,
        'selectedIcon': Icons.notifications,
      },
      {
        'title': 'Profile',
        'page': BookmarkScreen(),
        'icon': Icons.person_outline,
        'selectedIcon': Icons.person,
      },
    ];
  }
}
