import 'dart:io';
import 'dart:convert';

class StompSocket {

  static var _nextId = 0;

  final String destination;
  final String hostname;
  final Function(Map<String, dynamic>) callback;

  WebSocket _socket;

  StompSocket(this.destination, this.callback, {this.hostname = "ws://localhost:8080/websocket"});

  Future<void> connect() async {
    _socket = await WebSocket.connect(hostname);
    _socket.listen(_updateReceived);

    _socket.add(_buildConnectString());
    _socket.add(_buildSubscribeString());
  }

  void disconnect() {
    _socket.add(_buildDisconnectString());
    // actually we should close the socket after we received the response from the server...
    // so this is not perfect...
    //_socket.close();
  }

  void _updateReceived(dynamic data) {
    final lines = data.toString().split('\n');
    if (lines.length != 0) {
      final command = lines[0];

      if (command == "RECEIPT") {
        // typically this message comes after we send the command in the disconnect() method
        _socket.close();
      } else if (command == "CONNECTED") {
        print('Connected successfully to $destination @ $hostname');
      } else if (command == "MESSAGE") {
        final indexOfBody = lines.indexWhere((line) => line.length == 0) + 1;

        // we dont want the last character, since it is weird.
        final bodyLine = lines[indexOfBody].substring(0, lines[indexOfBody].length - 1);

        Map<String, dynamic> json = jsonDecode(bodyLine);
        callback(json);
      }
    }
  }

  String _buildConnectString() {
    return 'CONNECT\naccept-version:1.2\nhost:$hostname\n\n\x00';
  }

  String _buildSubscribeString() {
    // we increase the nextId so that other listener don't choose the same for a subscription
    // since this could lead to strange behavior
    _nextId++;
    var id = _nextId;
    return 'SUBSCRIBE\nid:$id\ndestination:$destination\nack:client\n\n\x00';
  }

  String _buildDisconnectString() {
    return 'DISCONNECT\nreceipt:77\n\n\x00';
  }
}