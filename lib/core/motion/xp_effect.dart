import 'package:flutter/material.dart';
import 'motion_system.dart';

class XPEffect extends StatefulWidget {
  final int xp;
  final VoidCallback? onComplete;
  
  const XPEffect(this.xp, {super.key, this.onComplete});

  @override
  State<XPEffect> createState() => _XPEffectState();
}

class _XPEffectState extends State<XPEffect>
    with SingleTickerProviderStateMixin {

  late AnimationController controller;
  late Animation<double> scale;
  late Animation<double> fade;
  late Animation<double> slideUp;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: MotionSystem.medium,
    );

    scale = Tween(begin: 0.6, end: MotionSystem.scaleExplosion).animate(
      CurvedAnimation(parent: controller, curve: MotionSystem.curveElastic),
    );

    fade = Tween(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: controller, curve: const Interval(0.5, 1.0)),
    );
    
    slideUp = Tween(begin: 0.0, end: -50.0).animate(
      CurvedAnimation(parent: controller, curve: MotionSystem.curve),
    );

    controller.forward().then((_) {
      widget.onComplete?.call();
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        return Opacity(
          opacity: fade.value,
          child: Transform.translate(
            offset: Offset(0, slideUp.value),
            child: Transform.scale(
              scale: scale.value,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFD4AF37), width: 2),
                ),
                child: Text(
                  "+${widget.xp} XP",
                  style: const TextStyle(
                    color: Color(0xFFD4AF37),
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
