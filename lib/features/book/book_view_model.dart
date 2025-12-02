import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../database/models/book.dart';
import '../../database/models/page.dart';
import '../../network/http.dart';
import '../login/login_repository.dart';
import 'book_repository.dart';
import 'book_state.dart';
import 'package:pdf/widgets.dart' as pw;

Future<Uint8List> _savePdfInBackground(pw.Document pdf) {
  return pdf.save();
}

class BookViewModel extends StateNotifier<BookState> {
  final BookRepository _bookRepository;

  BookViewModel(this._bookRepository) : super(BookState()) {
    _init();
  }

  void _init() {}

  void onPageChanged(int page) {
    state = state.copyWith(currentPage: page);
  }

  // 点击屏幕中央时切换沉浸模式/控制模式
  void toggleControls() {
    state = state.copyWith(isControlsVisible: !state.isControlsVisible);
  }

  // 截图
  Future<Uint8List> captureWidget(GlobalKey key) async {
    final RenderObject? renderObject = key.currentContext?.findRenderObject();

    if (renderObject == null || renderObject is! RenderRepaintBoundary) {
      throw Exception(
        "Widget associated with GlobalKey not found or is not a RepaintBoundary.",
      );
    }
    final RenderRepaintBoundary boundary = renderObject;
    final ui.Image image = await boundary.toImage(pixelRatio: 2.0);

    final ByteData? byteData = await image.toByteData(
      format: ui.ImageByteFormat.png,
    );
    if (byteData == null) {
      throw Exception("Failed to convert image to ByteData (PNG format).");
    }
    return byteData.buffer.asUint8List();
  }

  Future<void> shareBookPdf(
    List<BookPage> pages,
    Map<int, GlobalKey> keys,
    String bookName,
  ) async {
    state = state.copyWith(isLoading: true, message: "正在准备分享中...请稍后");
    final pdf = pw.Document();
    bool captureFailed = false;

    // 截图并添加到 PDF
    for (int i = 0; i < pages.length; i++) {
      final key = keys[i + 1];
      if (key == null) {
        captureFailed = true;
        continue;
      }
      try {
        final Uint8List imageBytes = await captureWidget(key);
        final image = pw.MemoryImage(imageBytes);
        pdf.addPage(
          pw.Page(
            build: (context) {
              return pw.Center(child: pw.Image(image, fit: pw.BoxFit.contain));
            },
          ),
        );
      } catch (e) {
        captureFailed = true;
      }
    }

    final dir = await getTemporaryDirectory();
    final filename = '${bookName.replaceAll(' ', '_')}_export.pdf';
    final file = File('${dir.path}/$filename');

    try {
      final Uint8List pdfBytes = await compute(_savePdfInBackground, pdf);
      await file.writeAsBytes(pdfBytes);
      await Share.shareXFiles(
        [XFile(file.path)],
        text: '我分享了一本精美的绘本：$bookName',
        subject: '绘本PDF分享',
      );
      state = state.copyWith(isLoading: false,message: "分享结束");
    } catch (e) {
      state = state.copyWith(isLoading: false, message: "分享失败");
    } finally {
      if (await file.exists()) {
        await file.delete();
      }
    }
  }

  Future<void> createBook(
    List<String> storyTypes,
    List<String> storyQualities,
  ) async {
    state = state.copyWith(isLoading: true, message: "绘本正在生成中...完成后会通知~");
    try {
      await _bookRepository.createBook(storyTypes, storyQualities);
      state = state.copyWith(
        isLoading: false,
        message: "绘本生成成功啦！可以在\"我的绘本\"中查看",
      );
    } on RepositoryException catch (e) {
      state = state.copyWith(isLoading: false, message: e.message);
      print(e.message);
    } catch (e) {
      state = state.copyWith(isLoading: false, message: e.toString());
    }
  }

  Future<void> createExclusiveBook(
    List<String> storyTypes,
    List<String> storyQualities,
    List<String> charactersId,
  ) async {
    state = state.copyWith(isLoading: true, message: "绘本正在生成中...完成后会通知~");
    try {
      await _bookRepository.createExclusiveBook(
        storyTypes,
        storyQualities,
        charactersId,
      );
      state = state.copyWith(
        isLoading: false,
        message: "绘本生成成功啦！可以在\"我的绘本\"中查看",
      );
    } on RepositoryException catch (e) {
      state = state.copyWith(isLoading: false, message: e.message);
      print(e.message);
    } catch (e) {
      state = state.copyWith(isLoading: false, message: e.toString());
    }
  }

  Future<void> deleteBook(String bookId) async {
    state = state.copyWith(isLoading: true, message: null);
    try {
      await _bookRepository.deleteBook(bookId);
      state = state.copyWith(isLoading: false, message: "删除成功");
    } on RepositoryException catch (e) {
      state = state.copyWith(isLoading: false, message: e.message);
    } catch (e) {
      state = state.copyWith(isLoading: false, message: e.toString());
    }
  }

  // 查询绘本列表
  Future<void> findBookList(String keyword) async {
    state = state.copyWith(isLoading: true, message: null);
    try {
      await _bookRepository.findBookList(keyword);
      state = state.copyWith(isLoading: false, message: null);
      // 查询成功之后的操作
    } on RepositoryException catch (e) {
      state = state.copyWith(isLoading: false, message: e.message);
    } catch (e) {
      state = state.copyWith(isLoading: false, message: e.toString());
    }
  }

  Future<void> fetchBookList() async {
    state = state.copyWith(isLoading: true, message: null);
    try {
      await _bookRepository.fetchBookList();
      state = state.copyWith(isLoading: false, message: null);
    } on RepositoryException catch (e) {
      state = state.copyWith(isLoading: false, message: e.message);
    } catch (e) {
      state = state.copyWith(isLoading: false, message: e.toString());
    }
  }

  // 打开绘本
  Future<void> loadBook(Book book, String userId) async {
    state = state.copyWith(
      isLoading: false,
      message: null,
      currentBook: book,
      currentPage: 0,
    );
    await _bookRepository.saveReadingHistory(book.bookId, userId);
  }

  Future<void> clearReadingHistory() async {
    state = state.copyWith(isLoading: false, message: null);
    await _bookRepository.clearReadingHistory();
    print('清空记录');
  }
}
