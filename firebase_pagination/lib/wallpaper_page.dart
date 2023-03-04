import 'package:firebase_pagination/wallpaper_model.dart';
import 'package:firebase_pagination/wallpaper_provider.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

class WallpaperPage extends StatelessWidget {
  const WallpaperPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Wallpaper Pagination"),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Consumer<WallpaperProvider>(builder: (context, value, child) {
        return RefreshIndicator(
          onRefresh: () => Future.sync(value.refresh),
          child: PagedListView<String, WallpaperModel>.separated(
            padding: const EdgeInsets.all(16),
            pagingController: value.pagingController,
            builderDelegate: PagedChildBuilderDelegate<WallpaperModel>(
              itemBuilder: (context, item, index) => _WallpaperCard(
                index: index + 1,
                name: item.name,
                imageUrl: item.imageUrl,
              ),
            ),
            separatorBuilder: (context, index) => const SizedBox(height: 16),
          ),
        );
      }),
    );
  }
}

class _WallpaperCard extends StatelessWidget {
  const _WallpaperCard({
    required this.index,
    required this.name,
    required this.imageUrl,
  });

  final int index;
  final String name;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Image.network(
            imageUrl,
            width: double.infinity,
            height: 220,
            fit: BoxFit.cover,
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(8),
              color: Colors.black54,
              child: Text(
                "$index. $name",
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
