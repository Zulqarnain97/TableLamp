

import 'dart:math';

import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sizer/sizer.dart';

class RelaxScreen extends StatefulWidget {
  @override
  _RelaxScreenState createState() => _RelaxScreenState();
}

class _RelaxScreenState extends State<RelaxScreen> {
  AudioPlayer _player;
  ConcatenatingAudioSource _playlist = ConcatenatingAudioSource(children: [
    // ClippingAudioSource(
    //   start: Duration(seconds: 60),
    //   end: Duration(seconds: 90),
    //   child: AudioSource.uri(Uri.parse(
    //       "https://s3.amazonaws.com/scifri-episodes/scifri20181123-episode.mp3")),
    //   tag: AudioMetadata(
    //     album: "Science Friday",
    //     title: "A Salute To Head-Scratching Science (30 seconds)",
    //     artwork:
    //     "https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg",
    //   ),
    // ),
    AudioSource.uri(
      Uri.parse(
          "https://www.mboxdrive.com/Nature%20Sounds%20Without%20Music%20-%2010-Minutes%20of%20a%20Mountain%20Stream.mp3"),
      tag: AudioMetadata(
        title: "Nature Sounds",
        artwork:
            "https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg",
      ),
    ),
    AudioSource.uri(
      Uri.parse(
          "https://www.mboxdrive.com/Rainforest%20Sounds%20of%20Nature%20Relaxing%20-%2010Min.mp3"),
      tag: AudioMetadata(
        title: "Nature Relaxing Sounds",
        artwork:
            "https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg",
      ),
    ),
    AudioSource.uri(
      Uri.parse(
          "https://www.mboxdrive.com/Jungle%20Sound%20Meditation%20In%20The%20Jungle%20For%20Ten%20Minute%20Self%20Meditation.mp3"),
      tag: AudioMetadata(
        // album: "Public Domain",
        title: "Jungle Sounds",
        artwork:
            "https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg",
      ),
    ),
    AudioSource.uri(
      Uri.parse(
          "https://www.mboxdrive.com/Moon%20Beach%20[10%20Min.%20Nature%20Sounds]%20Ten-minute%20long%20Ocean%20Waves%20for%20Meditation,%20Relaxation%20_%20059.mp3"),
      tag: AudioMetadata(
        // album: "Public Domain",
        title: "Ocean Waves",
        artwork:
            "https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg",
      ),
    ),
    AudioSource.uri(
      Uri.parse(
          "https://www.mboxdrive.com/10%20Minutes%20of%20relaxing%20rain%20sounds%20for%20Meditation.%20Ideal%20for%20Beginners.mp3"),
      tag: AudioMetadata(
        // album: "Public Domain",
        title: "Rain Music",
        artwork:
            "https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg",
      ),
    ),
  ]);
  int _addedCount = 0;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.black,
    ));
    _init();
  }

  _init() async {
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration.speech());
    try {
      await _player.setAudioSource(_playlist);
    } catch (e) {
      // catch load errors: 404, invalid url ...
      print("An error occured $e");
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: StreamBuilder<SequenceState>(
                  stream: _player.sequenceStateStream,
                  builder: (context, snapshot) {
                    final state = snapshot.data;
                    if (state?.sequence?.isEmpty ?? true) return SizedBox();
                    final metadata = state.currentSource.tag as AudioMetadata;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:
                                Center(child: Image.network(metadata.artwork)),
                          ),
                        ),
                        // Text(metadata.album ?? '',
                        //     style: Theme.of(context).textTheme.headline6),
                        Text(
                          metadata.title ?? '',
                          style: TextStyle(fontSize: 12.0.sp),
                        ),
                      ],
                    );
                  },
                ),
              ),
              ControlButtons(_player),
              StreamBuilder<Duration>(
                stream: _player.durationStream,
                builder: (context, snapshot) {
                  final duration = snapshot.data ?? Duration.zero;
                  return StreamBuilder<PositionData>(
                    stream: Rx.combineLatest2<Duration, Duration, PositionData>(
                        _player.positionStream,
                        _player.bufferedPositionStream,
                        (position, bufferedPosition) =>
                            PositionData(position, bufferedPosition)),
                    builder: (context, snapshot) {
                      final positionData = snapshot.data ??
                          PositionData(Duration.zero, Duration.zero);
                      var position = positionData.position ?? Duration.zero;
                      if (position > duration) {
                        position = duration;
                      }
                      var bufferedPosition =
                          positionData.bufferedPosition ?? Duration.zero;
                      if (bufferedPosition > duration) {
                        bufferedPosition = duration;
                      }
                      return SeekBar(
                        duration: duration,
                        position: position,
                        bufferedPosition: bufferedPosition,
                        onChangeEnd: (newPosition) {
                          _player.seek(newPosition);
                        },
                      );
                    },
                  );
                },
              ),
              SizedBox(height: 8.0),
              Row(
                children: [
                  StreamBuilder<LoopMode>(
                    stream: _player.loopModeStream,
                    builder: (context, snapshot) {
                      final loopMode = snapshot.data ?? LoopMode.off;
                      const icons = [
                        Icon(Icons.repeat, color: Colors.grey),
                        Icon(Icons.repeat, color: Colors.orange),
                        Icon(Icons.repeat_one, color: Colors.orange),
                      ];
                      const cycleModes = [
                        LoopMode.off,
                        LoopMode.all,
                        LoopMode.one,
                      ];
                      final index = cycleModes.indexOf(loopMode);
                      return IconButton(
                        icon: icons[index],
                        onPressed: () {
                          _player.setLoopMode(cycleModes[
                              (cycleModes.indexOf(loopMode) + 1) %
                                  cycleModes.length]);
                        },
                      );
                    },
                  ),
                  Expanded(
                    child: Text(
                      "Playlist",
                      style: Theme.of(context).textTheme.headline6,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  StreamBuilder<bool>(
                    stream: _player.shuffleModeEnabledStream,
                    builder: (context, snapshot) {
                      final shuffleModeEnabled = snapshot.data ?? false;
                      return IconButton(
                        icon: shuffleModeEnabled
                            ? Icon(Icons.shuffle, color: Colors.orange)
                            : Icon(Icons.shuffle, color: Colors.grey),
                        onPressed: () async {
                          final enable = !shuffleModeEnabled;
                          if (enable) {
                            await _player.shuffle();
                          }
                          await _player.setShuffleModeEnabled(enable);
                        },
                      );
                    },
                  ),
                ],
              ),
              Container(
                height: 240.0,
                child: StreamBuilder<SequenceState>(
                  stream: _player.sequenceStateStream,
                  builder: (context, snapshot) {
                    final state = snapshot.data;
                    final sequence = state?.sequence ?? [];
                    return ReorderableListView(
                      onReorder: (int oldIndex, int newIndex) {
                        if (oldIndex < newIndex) newIndex--;
                        _playlist.move(oldIndex, newIndex);
                      },
                      children: [
                        for (var i = 0; i < sequence.length; i++)
                          Dismissible(
                            key: ValueKey(sequence[i]),
                            background: Container(
                              color: Colors.redAccent,
                              alignment: Alignment.centerRight,
                              // child:
                              // Padding(
                              //   padding: const EdgeInsets.only(right: 8.0),
                              //   child: Icon(Icons.delete, color: Colors.white),
                              // ),
                            ),
                            onDismissed: (dismissDirection) {
                              _playlist.removeAt(i);
                            },
                            child: Material(
                              color: i == state.currentIndex
                                  ? Colors.grey.shade300
                                  : null,
                              child: ListTile(
                                title: Text(
                                  sequence[i].tag.title,
                                  style: TextStyle(fontSize: 9.0.sp),
                                ),
                                onTap: () {
                                  _player.seek(Duration.zero, index: i);
                                },
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        // floatingActionButton: FloatingActionButton(
        //   child: Icon(Icons.add),
        //   onPressed: () {
        //     _playlist.add(AudioSource.uri(
        //       Uri.parse("asset:///audio/nature.mp3"),
        //       tag: AudioMetadata(
        //         album: "Public Domain",
        //         title: "Nature Sounds ${++_addedCount}",
        //         artwork:
        //         "https://media.wnyc.org/i/1400/1400/l/80/1/ScienceFriday_WNYCStudios_1400.jpg",
        //       ),
        //     ));
        //   },
        // ),
      ),
    );
  }
}

class ControlButtons extends StatelessWidget {
  final AudioPlayer player;

  ControlButtons(this.player);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(Icons.volume_up),
          onPressed: () {
            _showSliderDialog(
              context: context,
              title: "Adjust volume",
              divisions: 10,
              min: 0.0,
              max: 1.0,
              stream: player.volumeStream,
              onChanged: player.setVolume,
            );
          },
        ),
        StreamBuilder<SequenceState>(
          stream: player.sequenceStateStream,
          builder: (context, snapshot) => IconButton(
            icon: Icon(Icons.skip_previous),
            onPressed: player.hasPrevious ? player.seekToPrevious : null,
          ),
        ),
        StreamBuilder<PlayerState>(
          stream: player.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;
            if (processingState == ProcessingState.loading ||
                processingState == ProcessingState.buffering) {
              return Container(
                margin: EdgeInsets.all(8.0),
                width: 64.0,
                height: 64.0,
                child: CircularProgressIndicator(),
              );
            } else if (playing != true) {
              return IconButton(
                icon: Icon(Icons.play_arrow),
                iconSize: 64.0,
                onPressed: player.play,
              );
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                icon: Icon(Icons.pause),
                iconSize: 64.0,
                onPressed: player.pause,
              );
            } else {
              return IconButton(
                icon: Icon(Icons.replay),
                iconSize: 64.0,
                onPressed: () => player.seek(Duration.zero,
                    index: player.effectiveIndices.first),
              );
            }
          },
        ),
        StreamBuilder<SequenceState>(
          stream: player.sequenceStateStream,
          builder: (context, snapshot) => IconButton(
            icon: Icon(Icons.skip_next),
            onPressed: player.hasNext ? player.seekToNext : null,
          ),
        ),
        StreamBuilder<double>(
          stream: player.speedStream,
          builder: (context, snapshot) => IconButton(
            icon: Text("${snapshot.data?.toStringAsFixed(1)}x",
                style: TextStyle(fontWeight: FontWeight.bold)),
            onPressed: () {
              _showSliderDialog(
                context: context,
                title: "Adjust speed",
                divisions: 10,
                min: 0.5,
                max: 1.5,
                stream: player.speedStream,
                onChanged: player.setSpeed,
              );
            },
          ),
        ),
      ],
    );
  }
}

