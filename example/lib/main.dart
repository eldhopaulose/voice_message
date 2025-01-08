import 'package:flutter/material.dart';
import 'package:voice_message_package/voice_message_package.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          backgroundColor: Colors.grey.shade200,
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                      height: 350), // Replaced 50.h with fixed height
                  VoiceMessageView(
                    isIconNeed: true,
                    isRead: true,
                    isNeedSendTime: true,
                    sendTime: '12:00 PM',
                    controller: VoiceController(
                      audioSrc:
                          'https://dl.solahangs.com/Music/1403/02/H/128/Hiphopologist%20-%20Shakkak%20%28128%29.mp3',
                      maxDuration: const Duration(seconds: 10),
                      isFile: false,
                      onComplete: () {
                        /// do something on complete
                      },
                      onPause: () {
                        /// do something on pause
                      },
                      onPlaying: () {
                        /// do something on playing
                      },
                      onError: (err) {
                        /// do something on error
                      },
                    ),
                    innerPadding: 5,
                    cornerRadius: 20,
                  ),
                  const SizedBox(
                      height: 560), // Replaced 80.h with fixed height
                ],
              ),
            ),
          ),
        ),
      );
}
