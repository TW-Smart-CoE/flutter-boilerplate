import 'package:first_demo/features/moments/repository_moments.dart';
import 'package:first_demo/features/moments/tweet/index.dart';
import 'package:first_demo/features/moments/user/index.dart';
import 'package:first_demo/res/string/strings.dart';
import 'package:first_demo/widgets/async_loader/index.dart';
import 'package:first_demo/widgets/scaffold/base_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fquery/fquery.dart';

class MomentsPage extends HookWidget {
  final MomentsRepository _repository;

  MomentsPage({
    super.key,
    MomentsRepository? repository,
  }) : _repository = repository ?? MomentsRepository();

  @override
  Widget build(BuildContext context) {
    final momentsQuery = useQuery(
      ['moments'],
      _repository.getMoments,
      context: context,
    );

    return BaseScaffold(
      context: context,
      title: stringsOf(context).momentsPageTitle,
      body: AsyncLoader<MomentsData>(
        context: context,
        query: momentsQuery,
        builder: (data) => NestedScrollView(
          headerSliverBuilder: (_, __) => [
            SliverToBoxAdapter(
              child: UserView(user: data.user),
            ),
          ],
          body: TweetView(tweets: data.tweets),
        ),
      ),
    );
  }
}
