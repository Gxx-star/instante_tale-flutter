import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instant_tale/app_globals.dart';
import 'package:instant_tale/features/user/user_repository.dart';
import 'package:instant_tale/features/user/user_state.dart';
import 'package:instant_tale/features/user/user_viewmodel.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final isar = AppGlobals().isar;
  return UserRepository(isar);
});
final userViewModelProvider = StateNotifierProvider<UserViewModel,UserState>((ref) {
  final userRepository = ref.watch(userRepositoryProvider);
  return UserViewModel(userRepository);
});