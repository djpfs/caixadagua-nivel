import 'dart:async';
import 'package:circle_wave_progress/circle_wave_progress.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Nível - Caixa d'agua",
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: "Nível - Caixa d'agua"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;
  final String defaultUrl = 'http://192.168.0.152/value';

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double progress = 50;
  Timer timer;
  final player = AudioPlayer();

  void getNivel() async {
    String url = widget.defaultUrl;

    try {
      Response response = await Dio().get(url);
      int statusCode = response.statusCode;
      print(response.data);
      if (statusCode == 200) {
        setState(() {
          this.progress = double.parse(response.data);
        });
      }
    } catch (e) {
      print('Erro na requisição');
    }
  }

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(Duration(seconds: 5), (Timer t) => getNivel());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  play() async {
    await player.setAsset('assets/audios/buzzer.mp3');
    player.play();
  }

  @override
  Widget build(BuildContext context) {
    //getNivel();
    if (progress == 100 || progress == 0) {
      print("100%!");
      play();
    }
    return Scaffold(
      backgroundColor: Colors.blue,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.settings),
        //     onPressed: getNivel,
        //   ),
        // ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleWaveProgress(
              size: 300,
              borderWidth: 10.0,
              backgroundColor: Colors.white,
              borderColor: Colors.white,
              waveColor: Colors.blueAccent,
              progress: progress,
            ),
            SizedBox(
              height: 10,
            ),
            Text('${progress.round()}%',
                style: TextStyle(
                    fontSize: 40,
                    color: Colors.white,
                    fontWeight: FontWeight.w900))
          ],
        ),
      ),
    );
  }
}
