import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomCupertion extends StatelessWidget {
  final String title;
  final Function() onPressed;
  final Widget child;
  const CustomCupertion({
    super.key,
    required this.title,
    required this.onPressed,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Center(
        child: CupertinoContextMenu(
          actions: [
            CupertinoContextMenuAction(
              child: Text(title),
              onPressed: () {
                Navigator.pop(context);
                onPressed();
              },
            ),
          ],
          child: Container(
            padding: EdgeInsets.all(20),
            child: child,
          ),
        ),
      ),
    );
  }
}