class SeekBar extends StatefulWidget {
  final Duration duration;
  final Duration position;
  final Duration bufferedPosition;
  final ValueChanged<Duration> onChanged;
  final ValueChanged<Duration> onChangeEnd;

  SeekBar({
    @required this.duration,
    @required this.position,
    @required this.bufferedPosition,
    this.onChanged,
    this.onChangeEnd,
  });

  @override
  _SeekBarState createState() => _SeekBarState();
}

class _SeekBarState extends State<SeekBar> {
  double _dragValue;
  SliderThemeData _sliderThemeData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _sliderThemeData = SliderTheme.of(context).copyWith(
      trackHeight: 2.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SliderTheme(
          data: _sliderThemeData.copyWith(
            thumbShape: HiddenThumbComponentShape(),
            activeTrackColor: Colors.blue.shade100,
            inactiveTrackColor: Colors.grey.shade300,
          ),
          child: ExcludeSemantics(
            child: Slider(
              min: 0.0,
              max: widget.duration.inMilliseconds.toDouble(),
              value: widget.bufferedPosition.inMilliseconds.toDouble(),
              onChanged: (value) {
                setState(() {
                  _dragValue = value;
                });
                if (widget.onChanged != null) {
                  widget.onChanged(Duration(milliseconds: value.round()));
                }
              },
              onChangeEnd: (value) {
                if (widget.onChangeEnd != null) {
                  widget.onChangeEnd(Duration(milliseconds: value.round()));
                }
                _dragValue = null;
              },
            ),
          ),
        ),
        SliderTheme(
          data: _sliderThemeData.copyWith(
            inactiveTrackColor: Colors.transparent,
          ),
          child: Slider(
            min: 0.0,
            max: widget.duration.inMilliseconds.toDouble(),
            value: min(_dragValue ?? widget.position.inMilliseconds.toDouble(),
                widget.duration.inMilliseconds.toDouble()),
            onChanged: (value) {
              setState(() {
                _dragValue = value;
              });
              if (widget.onChanged != null) {
                widget.onChanged(Duration(milliseconds: value.round()));
              }
            },
            onChangeEnd: (value) {
              if (widget.onChangeEnd != null) {
                widget.onChangeEnd(Duration(milliseconds: value.round()));
              }
              _dragValue = null;
            },
          ),
        ),
        Positioned(
          right: 16.0,
          bottom: 0.0,
          child: Text(
              RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
                      .firstMatch("$_remaining")
                      ?.group(1) ??
                  '$_remaining',
              style: Theme.of(context).textTheme.caption),
        ),
      ],
    );
  }

  Duration get _remaining => widget.duration - widget.position;
}

