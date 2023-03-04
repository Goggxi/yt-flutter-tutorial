class WallpaperModel {
  final String id;
  final String name;
  final String imageUrl;

  const WallpaperModel({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  factory WallpaperModel.formMap(Map<String, dynamic> map) {
    return WallpaperModel(
      id: map["id"],
      name: map["name"],
      imageUrl: map["image-url"],
    );
  }
}
