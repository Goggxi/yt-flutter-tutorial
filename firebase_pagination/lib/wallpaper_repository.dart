import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_pagination/wallpaper_model.dart';

class WallpaperRepository {
  static const String _collectionName = "wallpapers";

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<WallpaperModel>> getWallpapers({
    required int limit,
    required String lastId,
  }) async {
    if (lastId.isEmpty) {
      final snap =
          await _firestore.collection(_collectionName).limit(limit).get();

      final wallpapers =
          snap.docs.map((doc) => WallpaperModel.formMap(doc.data())).toList();

      return wallpapers;
    } else {
      final snap = await _firestore
          .collection(_collectionName)
          .startAfterDocument(
            await _firestore.collection(_collectionName).doc(lastId).get(),
          )
          .limit(limit)
          .get();

      final wallpapers =
          snap.docs.map((doc) => WallpaperModel.formMap(doc.data())).toList();

      return wallpapers;
    }
  }
}
