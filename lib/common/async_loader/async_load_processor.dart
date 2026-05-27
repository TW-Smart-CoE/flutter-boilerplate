import 'package:first_demo/common/async_loader/async_load_controller.dart';
import 'package:first_demo/common/async_loader/error_placeholder.dart';
import 'package:first_demo/common/async_loader/load_state.dart';
import 'package:first_demo/common/async_loader/loading_placeholder.dart';
import 'package:first_demo/res/string/strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Widget _errorView(BuildContext context, Object error, VoidCallback onRetry) {
  return ErrorPlaceholder(
    context: context,
    errorType:
        error is Exception ? ErrorType.connection : ErrorType.loadingOrParsing,
    onRetry: onRetry,
  );
}

void _showErrorAlert(BuildContext context, Object error) {
  final type =
      error is Exception ? ErrorType.connection : ErrorType.loadingOrParsing;
  final loc = l10n(context);
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('${type.title(loc)}: ${type.subTitle(loc)}')),
  );
}

// ignore: non_constant_identifier_names
Widget AsyncLoadProcessor<T>(
  BuildContext context,
  AsyncLoadController<T> asyncLoadController, {
  bool showLoadingInReload = true,
  Widget? loadingView,
  Widget Function(BuildContext context, Object error, VoidCallback onRetry)
      errorView = _errorView,
  Function(BuildContext context, Object error) showErrorAlert = _showErrorAlert,
  required Widget Function(T data) content,
}) {
  final nonNullLoadingView = loadingView ?? LoadingPlaceholder(context);
  return Builder(
    builder: (context) {
      return Obx(() {
        final loadState = asyncLoadController.loadState();
        if (loadState is Loading<T>) {
          final data = loadState.data;
          if (data == null) {
            return nonNullLoadingView;
          } else {
            // reload
            if (showLoadingInReload) {
              return nonNullLoadingView;
            } else {
              return content(data);
            }
          }
        } else if (loadState is Success<T>) {
          return content(loadState.data);
        } else if (loadState is Failure<T>) {
          final data = loadState.data;
          if (data == null) {
            return errorView(context, loadState.error, () {
              asyncLoadController.load();
            });
          } else {
            showErrorAlert(context, loadState.error);
            return content(data);
          }
        } else {
          return Container();
        }
      });
    },
  );
}
