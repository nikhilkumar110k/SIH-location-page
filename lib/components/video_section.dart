import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoSection extends StatefulWidget {
  @override
  State<VideoSection> createState() => _VideoSectionState();
}

class _VideoSectionState extends State<VideoSection> {
  late VideoPlayerController _controller1;
  late VideoPlayerController _controller2;
  bool _isPlaying1 = false;
  bool _isPlaying2 = false;

  @override
  void initState() {
    super.initState();
    _controller1 = VideoPlayerController.network(
        "https://vod-progressive.akamaized.net/exp=1709312976~acl=%2Fvimeo-prod-skyfire-std-us%2F01%2F2196%2F20%2F510981338%2F2357992241.mp4~hmac=d239a75ea1e9bbab3231fee79ec2308b78ac5d9051d7ecdc949920143063cf9f/vimeo-prod-skyfire-std-us/01/2196/20/510981338/2357992241.mp4");
    _controller2 = VideoPlayerController.network(
        "https://vod-progressive.akamaized.net/exp=1709316756~acl=%2Fvimeo-prod-skyfire-std-us%2F01%2F1563%2F20%2F507818248%2F2333788028.mp4~hmac=8b98f2a413c90d223ccb9905b3aee3e47f6d899183fe18f2e1fa090d1ac09335/vimeo-prod-skyfire-std-us/01/1563/20/507818248/2333788028.mp4");

    _initializeControllers();
  }

  Future<void> _initializeControllers() async {
    await Future.wait([
      _controller1.initialize(),
      _controller2.initialize(),
    ]);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_controller1.value.isInitialized)
          buildVideoPlayer(_controller1, _isPlaying1),
        SizedBox(
          width: 20,
        ),
        if (_controller2.value.isInitialized)
          buildVideoPlayer(_controller2, _isPlaying2),
      ],
    );
  }

  Widget buildVideoPlayer(VideoPlayerController controller, bool isPlaying) {
    return Container(
      height: 150,
      width: 150,
      child: AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            VideoPlayer(controller),
            IconButton(
              icon: Icon(
                isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  if (isPlaying) {
                    controller.pause();
                  } else {
                    controller.play();
                  }
                  if (controller == _controller1) {
                    _isPlaying1 = !_isPlaying1;
                  } else if (controller == _controller2) {
                    _isPlaying2 = !_isPlaying2;
                  }
                });
              },
            ),
          ],
        ),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller1.dispose();
    _controller2.dispose();
  }
}
