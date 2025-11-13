import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instant_tale/features/login/login_provider.dart';

class ForgetPasswordPage extends ConsumerWidget{
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginViewModel = ref.watch(loginViewModelProvider);
    return const Placeholder();
  }
}
