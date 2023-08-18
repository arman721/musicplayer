import 'dart:developer';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:musicplayer/object.dart';
import 'package:musicplayer/play.dart';
import 'package:musicplayer/stateprovider.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  bool al = true;
  bool co = false;
  bool sheet = false;
  final _audioquery = OnAudioQuery();
  final _audioplayer = AudioPlayer();
  bool play = false;
  int a = 0;
  

  void initState() {
    super.initState();
    requestPermission();
  }

  playsong(String? data) {
    _audioplayer.play(DeviceFileSource(data!));
  }

  Future<void> requestPermission() async {
    Permission.audio.request();
    al = await Permission.audio.isGranted;
    if (al) {
      log("accepted");
    } else {
      await requestPermission();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<List<SongModel>>(
          future: _audioquery.querySongs(
            sortType: null,
            orderType: OrderType.ASC_OR_SMALLER,
            uriType: UriType.EXTERNAL,
            ignoreCase: true,
          ),
          builder: (context, item) {
            if (item.data == null) {
              print("null");
              return Container(
                  child: Center(child: CircularProgressIndicator()));
            }
            if (item.data!.isEmpty) {
              print("empty");
              return Container(child: (Text("No Songs Found")));
            } else {
              return Column(
                children: [
                  Expanded(
                    flex: 8,
                    child: Container( decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                  Color.fromARGB(128, 46, 4, 118),
                  Color.fromARGB(255, 52, 6, 132),
                  Color.fromARGB(255, 32, 14, 65)
                ])),
                      child: ListView.builder(
                        itemCount: item.data!.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              ref.read(indexprovider.notifier).update(
                                (state) {
                                  return index;
                                },
                              );
                              setState(() {
                                play = true;
                                sheet = true;
                                
                              });
                    
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          PlayMusic(
                                            item: item.data!,
                                            index: ref.watch(indexprovider),
                                            audioPlayer: _audioplayer,
                                          )));
                              playsong(item.data![ref.watch(indexprovider)].data);
                            },
                            child: ListTile(textColor: Colors.white,
                            leading: Container(width: 50,
                              child: Image.asset("assets/images/music.jpg")),
                              title: Text(item.data![index].displayNameWOExt),
                              subtitle: Text("${item.data![index].album}"),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  sheet
                      ? InkWell(onTap:()=>Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          PlayMusic(
                                            item: item.data!,
                                            index: ref.watch(indexprovider),
                                            audioPlayer: _audioplayer,
                      ))),
                        child: Expanded(
                            flex: 1,
                            child: Container(
                              color: Color.fromARGB(255, 86, 51, 146),
                              child: Row(
                                children: [
                                  Expanded(
                                      flex: 2,
                                      child: Image.asset(
                                        "assets/images/music.jpg",
                                        fit: BoxFit.fill,
                                      )),
                                  Expanded(
                                    flex: 6,
                                    child: ListTile(
                                      textColor: Colors.white,
                                      title: Text(item.data![ref.watch(indexprovider)].title),
                                      subtitle: Text("${item.data![ref.watch(indexprovider)].album}"),
                                    ),
                                  ),
                                  play
                                      ? Expanded(
                                          flex: 1,
                                          child: IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  play = !play;
                                                });
                                                _audioplayer.pause();
                                              },
                                              icon: Icon(
                                                Icons.pause,
                                                color: Colors.white,
                                                size: 35,
                                              )),
                                        )
                                      : Expanded(
                                          flex: 1,
                                          child: IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  play = !play;
                                                });
                                                _audioplayer.resume();
                                              },
                                              icon: Icon(
                                                Icons.play_arrow,
                                                color: Colors.white,
                                                size: 35,
                                              )),
                                        ),
                                  Expanded(
                                    flex: 1,
                                    child: IconButton(
                                        onPressed: () {
                                          _audioplayer.stop();
                                          setState(() {
                                            sheet = false;
                                          });
                                        },
                                        icon: Icon(
                                          Icons.cancel_outlined,
                                          color: Colors.white,
                                          size: 35,
                                        )),
                                  )
                                ],
                              ),
                            )),
                      )
                      : Expanded(
                          flex: 0,
                          child: Container(
                            color: Colors.amber,
                          ))
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
