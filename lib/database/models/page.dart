import 'package:isar/isar.dart';
part 'page.g.dart';
@embedded
@Name('pages')
class Page{
  String text;
  String image_url;
  int current_page;
  Page({this.text = '', this.image_url = '', this.current_page = 0});
  factory Page.fromJson(Map<String, dynamic> json) => Page(
    text: json['text'],
    image_url: json['image_url'],
    current_page: json['current_page'],
  );
}