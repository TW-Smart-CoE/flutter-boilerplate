import 'package:first_demo/features/moments/api_moments.dart';
import 'package:first_demo/features/moments/user/model_user.dart';
import 'package:first_demo/features/moments/user/repository_user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'repository_user_test.mocks.dart';

@GenerateNiceMocks([MockSpec<MomentsApi>()])
void main() {
  late MockMomentsApi mockApi;
  late UserRepository repository;

  const user = User('john', 'John Doe', 'https://avatar.url', 'https://profile.url');

  setUp(() {
    mockApi = MockMomentsApi();
    repository = UserRepository(momentsApi: mockApi);
  });

  test('should return user from api', () async {
    when(mockApi.getUser()).thenAnswer((_) async => user);

    final result = await repository.getUser();

    expect(result.username, 'john');
    expect(result.nick, 'John Doe');
    verify(mockApi.getUser()).called(1);
  });

  test('should propagate api error', () async {
    when(mockApi.getUser()).thenThrow(Exception('Network error'));

    expect(() => repository.getUser(), throwsException);
  });
}
