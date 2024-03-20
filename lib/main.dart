import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test app',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _key = '';
  TextEditingController _inputController = TextEditingController();
  bool _loading = false;
  final Dio _dio = Dio();

  @override
  void initState() {
    super.initState();
    loadJSON();
  }

  void loadJSON() async {
    try {
      final response = await _dio.get('https://app.rinx.com/key_generate/');
      if (response.statusCode == 200) {
        final data = response.data;
        setState(() {
          _key = data['key']; // Assuming your JSON key field is named 'key'
        });
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> openUrl() async {
    setState(() {
      _loading = true;
    });

    var code = _inputController.text;
    var url = "https://app.rinx.com/play_playlist/$code/";

    try {
      await launch(url);
    } catch (e) {
      _showErrorDialog('Could not launch $url');
    }

    setState(() {
      _loading = false;
    });
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test app'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'PAIR KEY :',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 15),
            Text(
              _key,
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _inputController,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: 'Enter your code here',
                contentPadding: EdgeInsets.all(10.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loading ? null : openUrl,
              child: Text(
                'Pair',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}