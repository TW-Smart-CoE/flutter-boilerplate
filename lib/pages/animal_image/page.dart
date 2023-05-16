import 'package:first_demo/common/scaffold/base_scaffold.dart';
import 'package:first_demo/pages/animal_image/controller.dart';
import 'package:first_demo/res/string/strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AnimalImagePage extends GetView<AnimalImageController> {
  const AnimalImagePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: stringRes(R.animal_image_page_title),
      body: Obx(() {
        final animals = controller.animals();
        if (animals == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(stringRes(R.loading)),
              ],
            ),
          );
        } else {
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
            itemCount: animals.length,
            itemBuilder: (context, index) {
              final animal = animals[index];
              return Image.network(
                animal.url ?? '',
                fit: BoxFit.cover,
              );
            },
          );
        }
      }),
    );
  }
}
