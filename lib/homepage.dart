import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:musicplayer/ButtomMusicBar.dart';
import 'package:musicplayer/MusicController.dart';
import 'package:musicplayer/play.dart';
import 'package:on_audio_query/on_audio_query.dart';

class HomePage extends StatelessWidget {
  final MusicController musicController = Get.put(MusicController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Obx(() {
          if (musicController.songs.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          return Column(
            children: [
              Expanded(
                flex: 15,
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color.fromARGB(128, 46, 4, 118),
                        Color.fromARGB(255, 52, 6, 132),
                        Color.fromARGB(255, 32, 14, 65),
                      ],
                    ),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          alignment: Alignment.topLeft,
                          child: const Text(
                            "Play Your Favourite Song",
                            style: TextStyle(
                                color: Color.fromARGB(222, 17, 17, 17),
                                fontSize: 25),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 25,
                        child: ListView.builder(
                          itemCount: musicController.songs.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                musicController.playSong(index);
                                Get.to(() => PlayMusic());
                              },
                              child: ListTile(
                                textColor: Colors.white,
                                leading: SizedBox(
                                  width: 50,
                                  child: QueryArtworkWidget(
                                    id: musicController.songs[index].id,
                                    type: ArtworkType.AUDIO,
                                  ),
                                ),
                                title: Text(
                                  musicController.songs[index].displayNameWOExt,
                                ),
                                subtitle: Text(
                                  "${musicController.songs[index].album}",
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Obx(() => musicController.showBottomSheet.value
                  ? BottomMusicPlayer()
                  : const SizedBox.shrink()),
            ],
          );
        }),
      ),
    );
  }
}
