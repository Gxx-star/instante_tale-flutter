class CharacterState {
  final bool isLoading;
  final String? message;
  CharacterState({
    this.isLoading = false,
    this.message,
  });

  CharacterState copyWith({
    bool? isLoading,
    String? message,
  }) {
    return CharacterState(
      isLoading: isLoading ?? this.isLoading,
      message: message,
    );
  }
}