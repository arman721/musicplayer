import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musicplayer/MusicController.dart';
import 'package:on_audio_query/on_audio_query.dart';
// Import your controller

class PlayMusic extends StatelessWidget {
  final MusicController musicController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(148, 87, 3, 233),
                Color.fromARGB(255, 52, 6, 132),
                Color.fromARGB(255, 32, 14, 65),
              ],
            ),
          ),
          child: Obx(() {
            return Column(
              children: [
                Expanded(
                  flex: 9,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                          blurRadius: 30,
                          color: Color.fromARGB(255, 1, 44, 79),
                        ),
                      ]),
                      child: QueryArtworkWidget(
                        id: musicController
                            .songs[musicController.currentIndex.value].id,
                        type: ArtworkType.AUDIO,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: ListTile(
                      minVerticalPadding: 10,
                      title: Text(
                        musicController
                            .songs[musicController.currentIndex.value]
                            .displayNameWOExt,
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      subtitle: Text(
                        "${musicController.songs[musicController.currentIndex.value].album}",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Obx(
                    () => Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Slider(
                          value: musicController.currentPosition.value.inSeconds
                              .toDouble(),
                          min: 0.0,
                          max: musicController.totalDuration.value.inSeconds
                              .toDouble(),
                          onChanged: (value) {
                            musicController
                                .seekTo(Duration(seconds: value.toInt()));
                          },
                          activeColor: Colors.white,
                          inactiveColor: Colors.grey,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                musicController.currentPosition.value
                                    .toString()
                                    .split('.')
                                    .first,
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                musicController.totalDuration.value
                                    .toString()
                                    .split('.')
                                    .first,
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      musicController.isLooping.value
                          ? IconButton(
                              onPressed: musicController.toggleLoop,
                              icon: Icon(
                                Icons.loop,
                                color: Colors.white,
                                size: 35,
                              ),
                            )
                          : IconButton(
                              icon: Icon(Icons.loop),
                              onPressed: musicController.toggleLoop,
                              color: Colors.grey,
                            ),
                      IconButton(
                        onPressed: musicController.previousSong,
                        icon: Icon(Icons.skip_previous),
                        color: Colors.white,
                        iconSize: 50,
                      ),
                      Obx(() {
                        return musicController.isPlaying.value
                            ? IconButton(
                                onPressed: musicController.pauseSong,
                                icon: Icon(
                                  Icons.pause_circle,
                                  color: Colors.white,
                                  size: 50,
                                ),
                              )
                            : IconButton(
                                onPressed: musicController.resumeSong,
                                icon: Icon(
                                  Icons.play_circle,
                                  color: Colors.white,
                                  size: 50,
                                ),
                              );
                      }),
                      IconButton(
                        onPressed: musicController.nextSong,
                        icon: Icon(Icons.skip_next),
                        color: Colors.white,
                        iconSize: 50,
                      ),
                      IconButton(
                        onPressed: musicController.toggleShuffle,
                        icon: Icon(
                          Icons.shuffle,
                          color: musicController.isShuffling.value
                              ? Colors.white
                              : Colors.grey,
                          size: 35,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
