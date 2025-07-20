import 'package:flutter_provider_local_save/domain/models/post/post_model.dart';
import 'package:hive/hive.dart';

class PostHiveModelAdapter extends TypeAdapter<PostModel> {
  @override
  final int typeId = 1;

  @override
  PostModel read(BinaryReader reader) {
    return PostModel(
      id: reader.readInt(),
      title: reader.readString(),
      body: reader.readString(),
      tags: reader.readList().cast<String>(),
      reactions: Reactions(likes: reader.readInt(), dislikes: reader.readInt()),
      views: reader.readInt(),
      userId: reader.readInt(),
    );
  }

  @override
  void write(BinaryWriter writer, PostModel obj) {
    writer.writeInt(obj.id);
    writer.writeString(obj.title);
    writer.writeString(obj.body);
    writer.writeList(obj.tags);
    writer.writeInt(obj.reactions.likes);
    writer.writeInt(obj.reactions.dislikes);
    writer.writeInt(obj.views);
    writer.writeInt(obj.userId);
  }
}

class ReactionsHiveAdapter extends TypeAdapter<Reactions> {
  @override
  final int typeId = 2;

  @override
  Reactions read(BinaryReader reader) {
    return Reactions(likes: reader.readInt(), dislikes: reader.readInt());
  }

  @override
  void write(BinaryWriter writer, Reactions obj) {
    writer.writeInt(obj.likes);
    writer.writeInt(obj.dislikes);
  }
}
