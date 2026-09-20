import 'package:appocrm/models/pipeline_status.dart';
import 'package:appocrm/widgets/pipeline_selector.dart';
import 'package:flutter/material.dart';

class ContactAvatar extends StatelessWidget {
  const ContactAvatar({
    super.key,
    required this.name,
    required this.pipeline,
    this.size = 48,
    this.large = false,
  });

  final String name;
  final PipelineStatus pipeline;
  final double size;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final letter = name.trim().isNotEmpty ? name.trim()[0].toUpperCase() : '?';
    final color = pipelineColor(pipeline);
    final dimension = large ? 72.0 : size;

    return Container(
      width: dimension,
      height: dimension,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withValues(alpha: 0.95),
            Color.lerp(color, Colors.black, 0.12)!,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.28),
            blurRadius: large ? 16 : 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(
        letter,
        style: TextStyle(
          color: Colors.white,
          fontSize: large ? 28 : dimension * 0.42,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
