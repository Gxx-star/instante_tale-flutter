import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';

/// 自定义流式音频源：允许实时追加字节数据
class TtsStreamAudioSource extends StreamAudioSource {
  final StreamController<List<int>> _controller = StreamController<List<int>>();

  void addBytes(List<int> bytes) => _controller.add(bytes);

  void close() => _controller.close();

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    return StreamAudioResponse(
      sourceLength: null,
      // 流式长度未知
      contentLength: null,
      offset: start ?? 0,
      stream: _controller.stream,
      contentType: 'audio/mpeg', // 指定为 MP3 格式
    );
  }
}

class StreamAudioPlayerManager {
  static final StreamAudioPlayerManager instance = StreamAudioPlayerManager._();
  late double _duration;

  StreamAudioPlayerManager._() {
    _player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed ||
          state.processingState == ProcessingState.idle) {
        _updatePlayingState(false);
      } else if (state.playing) {
        _updatePlayingState(true);
      }
    });
    _player.positionStream.listen((position) {
      // 如果没有获取到有效时长，直接返回
      if (_duration <= 0) return;

      double currentSeconds = position.inMilliseconds / 1000.0;

      // 只要当前进度超过了后端返回的最后一个字的时间戳
      if (currentSeconds >= _duration) {
        // 如果当前还在播放状态，强制切回停止状态（停止 Rive 动画）
        if (isPlayingNotifier.value) {
          _updatePlayingState(false);
        }
      }
    });
  }

  // 是否正在播放
  final ValueNotifier<bool> isPlayingNotifier = ValueNotifier<bool>(false);

  void _updatePlayingState(bool playing) {
    if (isPlayingNotifier.value != playing) {
      isPlayingNotifier.value = playing;
    }
  }

  final AudioPlayer _player = AudioPlayer();
  CancelToken? _cancelToken;

  Future<void> streamPlayAudio(String text) async {
    _updatePlayingState(true);
    // 停止之前的播放和请求
    await stopPlay();
    // 初始化流式播放源
    final ttsSource = TtsStreamAudioSource();
    _cancelToken = CancelToken();
    try {
      // 开始播放（此时会等待流中注入数据）
      final playFuture = _player
          .setAudioSource(ttsSource)
          .then((_) => _player.play());
      // 发起网络请求
      final response = await Dio().post(
        "https://openspeech.bytedance.com/api/v3/tts/unidirectional",
        data: {
          "user": {"uid": "123123"},
          "req_params": {
            "text": text,
            "speaker": "zh_female_roumeinvyou_emo_v2_mars_bigtts",
            "audio_params": {
              "format": "mp3",
              "sample_rate": 24000,
              "enable_timestamp": true,
            },
          },
        },
        options: Options(
          responseType: ResponseType.stream,
          headers: {
            "X-Api-App-Id": "5043307004",
            "X-Api-Access-Key": "t3ZSy2DJMePzEnl4c0xXoK1_j-6SwCQf",
            "X-Api-Resource-Id": "seed-tts-1.0",
          },
        ),
        cancelToken: _cancelToken,
      );

      // 处理原始 HTTP 流，解析 JSON 并提取 Base64
      response.data!.stream
          .cast<List<int>>()
          .transform(utf8.decoder) // 字节转字符串
          .transform(const LineSplitter()) // 按行拆分 JSON 对象
          .listen(
            (line) {
              if (line.trim().isEmpty) return;
              try {
                final Map<String, dynamic> jsonResponse = jsonDecode(line);
                final String? base64Data = jsonResponse['data'];
                if (base64Data != null && base64Data.isNotEmpty) {
                  final Uint8List bytes = base64Decode(base64Data);
                  ttsSource.addBytes(bytes); // 喂数据给播放器
                }
                if (jsonResponse['sentence'] != null) {
                  var words = jsonResponse['sentence']['words'];
                  if (words.isNotEmpty) {
                    _duration = words.last['endTime']?.toDouble() ?? 0.0;
                  }
                  print(_duration.toString());
                }
                if (jsonResponse['code'] == 20000000 ||
                    jsonResponse['message'] == 'OK') {
                  ttsSource.close();
                }
              } catch (e) {
                print("解析分片失败: $e");
              }
            },
            onDone: () => ttsSource.close(),
            onError: (e) => ttsSource.close(),
          );
    } catch (e) {
      _updatePlayingState(false);
      ttsSource.close();
      rethrow;
    }
  }

  Future<void> stopPlay() async {
    _cancelToken?.cancel();
    await _player.stop();
    _updatePlayingState(false);
  }
}
