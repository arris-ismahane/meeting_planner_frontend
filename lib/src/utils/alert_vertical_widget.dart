import 'package:flutter/material.dart';

enum AlertType { INFO, WARNING, DANGER }

class AlertVerticalWidget extends StatelessWidget {
  final String text;
  final IconData? iconData;
  final AlertType type;
  final double margin;
  final double iconSize;
  final Color? color;

  AlertVerticalWidget(
    this.text, {
    this.iconData = Icons.info_outline,
    this.type = AlertType.INFO,
    this.iconSize = 64,
    this.margin = 10,
    this.color,
  });

  Color _getTextColor() {
    switch (type) {
      case AlertType.INFO:
        return Colors.blueAccent;
      case AlertType.WARNING:
        return Colors.orange;
      case AlertType.DANGER:
        return Colors.redAccent;
    }
  }

  Color _getBackGroundColor({Color? color}) {
    return color ?? Colors.transparent;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: _getBackGroundColor(),
          border: Border.all(
            color: _getBackGroundColor(),
          ),
          borderRadius: BorderRadius.circular(7)),
      margin: EdgeInsets.all(margin),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            iconData == null
                ? SizedBox.shrink()
                : Icon(
                    iconData,
                    color: color ?? _getTextColor(),
                    size: iconSize,
                  ),
            SizedBox(
              height: iconData == null ? 0 : 16,
            ),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: color != null ? Colors.black : _getTextColor(),
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.visible,
            ),
          ],
        ),
      ),
    );
  }
}
