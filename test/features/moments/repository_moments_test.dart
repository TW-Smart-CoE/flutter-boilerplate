import 'package:first_demo/features/moments/repository_moments.dart';
import 'package:first_demo/features/moments/tweet/model/sender.dart';
import 'package:first_demo/features/moments/tweet/model/tweet.dart';
import 'package:first_demo/features/moments/tweet/repository_tweet.dart';
import 'package:first_demo/features/moments/user/model_user.dart';
import 'package:first_demo/features/moments/user/repository_user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'repository_moments_test.mocks.dart';

@GenerateNiceMocks([MockSpec<UserRepository>(), MockSpec<TweetRepository>()])
void main() {
  late MockUserRepository mockUserRepo;
  late MockTweetRepository mockTweetRepo;
  late MomentsRepository repository;

  const user = User('john', 'John', 'https://avatar.url', 'https://profile.url');
  const sender = Sender('john', 'John', 'https://avatar.url');
  final tweets = [
    const Tweet('Hello', null, sender, null),
    const Tweet('World', null, sender, null),
  ];

  setUp(() {
    mockUserRepo = MockUserRepository();
    mockTweetRepo = MockTweetRepository();
    repository = MomentsRepository(
      userRepository: mockUserRepo,
      tweetRepository: mockTweetRepo,
    );
  });

  test('should fetch user and tweets concurrently', () async {
    when(mockUserRepo.getUser()).thenAnswer((_) async => user);
    when(mockTweetRepo.getTweets(0, 20)).thenAnswer((_) async => tweets);

    final result = await repository.getMoments();

    expect(result.user.username, 'john');
    expect(result.tweets.length, 2);
    verify(mockUserRepo.getUser()).called(1);
    verify(mockTweetRepo.getTweets(0, 20)).called(1);
  });

  test('should return correct MomentsData', () async {
    when(mockUserRepo.getUser()).thenAnswer((_) async => user);
    when(mockTweetRepo.getTweets(0, 20)).thenAnswer((_) async => tweets);

    final result = await repository.getMoments();

    expect(result.user, user);
    expect(result.tweets, tweets);
  });

  test('should propagate user repo error', () async {
    when(mockUserRepo.getUser()).thenThrow(Exception('User error'));
    when(mockTweetRepo.getTweets(0, 20)).thenAnswer((_) async => tweets);

    expect(() => repository.getMoments(), throwsException);
  });

  test('should propagate tweet repo error', () async {
    when(mockUserRepo.getUser()).thenAnswer((_) async => user);
    when(mockTweetRepo.getTweets(0, 20)).thenThrow(Exception('Tweet error'));

    expect(() => repository.getMoments(), throwsException);
  });
}
