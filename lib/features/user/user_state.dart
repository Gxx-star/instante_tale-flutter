import 'package:instant_tale/database/models/user.dart';

class UserState{
  final bool isLoading;
  final String? message;
  final User? user;
  UserState({
    this.isLoading = false,
    this.message,
    this.user,
  });
  UserState copyWith({
    bool? isLoading,
    String? message,
    User? user
  }){
    return UserState(
      isLoading: isLoading ?? this.isLoading,
      message: message,
      user: user ?? this.user
    );
  }
}