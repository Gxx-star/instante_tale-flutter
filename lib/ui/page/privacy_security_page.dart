import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:instant_tale/main.dart';
import 'package:instant_tale/ui/component/glass_button.dart';
import 'package:instant_tale/ui/component/my_snackbar.dart';

import '../../features/login/login_provider.dart';
import '../../features/user/user_provider.dart';

class PrivacySecurityPage extends ConsumerWidget {
  const PrivacySecurityPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(userViewModelProvider.select((state) => state.message), (
      previous,
      next,
    ) {
      if (next != null) {
        MySnackBar.show(context, next);
      }
    });
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0FF), // 柔和背景色
      body: Column(
        children: [
          // 顶部 AppBar (样式沿用)
          Container(
            padding: const EdgeInsets.only(
              top: 40,
              left: 20,
              right: 20,
              bottom: 20,
            ),
            decoration: const BoxDecoration(
              color: Color(0xFFF0F0FF), // 浅紫色背景
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFFBFA2FF),
                  blurRadius: 10,
                  spreadRadius: -5,
                ),
              ],
            ),
            child: Row(
              children: [
                GlassButton(
                  icon: Icons.arrow_back_ios_new_rounded,
                  onTap: () => Navigator.pop(context),
                ),
                const Expanded(
                  child: Center(
                    child: Text(
                      '隐私与安全',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF5A4C75),
                      ),
                    ),
                  ),
                ),
                // 右侧占位保持居中
                const SizedBox(width: 40),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 选项卡：修改/设置密码
          _buildSettingTile(
            context,
            title: '修改/设置密码',
            onTap: () {
              // 路由跳转到修改密码页面
              context.push("/${AppRouteNames.setPasswordPage}");
            },
          ),
        ],
      ),
    );
  }

  // 列表项
  Widget _buildSettingTile(
    BuildContext context, {
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFBFA2FF).withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF5A4C75),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: Color(0xFFBFA2FF),
            ),
          ],
        ),
      ),
    );
  }
}

class SetPasswordPage extends ConsumerStatefulWidget {
  const SetPasswordPage({Key? key}) : super(key: key);

  @override
  _SetPasswordPageState createState() => _SetPasswordPageState();
}

class _SetPasswordPageState extends ConsumerState<SetPasswordPage> {
  TextEditingController _autoCodeController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _isHidden = true;
  @override
  Widget build(BuildContext context) {
    ref.listen<String?>(
      loginViewModelProvider.select((state) => state.message),
      (previous, next) {
        if (next != null) {
          MySnackBar.show(context, next);
        }
      },
    );
    final loginViewModel = ref.watch(loginViewModelProvider.notifier);
    final _userState = ref.watch(userViewModelProvider);
    final _user = _userState.user;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          "设置密码",
          style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children:
            [
              Padding(
                padding: EdgeInsets.only(top: 50),
                child: TextField(
                  enabled: false,
                  style: TextStyle(color: Colors.grey),
                  decoration: InputDecoration(
                    hintText: '手机号：${_user?.phone}',
                    disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey[300]!), // 灰色边框
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    filled: true,
                    fillColor: Colors.grey[100],
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _autoCodeController,
                      decoration: InputDecoration(hintText: "请输入验证码"),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        loginViewModel.sendMsg();
                      },
                      child: Text("获取验证码"),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    hintText: "请输入新密码",
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isHidden ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _isHidden = !_isHidden;
                        });
                      },
                    ),
                  ),
                  obscureText: _isHidden,
                ),
              ),
              Text("已阅读并同意服务协议和隐私保护指引", style: TextStyle(color: Colors.grey)),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    ref
                        .read(userViewModelProvider.notifier)
                        .setPassword(
                          _autoCodeController.text,
                          _passwordController.text,
                        );
                    context.pop();
                  },
                  child: Text("确认设置"),
                ),
              ),
            ].map((child) {
              return Padding(
                padding: EdgeInsets.only(left: 30, right: 30, bottom: 30),
                child: child,
              );
            }).toList(),
      ),
    );
  }
}
