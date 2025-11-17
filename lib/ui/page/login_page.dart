import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:instant_tale/features/login/login_viewmodel.dart';
import 'package:instant_tale/ui/component/circular_button.dart';
import 'package:instant_tale/ui/component/promo_button.dart';
import 'package:instant_tale/ui/theme.dart';
import '../../features/login/login_provider.dart';
import '../../main.dart';

class LoginPage extends ConsumerWidget {
  var _inputPhone = "";
  var _inputPassword = "";

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginState = ref.watch(loginViewModelProvider);
    final loginViewModel = ref.read(loginViewModelProvider.notifier);
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children:
              [
                Padding(padding: EdgeInsets.only(top: 100)),
                Image(
                  image: AssetImage('assets/images/login_flag.png'),
                  height: 200,
                  width: 200,
                ),
                Text("欢迎使用即刻绘本"),
                TextField(
                  decoration: InputDecoration(hintText: "请输入手机号"),
                  onChanged: (value) {
                    _inputPhone = value;
                  },
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text("密码"),
                  ),
                ),
                TextField(
                  decoration: InputDecoration(hintText: "请输入密码"),
                  onChanged: (value) {
                    _inputPassword = value;
                  },
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(top: 10, right: 10),
                    child: GestureDetector(
                      onTap: () {
                        context.push('/${AppRouteNames.forgetPassword}');
                      },
                      child: Text(
                        "忘记密码",
                        style: TextStyle(
                          color: Color(0xFFFF00AA),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.none, // 不要下划线
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () {
                      loginViewModel.login();
                    },
                    child: Text("登录"),
                  ),
                ),
                Text(loginState.errorMessage==null?"请登录":loginState.errorMessage!),
                Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("还没有账号？"),
                    TextButton(
                      onPressed: () {
                        context.push('/${AppRouteNames.register}');
                      },
                      child: Text("注册"),
                    ),
                  ],
                ),
              ].map((child) {
                if (child is Spacer) {
                  return child;
                }
                return Padding(
                  padding: const EdgeInsets.only(
                    left: 30,
                    right: 30,
                    bottom: 10,
                  ),
                  child: child,
                );
              }).toList(),
        ),
      ),
    );
  }
}
