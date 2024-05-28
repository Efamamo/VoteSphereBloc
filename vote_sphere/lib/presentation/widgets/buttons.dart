import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  const MyButton(
      {super.key,
      required this.color,
      required this.child,
      required this.onTapped});
  final Widget child;
  final void Function(BuildContext) onTapped;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      child: const Text('Create group'),
      onPressed: () {
        onTapped;
      },
    );
  }
}
