import 'package:flutter/material.dart';

class InfoOverlay extends StatelessWidget {
  final String info;
  final Widget child;

  const InfoOverlay({
    required this.info,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            color: Colors.black.withOpacity(0.5),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            child: Text(
              info,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
