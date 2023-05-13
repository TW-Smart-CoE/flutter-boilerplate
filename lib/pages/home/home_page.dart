import 'package:first_demo/res/string/strings.dart';
import 'package:first_demo/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final _items = {
    R.counter_page_title: () => Get.toNamed(Routes.COUNTER),
    R.animal_image_page_title: () => Get.toNamed(Routes.ANIMAL_IMAGE),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(stringRes(R.app_name)),
      ),
      body: ListView(
        children: ListTile.divideTiles(
          context: context,
          tiles: _items.entries
              .map((entry) => ListTile(
                    key: Key(entry.key.name),
                    style: ListTileStyle.list,
                    leading: const Icon(Icons.flutter_dash_outlined),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    title: Text(stringRes(entry.key)),
                    onTap: entry.value,
                  ))
              .toList(),
        ).toList(),
      ),
    );
  }
}
