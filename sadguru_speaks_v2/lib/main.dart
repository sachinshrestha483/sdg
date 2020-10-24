import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

///import 'package:just_audio/just_audio.dart';

import 'Models/podcast.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AudioPlayer audioPlayer = AudioPlayer();
  bool play = false;
  bool loadingAudio = false;
  String currentUrl = "";
  void mPlayer(String url) async {
    /*
    print("jjjj->");
    print(url);
    // await audioPlayer.setUrl(url); //
    audioPlayer.play(url, isLocal: false);
*/
    if (currentUrl == url && play == true) {
      audioPlayer.pause();
      setState(() {
        play = false;
      });
      play = false;
    } else if (currentUrl == url && play == false) {
      audioPlayer.play(url);
      setState(() {
        play = true;
      });
      play = true;
    } else if (currentUrl != url && play == false) {
      setState(() {
        loadingAudio = true;
      });
      loadingAudio = true;
      await audioPlayer.setUrl(url);
      currentUrl = url;
      audioPlayer.play(url);
      setState(() {
        loadingAudio = false;
      });
      loadingAudio = false;
      setState(() {
        play = true;
        currentUrl = url;
      });
      play = true;
    } else if (currentUrl != url && play == true) {
      audioPlayer.pause();
      currentUrl = url;
      setState(() {
        loadingAudio = true;
      });
      loadingAudio = true;
      await audioPlayer.setUrl(url);
      audioPlayer.play(url);
      setState(() {
        loadingAudio = false;
      });
      loadingAudio = false;
      setState(() {
        currentUrl = url;
      });
    }
  }

  /*final player = AudioPlayer();
  bool play = false;
  String currentUrl = "";
  void setSong(String url) async {
    print(url);

    if (currentUrl == url && play == true) {
      player.pause();
      play = false;
    } else if (currentUrl == url && play == false) {
      player.play();
      play = true;
    } else if (currentUrl != url && play == false) {
      await player.setUrl(url);
      currentUrl = url;
      player.play();
      play = true;
    } else if (currentUrl != url && play == true) {
      player.pause();
      currentUrl = url;
      await player.setUrl(url);
      player.play();
    }
  }
*/
  List<Podcast> listModel = [];
  var loading = false;

  Future<Null> getData() async {
    setState(() {
      loading = true;
    });

    final responseData =
        await http.get("https://sadgurupodcast.netlify.app/podcasts.json");

    if (responseData.statusCode == 200) {
      final data = jsonDecode(responseData.body);
      print(data);
      setState(() {
        for (Map i in data) {
          listModel.add(Podcast.fromJson(i));
        }
        loading = false;
      });
      for (int i = 0; i < listModel.length; i++) {
        print(listModel[i]);
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(accentColor: Colors.deepOrangeAccent),
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            "Sadguru Speaks",
            style: TextStyle(
              fontFamily: 'Gd',
              fontSize: 24,
              letterSpacing: 0,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.brown,
        ),
        body: SafeArea(
          child: (loading)
              ? Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 5,
                  ),
                )
              : ListView.separated(
                  separatorBuilder: (context, index) => Divider(
                        color: Colors.black,
                      ),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  padding: const EdgeInsets.fromLTRB(5, 10, 5, 10),
                  itemCount: listModel.length,
                  itemBuilder: (BuildContext context, int index) {
                    return MaterialButton(
                        onPressed: () {
                          // setSong(listModel[index].url);
                          print('button pressed ${listModel[index].url}');
                          mPlayer(listModel[index].url);
                        },
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(30.0),
                              child: Image.network(
                                listModel[index].photo,
                                height: 250.0,
                                //  width: 150.0,
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                SizedBox(
                                  height: 150,
                                ),
                                (play == true &&
                                        currentUrl == listModel[index].url)
                                    ? Icon(
                                        Icons.pause,
                                        size: 40,
                                        color: Colors.white70,
                                      )
                                    : (loadingAudio &&
                                            currentUrl == listModel[index].url)
                                        ? CircularProgressIndicator()
                                        : Icon(
                                            Icons.play_arrow_sharp,
                                            size: 40,
                                            color: Colors.white70,
                                          ),
                              ],
                            )
                          ],
                        ));
                  }),
        ),
      ),
    );
  }
}
