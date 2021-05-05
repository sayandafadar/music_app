import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';
import 'package:soul/screens/quote_screen.dart';

class PlayerScreen extends StatefulWidget {
  final String songName, artistName, songUrl, imageUrl;

  PlayerScreen({this.songName, this.artistName, this.songUrl, this.imageUrl});

  @override
  _PlayerScreenState createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  final audioPlayer = AudioPlayer();
  IconData icon = Icons.play_arrow;
  bool playing = false;

  Duration totalDuration;
  Duration position;
  String audioState;

  void disposeAudio() {
    audioPlayer.dispose();
  }

  // AUDIOPLAYER START
  Future<void> audioSession() async {
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.music());
    // Activate the audio session before playing audio.
    if (await session.setActive(true)) {
      pauseAudio();
    } else {
      stopAudio();
    }
    session.interruptionEventStream.listen((event) {
      if (event.begin) {
        switch (event.type) {
          case AudioInterruptionType.duck:
            // Another app started playing audio and we should duck.
            break;
          case AudioInterruptionType.pause:
          case AudioInterruptionType.unknown:
            // Another app started playing audio and we should pause.
            break;
        }
      } else {
        switch (event.type) {
          case AudioInterruptionType.duck:
            // The interruption ended and we should unduck.
            break;
          case AudioInterruptionType.pause:
          // The interruption ended and we should resume.
          case AudioInterruptionType.unknown:
            // The interruption ended but we should not resume.
            break;
        }
      }
    });
  }

  void initAudio() async {
    audioPlayer.setLoopMode(LoopMode.off);

    await audioPlayer.setUrl(widget.songUrl);

    audioPlayer.durationStream.listen((updatedDuration) {
      totalDuration = updatedDuration;
    });

    audioPlayer.positionStream.listen((updatedPosition) {
      setState(() {
        position = updatedPosition;
      });
    });

    audioPlayer.playerStateStream.listen((playerState) {
      if (playerState.playing == true) {
        audioState = "Playing";
      }

      if (playerState.playing == false) {
        audioState = "Pause";
      }

      if (playerState.processingState == ProcessingState.loading) {
        audioState = "Loading";
      }

      if (playerState.processingState == ProcessingState.completed) {
        Get.to(QuoteScreen());
        audioState = "Stopped";
        audioPlayer.seek(Duration.zero);
        icon = Icons.play_arrow;
        playing = false;
        stopAudio();
      }
    });
  }

  void playAudio() async {
    await audioPlayer.play();
  }

  void pauseAudio() async {
    await audioPlayer.pause();
  }

  void seeking(Duration position) {
    audioPlayer.seek(position);
  }

  void shuffle() async {
    await audioPlayer.setShuffleModeEnabled(true);
  }

  void stopAudio() async {
    await audioPlayer.stop();
  }

  void skipToNext() async {
    await audioPlayer.seekToNext();
  }

  void disposeAuidoPlayer() async {
    await audioPlayer.dispose();
  }

  // AUDIOPLAYER END

  @override
  void initState() {
    initAudio();
    audioSession();
    super.initState();
  }

  // PLAYER SCREEN BUILDER STARTS

  @override
  Widget build(BuildContext context) {
    String timer() {
      dynamic countSec = position.inSeconds.remainder(60).toInt();
      dynamic countMin = position.inMinutes.remainder(60).toInt();
      if (countSec < 10) {
        countSec = "0$countSec";
      }
      if (countMin < 10) {
        countMin = "0$countMin";
      }
      return "$countMin:$countSec";
    }

    return ModalProgressHUD(
      inAsyncCall: totalDuration == null ? true : false,
      opacity: 0.2,
      color: Colors.white10,
      progressIndicator: Image.asset(
        "images/dhayan.gif",
        height: 100.0,
        width: 100.0,
      ),
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            color: Colors.black38,
            image: DecorationImage(
              image: NetworkImage(widget.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
          constraints: BoxConstraints.expand(),
          padding: EdgeInsets.symmetric(horizontal: 28.0),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: 220.0,
                ),
                SleekCircularSlider(
                  appearance: CircularSliderAppearance(
                    size: 280.0,
                    angleRange: 360.0,
                    customWidths: CustomSliderWidths(
                      progressBarWidth: 6,
                      trackWidth: 10,
                      shadowWidth: 0,
                    ),
                    customColors: CustomSliderColors(
                      trackColor: Colors.transparent,
                      progressBarColor: Colors.white,
                      dotColor: Colors.transparent,
                    ),
                    infoProperties: InfoProperties(
                      mainLabelStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 30.0,
                      ),
                    ),
                  ),
                  min: 0,
                  max: totalDuration == null
                      ? 0.0
                      : totalDuration.inSeconds.toDouble(),
                  initialValue:
                      position == null ? 0.0 : position.inSeconds.toDouble(),
                  innerWidget: (double value) {
                    return Center(
                      child: Text(
                        totalDuration == null ? "00:00" : timer(),
                        style: TextStyle(color: Colors.white, fontSize: 30.0),
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: 80.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.songName,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text(
                          widget.artistName,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 10.0,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          if (playing == false) {
                            icon = Icons.pause;
                            playing = true;
                            playAudio();
                          } else if (playing == true) {
                            icon = Icons.play_arrow;
                            playing = false;
                            pauseAudio();
                          }
                        });
                      },
                      icon: Icon(
                        icon,
                        color: Colors.white,
                        size: 45.0,
                      ),
                    ),
                  ],
                ),
                ProgressBar(
                  thumbColor: Colors.white,
                  thumbRadius: 10.0,
                  progressBarColor: Colors.white,
                  timeLabelTextStyle: TextStyle(
                    fontSize: 0.0,
                    color: Colors.white,
                  ),
                  baseBarColor: Colors.white10,
                  progress: position == null ? Duration.zero : position,
                  total: totalDuration == null ? Duration.zero : totalDuration,
                  onSeek: (duration) {
                    seeking(duration);
                  },
                ),
                SizedBox(
                  height: 40.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// PLAYER SCREEN BUILDER ENDS
