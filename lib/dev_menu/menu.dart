import 'package:first_demo/res/string/strings.dart';
import 'package:first_demo/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DevMenu extends StatelessWidget {
  DevMenu({Key? key}) : super(key: key);

  final _items = {
    R.counter_page_title: () => Get.toNamed(Routes.COUNTER),
    R.animal_image_page_title: () => Get.toNamed(Routes.ANIMAL_IMAGE),
    R.moments_page_title: () => Get.toNamed(Routes.MOMENTS),
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: theme.colorScheme.primary),
              child: Center(
                  child: Text(
                stringRes(R.dev_menu),
                style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.colorScheme.onPrimary,
                ),
              )),
            ),
            ...ListTile.divideTiles(
              context: context,
              tiles: _items.entries
                  .map((entry) => ListTile(
                        key: Key(entry.key.name),
                        style: ListTileStyle.drawer,
                        trailing: const Icon(Icons.arrow_right),
                        title: Text(stringRes(entry.key)),
                        onTap: entry.value,
                      ))
                  .toList(),
            ).toList(),
          ]),
    );
  }
}
