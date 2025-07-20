import 'package:flutter_provider_local_save/configs/getit_config.dart';
import 'package:flutter_provider_local_save/data/services/api/post/post_api.dart';
import 'package:flutter_provider_local_save/data/services/network_handler.dart';
import 'package:flutter_provider_local_save/domain/models/post/post_model.dart';
import 'package:flutter_provider_local_save/utils/index.dart';
import 'package:flutter_provider_local_save/utils/result.dart';

class PostRepository {
  final PostApi postApi;

  PostRepository({required this.postApi});

  Future<Result<List<PostModel>>> getPosts() async {
    return await locator<NetworkHandler>().safeApiCall<List<PostModel>>(
      () async => await postApi.getPosts(),
      mapper: (data) =>
          Utils.parseListResponse<PostModel>(data, 'posts', PostModel.fromJson),
    );
  }
}
