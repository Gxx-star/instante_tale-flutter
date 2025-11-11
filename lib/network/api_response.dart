class ApiResponse<T> {
  final int code;
  final String msg;
  final T? data;

  ApiResponse({required this.code, required this.msg, this.data});

  factory ApiResponse.fromJson(Map<String, dynamic> json, T Function(dynamic) convert) {
    return ApiResponse(
      code: json['code'],
      msg: json['msg'],
      data: json['data'] == null ? null : convert(json['data']),
    );
  }
}
