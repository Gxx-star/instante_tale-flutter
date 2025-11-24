import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lpinyin/lpinyin.dart';

import '../../app_globals.dart';
import '../../database/models/character.dart';
import 'character_repository.dart';
import 'character_viewmodel.dart';

final characterRepositoryProvider = Provider<CharacterRepository>((ref) {
  final isar = AppGlobals().isar;
  return CharacterRepository(isar);
});
final characterViewModelProvider = StateNotifierProvider((ref){
  final repository = ref.watch(characterRepositoryProvider);
  return CharacterViewModel(repository);
});
final characterListProvider = StreamProvider((ref){
  final repository = ref.watch(characterRepositoryProvider);
  return repository.watchCharacters();
});
final groupedCharactersProvider = Provider<AsyncValue<Map<String, List<CharacterCollection>>>>((ref) {
  final asyncList = ref.watch(characterListProvider);

  return asyncList.whenData((list) {
    // 按拼音排序
    list.sort((a, b) {
      final aPinyin = PinyinHelper.getPinyin(a.characterName);
      final bPinyin = PinyinHelper.getPinyin(b.characterName);
      return aPinyin.compareTo(bPinyin);
    });

    // 分组
    final Map<String, List<CharacterCollection>> grouped = {};
    for (var char in list) {
      final initial = char.pinyinInitial;
      grouped.putIfAbsent(initial, () => []).add(char);
    }

    // 字母排序
    final sortedKeys = grouped.keys.toList()..sort();
    final sortedGrouped = {for (var k in sortedKeys) k: grouped[k]!};

    return sortedGrouped;
  });
});