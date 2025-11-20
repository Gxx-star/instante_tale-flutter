import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_globals.dart';
import 'character_repository.dart';
import 'character_viewmodel.dart';

final characterRepositoryProvider = Provider<CharacterRepository>((ref) {
  final isar = AppGlobals().isar;
  return CharacterRepository(isar);
});
final characterListProvider = StreamProvider((ref){
  return ref.watch(characterRepositoryProvider).watchCharacters();
});
final characterViewModelProvider = StateNotifierProvider((ref){
  final repository = ref.watch(characterRepositoryProvider);
  return CharacterViewModel(repository);
});