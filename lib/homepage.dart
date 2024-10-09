import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:musicplayer/play.dart';
import 'package:musicplayer/stateprovider.dart';
import 'package:on_audio_query/on_audio_query.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  bool co = false;

  final _audioquery = OnAudioQuery();
  final _audioplayer = AudioPlayer();

  int a = 0;

  playsong(String? data) {
    _audioplayer.play(DeviceFileSource(data!));
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
                  child: const Center(child: CircularProgressIndicator()));
            }
            if (item.data!.isEmpty) {
              print("empty");
              return Container(child: (const Text("No Songs Found")));
            } else {
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
                            Color.fromARGB(255, 32, 14, 65)
                          ])),
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
                              )),
                          Expanded(
                            flex: 2,
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 30,
                              decoration: const BoxDecoration(
                                  color: Color.fromARGB(165, 158, 158, 158),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50))),
                              // height: MediaQuery.of(context).size.height,
                              child: Row(
                                children: [
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Container(child: const Icon(Icons.search)),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const Text("Search "),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 25,
                            child: Container(
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

                                      ref
                                          .read(playprovider.notifier)
                                          .update((state) => true);
                                      ref
                                          .read(sheetprovider.notifier)
                                          .update((state) => true);

                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (BuildContext context) =>
                                                  PlayMusic(
                                                    item: item.data!,
                                                    index: ref
                                                        .watch(indexprovider),
                                                    audioPlayer: _audioplayer,
                                                  )));
                                      playsong(item
                                          .data![ref.watch(indexprovider)]
                                          .data);
                                    },
                                    child: ListTile(
                                      textColor: Colors.white,
                                      leading: SizedBox(
                                          width: 50,
                                          child: QueryArtworkWidget(
                                              id: item.data![index].id,
                                              type: ArtworkType.AUDIO)),
                                      title: Text(
                                          item.data![index].displayNameWOExt),
                                      subtitle:
                                          Text("${item.data![index].album}"),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ref.watch(sheetprovider)
                      ? InkWell(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) => PlayMusic(
                                        item: item.data!,
                                        index: ref.watch(indexprovider),
                                        audioPlayer: _audioplayer,
                                      ))),
                          child: Container(
                            color: const Color.fromARGB(255, 86, 51, 146),
                            child: Row(
                              children: [
                                Expanded(
                                    flex: 2,
                                    child: QueryArtworkWidget(
                                        id: item
                                            .data![ref.watch(indexprovider)].id,
                                        type: ArtworkType.AUDIO)),
                                Expanded(
                                  flex: 6,
                                  child: ListTile(
                                    textColor: Colors.white,
                                    title: Text(item
                                        .data![ref.watch(indexprovider)].title),
                                    subtitle: Text(
                                        "${item.data![ref.watch(indexprovider)].album}"),
                                  ),
                                ),
                                ref.watch(playprovider)
                                    ? Expanded(
                                        flex: 1,
                                        child: IconButton(
                                            onPressed: () {
                                              ref
                                                  .read(playprovider.notifier)
                                                  .update((state) => !state);
                                              _audioplayer.pause();
                                            },
                                            icon: const Icon(
                                              Icons.pause,
                                              color: Colors.white,
                                              size: 35,
                                            )),
                                      )
                                    : Expanded(
                                        flex: 1,
                                        child: IconButton(
                                            onPressed: () {
                                              ref
                                                  .read(playprovider.notifier)
                                                  .update((state) => !state);

                                              _audioplayer.resume();
                                            },
                                            icon: const Icon(
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
                                        ref
                                            .read(sheetprovider.notifier)
                                            .update((state) => false);
                                      },
                                      icon: const Icon(
                                        Icons.cancel_outlined,
                                        color: Colors.white,
                                        size: 35,
                                      )),
                                )
                              ],
                            ),
                          ),
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
