import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_provider_local_save/configs/getit_config.dart';
import 'package:flutter_provider_local_save/data/repositories/post/post_repository.dart';
import 'package:flutter_provider_local_save/data/services/api/api_service.dart';
import 'package:flutter_provider_local_save/data/services/local/hive_service.dart';
import 'package:flutter_provider_local_save/domain/models/post/post_model.dart';
import 'package:flutter_provider_local_save/ui/error/viewmodel/error_viewmodel.dart';
import 'package:flutter_provider_local_save/utils/constant.dart';
import 'package:flutter_provider_local_save/utils/result.dart';
import 'package:logger/logger.dart';

class HomeViewModel extends ChangeNotifier {
  final PostRepository _postRepositoryDummyBase = PostRepository(
    postApi: ApiService.getPostApi(baseUrl: KUrls.DUMMY_BASE),
  );

  List<PostModel> _posts = [];
  List<PostModel> get posts => _posts;

  Future<List<PostModel>> fetchPosts() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    bool isOnline = connectivityResult != ConnectivityResult.none;

    if (!isOnline) {
      Logger().i('No internet connection. Loading cached posts.');
      // If offline, get data from Hive
      final cachedPosts = await locator<HiveService>().getValues<PostModel>(
        boxName: 'posts',
      );
      _posts = cachedPosts;
      return _posts;
    }

    // If Online - Fetch from API
    // Clear the Hive cache before fetching new data
    await locator<HiveService>().clear<PostModel>(boxName: 'posts');
    final result = await _postRepositoryDummyBase.getPosts();
    switch (result) {
      case Ok(value: final posts):
        {
          _posts = posts;
          await locator<HiveService>().addAll<PostModel>(
            values: posts,
            boxName: 'posts',
          );

          // just to test getting data from Hive, you don't need to care this line
          _posts = await locator<HiveService>().getValues<PostModel>(
            boxName: 'posts',
          );
        }
      case Error(error: final e):
        {
          // Handle error appropriately, e.g., log it or show a message
          locator<ErrorViewModel>().setError(e);
          break;
        }
    }
    return _posts;
  }

  Future<void> updatePostTitle(
    PostModel post,
    String newTitle,
    int index,
  ) async {
    post.updateTitle(newTitle); // cập nhật title và notifyListeners

    // Lưu lại vào Hive,key thì có thể là id hoặc index tuỳ cách bạn lưu là theo addAll hay put với id
    final box = await locator<HiveService>().getBox<PostModel>(name: 'posts');

    // Nếu bạn lưu theo key là id
    // await box.put(post.id.toString(), post);

    // Nếu bạn lưu theo index (addAll), thì cần biết index của post trong box
    await box.putAt(index, post);
  }
}
