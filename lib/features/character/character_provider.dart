import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_globals.dart';
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