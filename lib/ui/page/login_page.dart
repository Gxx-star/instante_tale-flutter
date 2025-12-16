import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:instant_tale/app_globals.dart';
import 'package:instant_tale/features/login/login_viewmodel.dart';
import 'package:instant_tale/ui/component/my_snackbar.dart';
import '../../features/login/login_provider.dart';
import '../../features/login/login_state.dart';
import '../../features/user/user_provider.dart';
import '../../main.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  bool _isHidden = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final loginState = ref.watch(loginViewModelProvider);
    final loginViewModel = ref.read(loginViewModelProvider.notifier);
    final userViewModel = ref.watch(userViewModelProvider.notifier);
    AppGlobals().listenAndShowSnackBar(
      ref: ref,
      context: context,
      provider: loginViewModelProvider,
    );
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(color: Color(0xFFFFF0F3)),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children:
          [
            Padding(padding: EdgeInsets.only(top: 100.h)),
            Image(
              image: AssetImage('assets/images/login_flag.png'),
              height: 200.w,
              width: 200.w,
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
                SizedBox(width: 40.w),
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
                  child: _buildSmsForm(
                    context,
                    loginViewModel,
                    loginState,
                    ref,
                  ),
                ),
              ],
            ),
            Spacer(),
          ].map((child) {
            if (child is Spacer) {
              return child;
            }
            return Padding(
              padding: EdgeInsets.only(
                left: 30.w,
                right: 30.w,
                bottom: 10.h,
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
          child: Padding(padding: EdgeInsets.only(top: 10.h), child: Text("密码")),
        ),
        TextField(
          decoration: InputDecoration(
            hintText: "请输入密码",
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
          onChanged: (value) {
            loginViewModel.updatePassword(value);
          },
          obscureText: _isHidden,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.only(top: 10.h, right: 10.w),
            child: GestureDetector(
              onTap: () {
                context.push('/${AppRouteNames.forgetPassword}');
              },
              child: Text(
                "忘记密码",
                style: TextStyle(
                  color: Color(0xFFFF00AA),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  decoration: TextDecoration.none, // 不要下划线
                ),
              ),
            ),
          ),
        ),
        Container(
          width: 200.w,
          child: ElevatedButton(
            onPressed: () {
              loginViewModel.login().then((_) {
                if (AppGlobals().isLoggedIn) {
                  context.go('/${AppRouteNames.main}');
                }
              });
            },
            child: Text("登录"),
          ),
        ),
      ],
    );
  }

  Widget _buildSmsForm(
      BuildContext context,
      LoginViewModel loginViewModel,
      LoginState loginState,
      WidgetRef ref,
      ) {
    final smsTimerProvider = StateProvider.autoDispose<int>((ref) {
      return 0;
    });
    final secondsRemaining = ref.watch(smsTimerServiceProvider);
    final timerService = ref.read(smsTimerServiceProvider.notifier);
    final bool isTimerActive = secondsRemaining > 0;
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
          child: Padding(padding: EdgeInsets.only(top: 10.h), child: Text("验证码")),
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
              padding: EdgeInsets.only(left: 20.w),
              child: ElevatedButton(
                onPressed: isTimerActive
                    ? null
                    : () {
                  loginViewModel.sendMsg().then((success) {
                    if (success) {
                      timerService.startTimer();
                    }
                  });
                },
                child: Text(
                  isTimerActive ? '重新发送($secondsRemaining)' : '获取验证码',
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 30.h),
        Container(
          width: 200.w,
          child: ElevatedButton(
            onPressed: () {
              loginViewModel.login().then((_) {
                if (AppGlobals().isLoggedIn) {
                  context.go('/${AppRouteNames.main}');
                }
              });
            },
            child: Text("登录"),
          ),
        ),
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
              fontSize: 18.sp,
              color: isActive ? Colors.blue : Colors.grey,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          if (isActive)
            Container(
              width: 40.w,
              height: 3.h,
              margin: EdgeInsets.only(top: 5.h),
              color: Colors.blue,
            ),
        ],
      ),
    );
  }
}

// 管理计时器
class TimerService extends StateNotifier<int> {
  TimerService(this.ref) : super(0); // 初始状态为 0 秒

  final Ref ref;
  Timer? _timer;
  static const int _maxSeconds = 60;

  bool get isRunning => state > 0;

  void startTimer() {
    if (isRunning) return;
    _timer?.cancel();
    state = _maxSeconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state > 0) {
        state = state - 1; // 递减秒数
      } else {
        timer.cancel();
        _timer = null;
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

// 关联到 StateNotifierProvider
final smsTimerServiceProvider =
StateNotifierProvider.autoDispose<TimerService, int>((ref) {
  final service = TimerService(ref);
  return service;
});
