import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:instant_tale/app_globals.dart';
import 'package:instant_tale/features/login/login_viewmodel.dart';
import '../../features/login/login_provider.dart';
import '../../features/login/login_state.dart';
import '../../main.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginViewModelProvider);
    final loginViewModel = ref.read(loginViewModelProvider.notifier);
    ref.listen<String?>(
      loginViewModelProvider.select((state) => state.message),
      (previous, next) {
        if (next != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                next,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black),
              ),
              behavior: SnackBarBehavior.floating,
              // 悬浮
              backgroundColor: Colors.grey[200],
              // 深灰背景
              margin: const EdgeInsets.only(
                bottom: 60, // 距离底部距离
                left: 40, // 左右 padding（通过 margin 实现）
                right: 40,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12), // 小圆角
              ),
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      },
    );
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildTab(
                      context,
                      ref,
                      title: "密码登录",
                      type: 'pwd',
                      isActive: loginState.loginMethod == 'pwd',
                    ),
                    const SizedBox(width: 40),
                    _buildTab(
                      context,
                      ref,
                      title: "短信登录",
                      type: 'sms',
                      isActive: loginState.loginMethod == 'sms',
                    ),
                  ],
                ),
                // 表单
                Stack(
                  children: [
                    AnimatedSlide(
                      offset: loginState.loginMethod == 'pwd'
                          ? Offset.zero
                          : Offset(-1.2, 0),
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                      child: _buildPwdForm(context, loginViewModel, loginState),
                    ),
                    AnimatedSlide(
                      offset: loginState.loginMethod == 'sms'
                          ? Offset.zero
                          : Offset(1.2, 0),
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                      child: _buildSmsForm(context, loginViewModel, loginState),
                    ),
                  ],
                ),
                Spacer(),
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

  Widget _buildPwdForm(
    BuildContext context,
    LoginViewModel loginViewModel,
    LoginState loginState,
  ) {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(hintText: "请输入手机号"),
          onChanged: (value) {
            loginViewModel.updatePhone(value);
          },
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(padding: EdgeInsets.only(top: 10), child: Text("密码")),
        ),
        TextField(
          decoration: InputDecoration(hintText: "请输入密码"),
          onChanged: (value) {
            loginViewModel.updatePassword(value);
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
              loginViewModel.login().then((_){
                if (AppGlobals().isLoggedIn) {
                  context.push('/${AppRouteNames.main}');
                }
              });
            },
            child: Text("登录"),
          ),
        ),
        Text(loginState.message == null ? "请登录" : loginState.message!),
      ],
    );
  }

  Widget _buildSmsForm(
    BuildContext context,
    LoginViewModel loginViewModel,
    LoginState loginState,
  ) {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(hintText: "请输入手机号"),
          onChanged: (value) {
            loginViewModel.updatePhone(value);
          },
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(padding: EdgeInsets.only(top: 10), child: Text("验证码")),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: TextField(
                onChanged: (value) {
                  loginViewModel.updateSmsCode(value);
                },
                decoration: InputDecoration(hintText: "请输入验证码"),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20),
              child: ElevatedButton(
                onPressed: () {
                  // 发送验证码
                  loginViewModel.sendMsg();
                },
                child: Text("获取验证码"),
              ),
            ),
          ],
        ),
        SizedBox(height: 30),
        Container(
          width: 200,
          child: ElevatedButton(
            onPressed: () {
              loginViewModel.login().then((_){
                if (AppGlobals().isLoggedIn) {
                  context.push('/${AppRouteNames.main}');
                }
              });
            },
            child: Text("登录"),
          ),
        ),
        Text(loginState.message == null ? "请登录" : loginState.message!),
      ],
    );
  }

  Widget _buildTab(
    BuildContext context,
    WidgetRef ref, {
    required String title,
    required String type,
    required bool isActive,
  }) {
    return GestureDetector(
      onTap: () {
        ref.watch(loginViewModelProvider.notifier).switchLoginMethod(type);
      },
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              color: isActive ? Colors.blue : Colors.grey,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          if (isActive)
            Container(
              width: 40,
              height: 3,
              margin: const EdgeInsets.only(top: 5),
              color: Colors.blue,
            ),
        ],
      ),
    );
  }
}
