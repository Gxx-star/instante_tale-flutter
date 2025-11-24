import '../../database/models/character.dart';

class CharacterState {
  final bool isLoading;
  final String? message;
  final String searchKeyword;
  final List<CharacterCollection> filteredList;
  CharacterState({
    this.isLoading = false,
    this.message,
    this.searchKeyword = '',
    this.filteredList = const []
  });

  CharacterState copyWith({
    bool? isLoading,
    String? message,
    String? searchKeyword,
    List<CharacterCollection>? filteredList,
    Map<String, List<CharacterCollection>>? groupedMap,
  }) {
    return CharacterState(
      isLoading: isLoading ?? this.isLoading,
      message: message,
      searchKeyword: searchKeyword ?? this.searchKeyword,
      filteredList: filteredList ?? this.filteredList
    );
  }
}