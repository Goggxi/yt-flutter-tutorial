import 'dart:convert';

class ResponseModel {
  ResponseModel({
    required this.photos,
  });

  final List<Photo> photos;

  factory ResponseModel.fromJson(String str) =>
      ResponseModel.fromMap(json.decode(str));

  factory ResponseModel.fromMap(Map<String, dynamic> json) => ResponseModel(
        photos: List<Photo>.from(json["photos"].map((x) => Photo.fromMap(x))),
      );
}

class Photo {
  Photo({
    required this.id,
    required this.width,
    required this.height,
    required this.avgColor,
    required this.src,
  });

  final int id;
  final int width;
  final int height;
  final String avgColor;
  final Src src;

  factory Photo.fromJson(String str) => Photo.fromMap(json.decode(str));

  factory Photo.fromMap(Map<String, dynamic> json) => Photo(
        id: json["id"],
        width: json["width"],
        height: json["height"],
        avgColor: json["avg_color"],
        src: Src.fromMap(json["src"]),
      );
}

class Src {
  Src({
    required this.large2X,
  });

  final String large2X;

  factory Src.fromJson(String str) => Src.fromMap(json.decode(str));

  factory Src.fromMap(Map<String, dynamic> json) => Src(
        large2X: json["large2x"],
      );
}
