import 'package:isar/isar.dart';
part 'page.g.dart';
@embedded
@Name('pages')
class BookPage{
  String text;
  String image_url;
  int current_page;
  BookPage({this.text = '', this.image_url = '', this.current_page = 0});
  factory BookPage.fromJson(Map<String, dynamic> json) => BookPage(
    text: json['frame_desc'],
    image_url: json['frame_url'],
    current_page: json['frame_index'],
  );
}