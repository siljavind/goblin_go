import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';

/// A button showing liquid progress clipped to a custom watering can shape using user-provided path.
class WateringCanProgressButton extends StatelessWidget {
  final double progress;
  final VoidCallback onPressed;

  const WateringCanProgressButton({
    Key? key,
    required this.progress,
    required this.onPressed,
  }) : super(key: key);

  /// Builds the Path using the user-provided path logic.
  Path wateringCanPath(Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width*0.8705410,size.height*0.2936645);
    path_0.cubicTo(size.width*0.8204062,size.height*0.2936645,size.width*0.7848873,size.height*0.3183173,size.width*0.7605221,size.height*0.3501858);
    path_0.lineTo(size.width*0.7590963,size.height*0.3061782);
    path_0.cubicTo(size.width*0.7590963,size.height*0.2847515,size.width*0.7441040,size.height*0.2653630,size.width*0.7255979,size.height*0.2653630);
    path_0.lineTo(size.width*0.3571706,size.height*0.2653630);
    path_0.cubicTo(size.width*0.3386806,size.height*0.2653630,size.width*0.3236722,size.height*0.2847515,size.width*0.3236722,size.height*0.3061782);
    path_0.lineTo(size.width*0.3195300,size.height*0.4228358);
    path_0.lineTo(size.width*0.1007970,size.height*0.2467042);
    path_0.cubicTo(size.width*0.1111198,size.height*0.2219662,size.width*0.1123254,size.height*0.2013561,size.width*0.1017132,size.height*0.1939700);
    path_0.cubicTo(size.width*0.08644919,size.height*0.1833579,size.width*0.05298631,size.height*0.2053457,size.width*0.02697520,size.height*0.2427662);
    path_0.cubicTo(size.width*0.0009640976,size.height*0.2801689,size.width*-0.007744740,size.height*0.3192370,size.width*0.007517475,size.height*0.3298474);
    path_0.cubicTo(size.width*0.01921626,size.height*0.3379757,size.width*0.04155740,size.height*0.3270137,size.width*0.06307648,size.height*0.3046690);
    path_0.lineTo(size.width*0.3120391,size.height*0.6322971);
    path_0.lineTo(size.width*0.3069293,size.height*0.7693623);
    path_0.cubicTo(size.width*0.3069293,size.height*0.7907873,size.width*0.3219216,size.height*0.8086985,size.width*0.3404276,size.height*0.8086985);
    path_0.lineTo(size.width*0.7423374,size.height*0.8086985);
    path_0.cubicTo(size.width*0.7608275,size.height*0.8086985,size.width*0.7758358,size.height*0.7907873,size.width*0.7758358,size.height*0.7693623);
    path_0.lineTo(size.width*0.7731530,size.height*0.6972893);
    path_0.cubicTo(size.width*0.8045794,size.height*0.6585958,size.width*0.8410659,size.height*0.6325013,size.width*0.8767038,size.height*0.6061670);
    path_0.cubicTo(size.width*0.9401176,size.height*0.5593062,size.width*0.9999982,size.height*0.5156058,size.width*0.9999982,size.height*0.4181662);
    path_0.cubicTo(size.width,size.height*0.3433768,size.width*0.9479778,size.height*0.2936645,size.width*0.8705410,size.height*0.2936645);
    path_0.close();
    path_0.moveTo(size.width*0.8536471,size.height*0.5760634);
    path_0.cubicTo(size.width*0.8269738,size.height*0.5957768,size.width*0.7983314,size.height*0.6172870,size.width*0.7711502,size.height*0.6442480);
    path_0.lineTo(size.width*0.7633575,size.height*0.4288104);
    path_0.cubicTo(size.width*0.7756138,size.height*0.3899642,size.width*0.8048191,size.height*0.3324752,size.width*0.8705393,size.height*0.3324752);
    path_0.cubicTo(size.width*0.9273163,size.height*0.3324752,size.width*0.9612035,size.height*0.3647005,size.width*0.9612035,size.height*0.4187255);
    path_0.cubicTo(size.width*0.9612053,size.height*0.4966061,size.width*0.9137337,size.height*0.5316652,size.width*0.8536471,size.height*0.5760634);
    path_0.close();

    Paint paint0Fill = Paint()..style=PaintingStyle.fill;
    paint0Fill.color = Color(0xff000000);
    return path_0;
  }

  @override
  Widget build(BuildContext context) {
    const double width = 100.0;
    const double height = 100.0;
    Color color = Colors.blue.shade500;

    return GestureDetector(
      onTap: () => {
        color = Colors.blue.shade900,
      },
      child: SizedBox(
        width: width,
        height: height,
        child: LiquidCustomProgressIndicator(
          value: progress,
          direction: Axis.vertical,
          backgroundColor: Colors.grey.shade200,
          valueColor: AlwaysStoppedAnimation(color),
          //borderColor: Colors.blue.shade900,
          //borderWidth: 1.0,
          shapePath: wateringCanPath(Size(width, height)),
          //center: const Icon(Icons.opacity, color: Colors.white),
        ),
      ),
    );
  }
}
