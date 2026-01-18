import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  IO.Socket? socket;

  void connect({
    required String baseUrl,
    required String token,
    required Function onConnected,
  }) {
    socket?.disconnect();

    socket = IO.io(
      baseUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .setPath('/socket.io/')
          .setAuth({
            "token": token, // 🔥 WAJIB
          })
          .enableForceNew()
          .enableReconnection()
          .build(),
    );

    socket!.onConnect((_) {
      print("SOCKET CONNECTED");
      onConnected();
    });

    socket!.onDisconnect((_) {
      print("SOCKET DISCONNECTED");
    });

    socket!.onConnectError((e) {
      print("SOCKET CONNECT ERROR: $e");
    });

    socket!.onError((e) {
      print("SOCKET ERROR: $e");
    });
  }

  void joinChat({required String token, required int pesananId}) {
    print("EMIT JOIN_CHAT");
    socket?.emit("join_chat", {"token": token, "pesanan_id": pesananId});
  }

  void sendMessage({
    required String token,
    required int pesananId,
    required String message,
  }) {
    print("EMIT SEND_MESSAGE");
    socket?.emit("send_message", {
      "token": token,
      "pesanan_id": pesananId,
      "message": message,
    });
  }

  void onReceiveMessage(Function(dynamic) callback) {
    socket?.off("receive_message");
    socket?.on("receive_message", (data) {
      print("RECEIVE MESSAGE: $data");
      callback(data);
    });
  }

  void disconnect() {
    socket?.disconnect();
    socket = null;
  }

  void onNotifikasi(Function(dynamic) callback) {
    socket?.on("notifikasi", (data) {
      callback(data);
    });
  }
}