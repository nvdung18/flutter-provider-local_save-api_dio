import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'post_api.g.dart';

@RestApi()
abstract class PostApi {
  factory PostApi(Dio dio, {String baseUrl}) = _PostApi;

  @GET('/posts')
  Future<dynamic> getPosts();

  @GET('/posts/search')
  Future<dynamic> searchPosts(@Query('q') String query);
}
