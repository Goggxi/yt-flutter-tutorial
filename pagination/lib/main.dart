import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:pagination/model.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tutorial Pagination',
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Tutorial Pagination'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const int _perPage = 10;
  static const String _query = "vespa";
  final PagingController<int, Photo> _pagingController = PagingController(
    firstPageKey: 1,
  );

  Future<void> _getImages(int page) async {
    final client = http.Client();
    try {
      final result = await client.get(
        Uri.parse(
          "https://api.pexels.com/v1/search?query=$_query&per_page=$_perPage&page=$page",
        ),
        headers: {
          "Authorization":
              "563492ad6f9170000100000101a712a547374966becfee6921db5f10"
        },
      );

      if (result.statusCode == 200) {
        final model = ResponseModel.fromJson(result.body);
        final isLastPage = model.photos.length < _perPage;
        if (isLastPage) {
          _pagingController.appendLastPage(model.photos);
        } else {
          _pagingController.appendPage(model.photos, page + 1);
        }
      } else if (result.statusCode == 400) {
        _pagingController.error = jsonDecode(result.body)["code"];
      } else {
        _pagingController.error = jsonDecode(result.body)["error"];
      }
    } catch (e) {
      _pagingController.error = "Annother Error : $e";
    } finally {
      client.close();
    }
  }

  Color _parseColor(String code) =>
      Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) => _getImages(pageKey));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async => _pagingController.refresh(),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              title: Text(widget.title),
              floating: true,
              snap: true,
            ),
            PagedSliverList(
              pagingController: _pagingController,
              builderDelegate: PagedChildBuilderDelegate<Photo>(
                itemBuilder: (_, item, __) => AspectRatio(
                  aspectRatio: item.width / item.height,
                  child: CachedNetworkImage(
                    imageUrl: item.src.large2X,
                    placeholder: (_, __) => Container(
                      color: _parseColor(item.avgColor),
                    ),
                  ),
                ),
                firstPageErrorIndicatorBuilder: (context) => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(_pagingController.error),
                    IconButton(
                      onPressed: () => _pagingController.refresh(),
                      icon: const Icon(Icons.refresh),
                    ),
                  ],
                ),

              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
