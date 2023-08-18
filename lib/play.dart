import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:musicplayer/stateprovider.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlayMusic extends ConsumerStatefulWidget {
  const PlayMusic(
      {super.key,
      required this.item,
      required this.index,
      required this.audioPlayer});
  final List<SongModel> item;
  final int index;
  final AudioPlayer audioPlayer;
  @override
  ConsumerState<PlayMusic> createState() => _PlayMusicState();
}

class _PlayMusicState extends ConsumerState<PlayMusic> {
  @override
  void initState() {
    // TODO: implement initState

    widget.audioPlayer.onPlayerComplete.listen((event) {
      return looop();
    });
  }

  @override
  bool play = true;
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Expanded(
        flex: 5,
        child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                  Color.fromARGB(148, 87, 3, 233),
                  Color.fromARGB(255, 52, 6, 132),
                  Color.fromARGB(255, 32, 14, 65)
                ])),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                            blurRadius: 30,
                            color: Color.fromARGB(255, 1, 44, 79)),
                      ]),
                      height: 450,
                      child: Image.asset(
                        "assets/images/music.jpg",
                        fit: BoxFit.fill,
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Expanded(
                      flex: 2,
                      child: ListTile(
                        minVerticalPadding: 10,
                        title: Text(
                          widget
                              .item[ref.watch(indexprovider)].displayNameWOExt,
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        subtitle: Text(
                          "${widget.item[ref.watch(indexprovider)].album}",
                          style: TextStyle(color: Colors.white),
                        ),
                      )),
                ),
                Expanded(flex: 2, child: Container()),
                Expanded(
                    flex: 3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ref.watch(loopprovider)
                            ? IconButton(
                                onPressed: () {
                                  setState(() {
                                    ref.read(loopprovider.notifier).update(
                                          (state) => false,
                                        );
                                  });
                                },
                                icon: Icon(
                                  Icons.loop,
                                  color: Colors.white,
                                  size: 35,
                                ))
                            : IconButton(
                                icon: Icon(Icons.abc),
                                onPressed: () {
                                  setState(() {
                                    ref.read(loopprovider.notifier).update(
                                          (state) => true,
                                        );
                                  });
                                },
                              ),
                        IconButton(
                          onPressed: () {
                            ref.read(indexprovider.notifier).state--;
                            if (ref.read(indexprovider) == -1) {
                              ref
                                  .read(indexprovider.notifier)
                                  .update((state) => widget.item.length - 1);
                            }
                            widget.audioPlayer.play(DeviceFileSource(
                                widget.item[ref.watch(indexprovider)].data));
                          },
                          icon: Icon(Icons.skip_previous),
                          color: Colors.white,
                          iconSize: 50,
                        ),
                        play
                            ? IconButton(
                                onPressed: () {
                                  setState(() {
                                    play = !play;
                                  });
                                  widget.audioPlayer.pause();
                                },
                                icon: Icon(
                                  Icons.pause_circle,
                                  color: Colors.white,
                                  size: 50,
                                ))
                            : IconButton(
                                onPressed: () {
                                  setState(() {
                                    play = !play;
                                  });
                                  widget.audioPlayer.resume();
                                },
                                icon: Icon(
                                  Icons.play_circle,
                                  color: Colors.white,
                                  size: 50,
                                )),
                        IconButton(
                            onPressed: () {
                              ref.read(indexprovider.notifier).state++;
                              if (ref.watch(indexprovider) >=
                                  widget.item.length) {
                                ref
                                    .read(indexprovider.notifier)
                                    .update((state) => 0);
                              }
                              widget.audioPlayer.play(DeviceFileSource(
                                  widget.item[ref.watch(indexprovider)].data));
                            },
                            icon: Icon(
                              Icons.skip_next,
                              color: Colors.white,
                              size: 50,
                            )),
                      ],
                    ))
              ],
            )),
      )),
    );
  }

  void looop() {
    ref.read(loopprovider) ? ref.read(indexprovider.notifier).state++ : null;
    widget.audioPlayer
        .play(DeviceFileSource(widget.item[ref.watch(indexprovider)].data));
  }
}
