import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musicplayer/MusicController.dart';
import 'package:musicplayer/play.dart';
import 'package:on_audio_query/on_audio_query.dart';

class BottomMusicPlayer extends StatelessWidget {
  final MusicController musicController = Get.put(MusicController());

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(() => PlayMusic());
      },
      child: Container(
        color: const Color.fromARGB(255, 86, 51, 146),
        child: Row(
          children: [
            Obx(() {
              return Expanded(
                flex: 2,
                child: QueryArtworkWidget(
                  id: musicController
                      .songs[musicController.currentIndex.value].id,
                  type: ArtworkType.AUDIO,
                ),
              );
            }),
            Obx(() {
              return Expanded(
                flex: 6,
                child: ListTile(
                  textColor: Colors.white,
                  title: Text(
                    musicController
                        .songs[musicController.currentIndex.value].title,
                  ),
                  subtitle: Text(
                    "${musicController.songs[musicController.currentIndex.value].album}",
                  ),
                ),
              );
            }),
            Obx(() {
              return musicController.isPlaying.value
                  ? IconButton(
                      onPressed: musicController.pauseSong,
                      icon: const Icon(
                        Icons.pause,
                        color: Colors.white,
                        size: 35,
                      ),
                    )
                  : IconButton(
                      onPressed: musicController.resumeSong,
                      icon: const Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 35,
                      ),
                    );
            }),
            IconButton(
              onPressed: musicController.stopSong,
              icon: const Icon(
                Icons.cancel_outlined,
                color: Colors.white,
                size: 35,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
