import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_globals.dart';
import '../../network/dto/login_data.dart';
import 'login_repository.dart';
import 'login_state.dart';
import 'login_viewmodel.dart';


final loginRepositoryProvider = Provider<LoginRepository>((ref) {
  final isar = AppGlobals().isar;
  return LoginRepository(isar);
});
final loginViewModelProvider = StateNotifierProvider<LoginViewModel, LoginState>((ref) {
  final loginRepository = ref.watch(loginRepositoryProvider);
  return LoginViewModel(loginRepository);
});