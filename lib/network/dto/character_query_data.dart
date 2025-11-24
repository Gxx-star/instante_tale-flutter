import 'package:instant_tale/database/models/character.dart';

class CharacterQueryData{
  List<CharacterCollection> characters;
  String? keyword;
  CharacterQueryData({required this.characters, this.keyword});
}