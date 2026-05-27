import 'package:cached_network_image/cached_network_image.dart';
import 'package:first_demo/common/async_loader/async_loader.dart';
import 'package:first_demo/common/network/animal/model/animal.dart';
import 'package:first_demo/common/scaffold/base_scaffold.dart';
import 'package:first_demo/pages/animal_image/repository.dart';
import 'package:first_demo/res/string/strings.dart';
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
      title: l10n(context).animalImagePageTitle,
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
