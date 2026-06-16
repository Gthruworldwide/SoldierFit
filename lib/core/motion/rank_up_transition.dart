import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';
import 'motion_system.dart';

class RankUpTransition extends StatefulWidget {
  final String oldRank;
  final String newRank;
  final VoidCallback? onComplete;
  
  const RankUpTransition({
    super.key,
    required this.oldRank,
    required this.newRank,
    this.onComplete,
  });

  @override
  State<RankUpTransition> createState() => _RankUpTransitionState();
}

class _RankUpTransitionState extends State<RankUpTransition>
    with SingleTickerProviderStateMixin {

  late AnimationController controller;
  late Animation<double> blur;
  late Animation<double> scale;
  late Animation<double> fade;
  late Animation<double> shine;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: MotionSystem.extraSlow,
    );

    blur = Tween(begin: 0.0, end: 10.0).animate(
      CurvedAnimation(parent: controller, curve: MotionSystem.curve),
    );

    scale = Tween(begin: 0.5, end: 1.2).animate(
      CurvedAnimation(parent: controller, curve: MotionSystem.curveElastic),
    );

    fade = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: controller, curve: const Interval(0.3, 1.0)),
    );
    
    shine = Tween(begin: -1.0, end: 1.0).animate(
      CurvedAnimation(parent: controller, curve: MotionSystem.curve),
    );

    // Trigger vibration
    _triggerVibration();
    
    controller.forward().then((_) {
      widget.onComplete?.call();
    });
  }

  Future<void> _triggerVibration() async {
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 500, amplitude: 255);
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: AnimatedBuilder(
        animation: controller,
        builder: (_, __) {
          return Stack(
            children: [
              // Blurred background
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: blur.value, sigmaY: blur.value),
                child: Container(
                  color: Colors.black.withOpacity(0.8),
                ),
              ),
              
              // Rank badge
              Center(
                child: Opacity(
                  opacity: fade.value,
                  child: Transform.scale(
                    scale: scale.value,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Old rank (fading out)
                        AnimatedOpacity(
                          opacity: 1.0 - controller.value,
                          duration: MotionSystem.fast,
                          child: Text(
                            widget.oldRank,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 20),
                        
                        // New rank with shine effect
                        ShaderMask(
                          shaderCallback: (bounds) {
                            return LinearGradient(
                              begin: Alignment(-1.0 + shine.value, 0),
                              end: Alignment(1.0 + shine.value, 0),
                              colors: const [
                                Color(0xFFD4AF37),
                                Color(0xFFFFF8DC),
                                Color(0xFFD4AF37),
                              ],
                            ).createShader(bounds);
                          },
                          child: Text(
                            widget.newRank.toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 4,
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 30),
                        
                        // Promotion text
                        AnimatedOpacity(
                          opacity: fade.value,
                          duration: MotionSystem.medium,
                          child: const Text(
                            'PROMOTION UNLOCKED',
                            style: TextStyle(
                              color: Color(0xFFD4AF37),
                              fontSize: 18,
                              letterSpacing: 3,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
