import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_globals.dart';
import 'login_repository.dart';
import 'login_viewmodel.dart';


final loginRepositoryProvider = Provider<LoginRepository>((ref) {
  final isar = AppGlobals().isar;
  return LoginRepository(isar);
});
final loginViewModelProvider = StateNotifierProvider<LoginViewModel, String>((ref) {
  final loginRepository = ref.watch(loginRepositoryProvider);
  return LoginViewModel(loginRepository);
});