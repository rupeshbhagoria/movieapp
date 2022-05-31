import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../models/movie.dart';
import '../provider/movie_provider.dart';



class DetailPage extends StatelessWidget {
  final Movie movie;
  DetailPage(this.movie);



  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
        builder: (context, ori) {
          return WillPopScope(
            onWillPop: () async {
              if(ori == Orientation.portrait){
                return true;
              }else{
                SystemChrome.setPreferredOrientations(
                    [
                      DeviceOrientation.portraitUp,
                      DeviceOrientation.portraitDown,
                    ]
                );
                return false;
              }

            },
            child: Scaffold(
                resizeToAvoidBottomInset: false,
                body: SafeArea(
                  child: Consumer(
                      builder: (context, ref, child) {
                        final videoData = ref.watch(videoProvider(movie.id));
                        return videoData.when(
                            data: (data) {
                              return OrientationBuilder(
                                  builder: (context, ori) {
                                    if (ori == Orientation.landscape) {
                                      return YoutubePlayer(
                                        progressIndicatorColor: Colors.red,
                                        aspectRatio: 16 / 9,
                                        controller: YoutubePlayerController(
                                          initialVideoId: data,
                                          flags: YoutubePlayerFlags(
                                            autoPlay: true,
                                          ),
                                        ),
                                        showVideoProgressIndicator: true,
                                      );
                                    } else {
                                      return ListView(
                                        children: [
                                          YoutubePlayer(
                                            progressIndicatorColor: Colors.red,
                                            aspectRatio: 16 / 9,
                                            controller: YoutubePlayerController(
                                              initialVideoId: data,
                                              flags: YoutubePlayerFlags(
                                                autoPlay: true,
                                              ),
                                            ),
                                            showVideoProgressIndicator: true,

                                          )
                                        ],
                                      );
                                    }
                                  }
                              );
                            },
                            error: (err, stack) => Text('$err'),
                            loading: () =>
                                Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.purple,
                                  ),
                                )
                        );
                      }
                  ),
                )
            ),
          );
        }
    );
  }


  YoutubePlayerController _cont(String? id) {
    return  YoutubePlayerController(
      initialVideoId: id!,
      flags: YoutubePlayerFlags(
        autoPlay: false,
      ),
    );
  }
}