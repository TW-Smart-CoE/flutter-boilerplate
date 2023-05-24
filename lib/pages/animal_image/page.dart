import 'package:cached_network_image/cached_network_image.dart';
import 'package:first_demo/common/async_loader/async_load_processor.dart';
import 'package:first_demo/common/async_loader/auto_load_controller.dart';
import 'package:first_demo/common/scaffold/base_scaffold.dart';
import 'package:first_demo/pages/animal_image/controller.dart';
import 'package:first_demo/res/string/strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AnimalImagePage extends StatelessWidget {
  final AnimalImageController _controller;

  AnimalImagePage({Key? key, AnimalImageController? animalImageController})
      : _controller = animalImageController ?? Get.put(AnimalImageController()),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: stringRes(R.animal_image_page_title),
      body: AsyncLoadProcessor(
        Get.put(AutoLoadController(_controller)),
        content: (data) => _animalImageContent(_controller),
      ),
    );
  }

  Widget _animalImageContent(AnimalImageController controller) {
    final animals = controller.data;
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      itemCount: animals.length,
      itemBuilder: (context, index) {
        final animal = animals[index];
        return CachedNetworkImage(
          imageUrl: animal.url ?? '',
          fit: BoxFit.cover,
        );
      },
    );
  }
}
