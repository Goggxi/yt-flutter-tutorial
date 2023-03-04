import 'package:firebase_pagination/wallpaper_model.dart';
import 'package:firebase_pagination/wallpaper_repository.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class WallpaperProvider with ChangeNotifier {
  final WallpaperRepository _repo = WallpaperRepository();

  final PagingController<String, WallpaperModel> _pagingController =
      PagingController(firstPageKey: "");

  PagingController<String, WallpaperModel> get pagingController =>
      _pagingController;

  WallpaperProvider() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  Future<void> _fetchPage(String pageKey) async {
    try {
      final newItems = await _repo.getWallpapers(limit: 5, lastId: pageKey);

      final isLastPage = newItems.length < 5;

      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        _pagingController.appendPage(newItems, newItems.last.id);
      }
    } catch (e) {
      _pagingController.error = e;
    }
  }

  void refresh() {
    _pagingController.refresh();
  }
}
