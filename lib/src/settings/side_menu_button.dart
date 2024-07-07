import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class SideMenuButton extends StatelessWidget {
  final String title;
  final IconData iconData;
  final IconData? activeIcon;
  final bool isActive;
  final Function()? onTap;
  final bool showTooltip;

  const SideMenuButton({
    super.key,
    required this.iconData,
    required this.isActive,
    required this.title,
    this.onTap,
    this.activeIcon,
    required this.showTooltip,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 15),
      child: TextButton(
        child: Container(
          decoration: isActive
              ? BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 1.0,
                    ),
                  ),
                )
              : null,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(isActive ? activeIcon ?? iconData : iconData,
                    size: isActive ? 22 : 20,
                    color: isActive
                        ? Theme.of(context).colorScheme.primary
                        : Colors.blueGrey),
                Gap(20),
                SizedBox(
                  width: 175,
                  child: Tooltip(
                    message: showTooltip ? title : "",
                    child: Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: isActive
                              ? Theme.of(context).colorScheme.primary
                              : Colors.black,
                          fontWeight:
                              isActive ? FontWeight.bold : FontWeight.normal,
                          fontSize: isActive ? 18 : 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        onPressed: isActive ? null : onTap,
      ),
    );
  }
}
