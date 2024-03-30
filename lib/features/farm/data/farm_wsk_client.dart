import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketManager {
  late WebSocketChannel _webSocketChannel;

  WebSocketManager() {
    _webSocketChannel =
        WebSocketChannel.connect(Uri.parse('ws://115.79.196.171:1234'));
  }

  Stream<dynamic> get stream => _webSocketChannel.stream;

  void send(dynamic data) {
    _webSocketChannel.sink.add(data);
  }

  void close() {
    _webSocketChannel.sink.close();
  }
}
