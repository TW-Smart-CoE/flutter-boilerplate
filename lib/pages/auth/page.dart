import 'package:first_demo/common/scaffold/base_scaffold.dart';
import 'package:first_demo/common/utils/logger.dart';
import 'package:first_demo/pages/auth/repository.dart';
import 'package:first_demo/res/string/strings.dart';
import 'package:first_demo/res/theme/dimension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fquery/fquery.dart';

typedef LoginParams = ({String username, String password});

class AuthPage extends HookWidget {
  final AuthRepository _repository;

  AuthPage({super.key, AuthRepository? repository})
      : _repository = repository ?? AuthRepository();

  @override
  Widget build(BuildContext context) {
    final strings = stringsOf(context);
    final usernameController = useTextEditingController(text: 'admin');
    final passwordController = useTextEditingController(text: '123456');

    final loginMutation = useMutation<void, Exception, LoginParams, void>(
      (params) => _repository.login(params.username, params.password),
      onError: (error, _, __) {
        logger.e('Login failed', error: error);
      },
    );

    void handleLogin() {
      final username = usernameController.text.trim();
      final password = passwordController.text.trim();

      if (username.isEmpty || password.isEmpty) {
        return;
      }

      loginMutation.mutate((username: username, password: password));
    }

    final isLoading = loginMutation.isPending;

    return BaseScaffold(
      context: context,
      title: strings.loginPageTitle,
      body: Padding(
        padding: const EdgeInsets.all(EdgeInset.M),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(
                labelText: strings.loginUsername,
                prefixIcon: const Icon(Icons.person),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: EdgeInset.S),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: strings.loginPassword,
                prefixIcon: const Icon(Icons.lock),
                border: const OutlineInputBorder(),
              ),
            ),
            if (loginMutation.error != null) ...[
              const SizedBox(height: EdgeInset.XXS),
              Text(
                strings.loginFailedError,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
            const SizedBox(height: EdgeInset.M),
            SizedBox(
              width: double.infinity,
              height: WidgetSize.L,
              child: FilledButton(
                onPressed: isLoading ? null : handleLogin,
                child: isLoading
                    ? const SizedBox(
                        width: WidgetSize.XS,
                        height: WidgetSize.XS,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(strings.loginButton),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
