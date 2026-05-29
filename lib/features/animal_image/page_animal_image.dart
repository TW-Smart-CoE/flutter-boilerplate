import 'package:cached_network_image/cached_network_image.dart';
import 'package:first_demo/features/animal_image/model_animal_image.dart';
import 'package:first_demo/features/animal_image/repository_animal_image.dart';
import 'package:first_demo/res/string/strings.dart';
import 'package:first_demo/widgets/async_loader/async_loader.dart';
import 'package:first_demo/widgets/scaffold/base_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fquery/fquery.dart';

class AnimalImagePage extends HookWidget {
  final AnimalImageRepository _repository;

  AnimalImagePage({super.key, AnimalImageRepository? repository})
      : _repository = repository ?? AnimalImageRepository();

  @override
  Widget build(BuildContext context) {
    final animalsQuery = useQuery(
      ['animals'],
      _repository.getAnimals,
      context: context,
    );

    return BaseScaffold(
      context: context,
      title: stringsOf(context).animalImagePageTitle,
      body: AsyncLoader<List<Animal>>(
        context: context,
        query: animalsQuery,
        builder: (animals) => GridView.builder(
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
        ),
      ),
    );
  }
}
