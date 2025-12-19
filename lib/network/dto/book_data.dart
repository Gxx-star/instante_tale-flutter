class BookData {
  final String bookId;
  final String bookName;
  final String authorName;
  final int starNumber;
  final String coverUrl;

  BookData({
    required this.bookId,
    required this.bookName,
    required this.authorName,
    required this.starNumber,
    required this.coverUrl,
  });

  factory BookData.fromJson(Map<String, dynamic> json) {
    return BookData(
      bookId: json['book_id'],
      bookName: json['book_name'],
      authorName: json['author_name'],
      starNumber: json['star_number'],
      coverUrl: json['cover_url'],
    );
  }
}
