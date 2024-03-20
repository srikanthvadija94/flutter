import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';


class PlaylistPage extends StatelessWidget {
  final String playlistUrl;

  PlaylistPage({required this.playlistUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Playlist Page'),
      ),
      body: WebView(
        initialUrl: playlistUrl,
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
