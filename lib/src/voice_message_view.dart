import 'package:flutter/material.dart';
import 'package:voice_message_package/src/helpers/play_status.dart';
import 'package:voice_message_package/src/helpers/utils.dart';
import 'package:voice_message_package/src/voice_controller.dart';
import 'package:voice_message_package/src/widgets/noises.dart';
import 'package:voice_message_package/src/widgets/play_pause_button.dart';

/// A widget that displays a voice message view with play/pause functionality.
///
/// The [VoiceMessageView] widget is used to display a voice message with customizable appearance and behavior.
/// It provides a play/pause button, a progress slider, and a counter for the remaining time.
/// The appearance of the widget can be customized using various properties such as background color, slider color, and text styles.
///
class VoiceMessageView extends StatelessWidget {
  const VoiceMessageView({
    Key? key,
    required this.controller,
    this.backgroundColor = Colors.white,
    this.activeSliderColor = Colors.red,
    this.notActiveSliderColor,
    this.circlesColor = Colors.red,
    this.innerPadding = 12,
    this.cornerRadius = 20,
    // this.playerWidth = 170,
    this.size = 38,
    this.refreshIcon = const Icon(
      Icons.refresh,
      color: Colors.white,
    ),
    this.pauseIcon = const Icon(
      Icons.pause_rounded,
      color: Colors.white,
    ),
    this.playIcon = const Icon(
      Icons.play_arrow_rounded,
      color: Colors.white,
    ),
    this.stopDownloadingIcon = const Icon(
      Icons.close,
      color: Colors.white,
    ),
    this.playPauseButtonDecoration,
    this.circlesTextStyle = const TextStyle(
      color: Colors.white,
      fontSize: 10,
      fontWeight: FontWeight.bold,
    ),
    this.counterTextStyle = const TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w500,
    ),
    this.playPauseButtonLoadingColor = Colors.white,
    this.isIconNeed = false,
    this.isRead = false,
    this.isNeedSendTime = false,
    this.sendTime = '',
    this.icon = Icons.done_all,
  }) : super(key: key);

  /// The controller for the voice message view.
  final VoiceController controller;

  /// The background color of the voice message view.
  final Color backgroundColor;

  ///
  final Color circlesColor;

  /// The color of the active slider.
  final Color activeSliderColor;

  /// The color of the not active slider.
  final Color? notActiveSliderColor;

  /// The text style of the circles.
  final TextStyle circlesTextStyle;

  /// The text style of the counter.
  final TextStyle counterTextStyle;

  /// The padding between the inner content and the outer container.
  final double innerPadding;

  /// The corner radius of the outer container.
  final double cornerRadius;

  /// The size of the play/pause button.
  final double size;

  /// The refresh icon of the play/pause button.
  final Widget refreshIcon;

  /// The pause icon of the play/pause button.
  final Widget pauseIcon;

  /// The play icon of the play/pause button.
  final Widget playIcon;

  /// The stop downloading icon of the play/pause button.
  final Widget stopDownloadingIcon;

  /// The play Decoration of the play/pause button.
  final Decoration? playPauseButtonDecoration;

  /// The loading Color of the play/pause button.
  final Color playPauseButtonLoadingColor;

  final bool isIconNeed;
  final bool isRead;
  final bool isNeedSendTime;
  final String sendTime;
  final IconData icon;

  @override

  /// Build voice message view.
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final color = circlesColor;
    final newTHeme = theme.copyWith(
      sliderTheme: SliderThemeData(
        trackShape: CustomTrackShape(),
        thumbShape: SliderComponentShape.noThumb,
        minThumbSeparation: 0,
      ),
      splashColor: Colors.transparent,
    );

    return Container(
      width: 250,
      height: 100,
      padding: EdgeInsets.all(innerPadding),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(cornerRadius),
      ),
      child: ValueListenableBuilder(
        /// update ui when change play status
        valueListenable: controller.updater,
        builder: (context, value, child) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 50,
                child: PlayPauseButton(
                  controller: controller,
                  color: color,
                  loadingColor: playPauseButtonLoadingColor,
                  size: size,
                  refreshIcon: refreshIcon,
                  pauseIcon: pauseIcon,
                  playIcon: playIcon,
                  stopDownloadingIcon: stopDownloadingIcon,
                  buttonDecoration: playPauseButtonDecoration,
                ),
              ),
              FittedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 50,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(width: 100, child: _noises(newTHeme)),
                          _changeSpeedButton(color),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                      child: Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(controller.remindingTime,
                                style: counterTextStyle),
                            // Spacer(),
                            Row(
                              children: [
                                isNeedSendTime
                                    ? Text(sendTime, style: counterTextStyle)
                                    : const SizedBox.shrink(),
                                const SizedBox(width: 10),
                                isIconNeed
                                    ? Icon(
                                        icon,
                                        color: isRead
                                            ? Colors.blue.shade500
                                            : Colors.grey.shade500,
                                        size: 15.0,
                                      )
                                    : const SizedBox.shrink()
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
            ],
          );
        },
      ),
    );
  }

  Container _noises(ThemeData newTHeme) => Container(
        height: 30,
        width: controller.noiseWidth,
        child: Stack(
          alignment: Alignment.center,
          children: [
            /// noises
            Noises(
              rList: controller.randoms!,
              activeSliderColor: activeSliderColor,
            ),

            /// slider
            AnimatedBuilder(
              animation: CurvedAnimation(
                parent: controller.animController,
                curve: Curves.ease,
              ),
              builder: (BuildContext context, Widget? child) {
                return Positioned(
                  left: controller.animController.value,
                  child: Container(
                    width: controller.noiseWidth,
                    height: 6.w(),
                    color:
                        notActiveSliderColor ?? backgroundColor.withOpacity(.4),
                  ),
                );
              },
            ),
            Opacity(
              opacity: 0,
              child: Container(
                width: controller.noiseWidth,
                color: Colors.transparent.withOpacity(1),
                child: Theme(
                  data: newTHeme,
                  child: Slider(
                    value: controller.currentMillSeconds,
                    max: controller.maxMillSeconds,
                    onChangeStart: controller.onChangeSliderStart,
                    onChanged: controller.onChanging,
                    onChangeEnd: (value) {
                      controller.onSeek(
                        Duration(milliseconds: value.toInt()),
                      );
                      controller.play();
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  Widget _changeSpeedButton(Color color) => GestureDetector(
        onTap: () {
          controller.changeSpeed();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
          height: 20,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
            child: Text(
              controller.speed.playSpeedStr,
              style: circlesTextStyle,
            ),
          ),
        ),
      );
}

///
/// A custom track shape for a slider that is rounded rectangular in shape.
/// Extends the [RoundedRectSliderTrackShape] class.
class CustomTrackShape extends RoundedRectSliderTrackShape {
  @override

  /// Returns the preferred rectangle for the voice message view.
  ///
  /// The preferred rectangle is calculated based on the current state and layout
  /// of the voice message view. It represents the area where the view should be
  /// displayed on the screen.
  ///
  /// Returns a [Rect] object representing the preferred rectangle.
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    const double trackHeight = 10;
    final double trackLeft = offset.dx,
        trackTop = offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}