_showSliderDialog({
  BuildContext context,
  String title,
  int divisions,
  double min,
  double max,
  String valueSuffix = '',
  Stream<double> stream,
  ValueChanged<double> onChanged,
}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title, textAlign: TextAlign.center),
      content: StreamBuilder<double>(
        stream: stream,
        builder: (context, snapshot) => Container(
          height: 100.0,
          child: Column(
            children: [
              Text('${snapshot.data?.toStringAsFixed(1)}$valueSuffix',
                  style: TextStyle(
                      fontFamily: 'Fixed',
                      fontWeight: FontWeight.bold,
                      fontSize: 24.0)),
              Slider(
                divisions: divisions,
                min: min,
                max: max,
                value: snapshot.data ?? 1.0,
                onChanged: onChanged,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class AudioMetadata {
  final String title;
  final String artwork;

  AudioMetadata({this.title, this.artwork});
}

class HiddenThumbComponentShape extends SliderComponentShape {
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) => Size.zero;

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    Animation<double> activationAnimation,
    Animation<double> enableAnimation,
    bool isDiscrete,
    TextPainter labelPainter,
    RenderBox parentBox,
    SliderThemeData sliderTheme,
    TextDirection textDirection,
    double value,
    double textScaleFactor,
    Size sizeWithOverflow,
  }) {}
}

class PositionData {
  final Duration position;
  final Duration bufferedPosition;

  PositionData(this.position, this.bufferedPosition);
}

// import 'package:assets_audio_player/assets_audio_player.dart';
// import 'package:flutter/material.dart';
// import 'package:sizer/sizer.dart';
// import 'package:table_lamp/Utils/constants.dart';
//
// class RelaxScreen extends StatefulWidget {
//   @override
//   _RelaxScreenState createState() => _RelaxScreenState();
// }
//
// class _RelaxScreenState extends State<RelaxScreen> {
//   final assetsAudioPlayer = AssetsAudioPlayer();
//
//   bool _isPlaying = false;
//
//   void toggleIcon() {
//     _isPlaying = !_isPlaying;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: bottomNavColor,
//         elevation: 0.0,
//         toolbarHeight: 8.0.h,
//         title: Text(
//           'Relaxing Sounds',
//           style: TextStyle(color: Colors.white, fontSize: 16.0.sp),
//         ),
//       ),
//       body: Container(
//         height: 92.0.h,
//         width: 100.0.w,
//         color: Colors.white,
//         child: ListView(
//           children: [
//             SizedBox(
//               height: 5.0.h,
//             ),
//             GestureDetector(
//               onTap: () {
//                 setState(() {
//                  toggleIcon();
//                 });
//                 AssetsAudioPlayer.playAndForget(
//
//                     Audio("assets/audios/song1.mp3",
//
//                 ),
//                 //showNotification: true,
//                 );
//               },
//               child: Container(
//                 height: 20.0.h,
//                 width: 70.0.w,
//                 color: Colors.yellowAccent,
//                 child: Icon(_isPlaying ? Icons.play_circle_outline_rounded : Icons.pause),
//               ),
//             ),
//             GestureDetector(
//               onTap: () {
//                 setState(() {
//                  toggleIcon();
//                 });
//                 AssetsAudioPlayer.newPlayer()
//                     .open(
//                   Audio("assets/audios/song2.mp3"),
//                   showNotification: true,
//                 );
//               },
//               child: Container(
//                 height: 20.0.h,
//                 width: 70.0.w,
//                 color: Colors.yellow,
//                 child: Icon(_isPlaying ? Icons.play_circle_outline_rounded : Icons.pause),
//               ),
//             ),
//             // RelaxingSoundItem('Rainy Day', Icons.grain, "assets/audios/song1.mp3", ),
//             // RelaxingSoundItem('Cool Night', Icons.nightlight_round, "assets/audios/sng1.mp3", ),
//             // RelaxingSoundItem('Sunny Day', Icons.wb_sunny_outlined, "assets/audios/ong1.mp3", ),
//           ],
//         ),
//       ),
//       // floatingActionButton: Container(
//       //   height: 40.0.sp,
//       //   width: 40.0.sp,
//       //   color: Colors.yellowAccent,
//       //   child: Icon(_isPlaying ? Icons.play_circle_outline_outlined : Icons.pause,),
//       // ),
//     );
//   }
//
//   Widget RelaxingSoundItem(
//     String title,
//     IconData icon,
//     String path,
//   ) {
//     return GestureDetector(
//       onTap: () {
//         _isPlaying
//             ? assetsAudioPlayer.open(
//                 Audio(path),
//                 showNotification: true,
//               )
//             : assetsAudioPlayer.playOrPause();
//         setState(() {
//           toggleIcon();
//         });
//       },
//       child: Padding(
//         padding: EdgeInsets.symmetric(
//             horizontal: kDefaultMargin, vertical: kDefaultMargin / 2),
//         child: Material(
//           borderRadius: BorderRadius.circular(kDefaultBorderRadius.sp),
//           elevation: 4,
//           child: Container(
//             height: 10.0.h,
//             width: 100.0.w,
//             decoration: BoxDecoration(
//                 color: bottomNavColor,
//                 borderRadius: BorderRadius.circular(kDefaultBorderRadius.sp)),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 Icon(
//                   icon,
//                   color: Colors.white,
//                   size: 22.0.sp,
//                 ),
//                 Text(
//                   title,
//                   style: TextStyle(color: Colors.white, fontSize: 12.0.sp),
//                 ),
//                 // Icon(
//                 //   trailingIcon,
//                 //   color: Colors.white,
//                 //   size: 22.0.sp,
//                 // )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }