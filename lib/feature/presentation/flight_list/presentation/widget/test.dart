import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CupertinoExpansionTile extends StatefulWidget {
  final String title;
  final List<Widget> children;

  const CupertinoExpansionTile({Key? key, required this.title, required this.children}) : super(key: key);

  @override
  _CupertinoExpansionTileState createState() => _CupertinoExpansionTileState();
}

class _CupertinoExpansionTileState extends State<CupertinoExpansionTile> {
  bool _isExpanded = false;

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoContextMenu(
      child: Column(
        children: [
          ListTile(title: Text(widget.title)),
          if (_isExpanded)
            Column(
              children: widget.children,
            ),
        ],
      ),
      actions: [
        CupertinoContextMenuAction(
          child: Text(_isExpanded ? 'Thu gọn' : 'Mở rộng'),
          onPressed: () {
            _toggleExpansion();
            Navigator.pop(context); // Đóng menu sau khi chọn hành động
          },
        ),
      ],
    );
  }
}
