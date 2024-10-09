import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';

class MusicController extends GetxController {
  final OnAudioQuery audioQuery = OnAudioQuery();
  final AudioPlayer audioPlayer = AudioPlayer();

  RxList<SongModel> songs = <SongModel>[].obs;
  RxInt currentIndex = 0.obs;
  RxBool isPlaying = false.obs;
  RxBool isLooping = false.obs;
  RxBool isShuffling = false.obs;
  RxBool showBottomSheet = false.obs;

  Rx<Duration> currentPosition = Duration.zero.obs;
  Rx<Duration> totalDuration = Duration.zero.obs;

  @override
  void onInit() {
    super.onInit();
    fetchSongs();

    audioPlayer.onPlayerComplete.listen((event) => handleCompletion());

    audioPlayer.onDurationChanged.listen((Duration duration) {
      totalDuration.value = duration;
    });

    audioPlayer.onPositionChanged.listen((Duration position) {
      currentPosition.value = position;
    });
  }

  Future<void> fetchSongs() async {
    var fetchedSongs = await audioQuery.querySongs(
      sortType: null,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );
    songs.assignAll(fetchedSongs);
  }

  void playSong(int index) {
    currentIndex.value = index;
    audioPlayer.play(DeviceFileSource(songs[index].data));
    isPlaying.value = true;
    showBottomSheet.value = true;
  }

  void pauseSong() {
    audioPlayer.pause();
    isPlaying.value = false;
  }

  void resumeSong() {
    audioPlayer.resume();
    isPlaying.value = true;
  }

  void stopSong() {
    audioPlayer.stop();
    isPlaying.value = false;
    showBottomSheet.value = false;
  }

  void nextSong() {
    if (isShuffling.value) {
      currentIndex.value = getRandomIndex();
    } else {
      currentIndex.value = (currentIndex.value + 1) % songs.length;
    }
    playSong(currentIndex.value);
  }

  void previousSong() {
    currentIndex.value = (currentIndex.value - 1) < 0
        ? songs.length - 1
        : currentIndex.value - 1;
    playSong(currentIndex.value);
  }

  void toggleLoop() {
    isLooping.value = !isLooping.value;
  }

  void loopSong() {
    if (isLooping.value) {
      playSong(currentIndex.value);
    } else {
      nextSong();
    }
  }

  void toggleShuffle() {
    isShuffling.value = !isShuffling.value;
  }

  void handleCompletion() {
    loopSong();
  }

  int getRandomIndex() {
    int randomIndex;
    do {
      randomIndex = Random().nextInt(songs.length);
    } while (randomIndex == currentIndex.value);
    return randomIndex;
  }

  void seekTo(Duration position) {
    audioPlayer.seek(position);
  }
}
