import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_provider_local_save/domain/models/post/post_hive_adapter.dart';
import 'package:flutter_provider_local_save/domain/models/post/post_model.dart';
import 'package:hive/hive.dart';

class HiveService {
  // Khởi tạo Hive (gọi 1 lần trong main.dart)
  Future<void> init() async {
    if (!kIsWeb) {
      // Only set path for non-web platforms
      var path = Directory.current.path;
      Hive.init(path);
    }

    // Đăng ký adapters nếu có
    Hive.registerAdapter(PostHiveModelAdapter());

    // openBox for models
    await Hive.openBox<PostModel>('posts');
  }

  // Lấy box (tự động tạo nếu chưa tồn tại)
  Future<Box<T>> getBox<T>({required String name}) async {
    if (Hive.isBoxOpen(name)) {
      return Hive.box<T>(name);
    }
    return await Hive.openBox<T>(name);
  }

  // Utility methods cho việc thao tác dữ liệu
  Future<void> put({
    required String key,
    dynamic value,
    required String boxName,
  }) async {
    final box = await getBox(name: boxName);
    box.put(key, value);
  }

  Future<void> addAll<T>({
    required List<T> values,
    required String boxName,
  }) async {
    final box = await getBox<T>(name: boxName);
    await box.addAll(values);
  }

  Future<T?> get<T>({required String key, required String boxName}) async {
    final box = await getBox(name: boxName);
    return box.get(key);
  }

  Future<void> delete({required String key, required String boxName}) async {
    final box = await getBox(name: boxName);
    box.delete(key);
  }

  Future<void> clear<T>({required String boxName}) async {
    final box = await getBox<T>(name: boxName);
    box.clear();
  }

  Future<bool> containsKey({
    required String key,
    required String boxName,
  }) async {
    final box = await getBox(name: boxName);
    return box.containsKey(key);
  }

  Future<List<String>> getKeys({required String boxName}) async {
    final box = await getBox(name: boxName);
    return box.keys.cast<String>().toList();
  }

  Future<List<T>> getValues<T>({required String boxName}) async {
    final box = await getBox<T>(name: boxName);
    return box.values.cast<T>().toList();
  }

  // Đóng tất cả boxes
  Future<void> closeAll() async {
    await Hive.close();
  }
}
