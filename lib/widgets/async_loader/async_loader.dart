import 'package:first_demo/widgets/async_loader/error_placeholder.dart';
import 'package:first_demo/widgets/async_loader/loading_placeholder.dart';
import 'package:flutter/material.dart';
import 'package:fquery_core/fquery_core.dart';

/// A builder widget that handles the loading/error/success states
/// from a fquery [QueryResult].
// ignore: non_constant_identifier_names
Widget AsyncLoader<T>({
  required BuildContext context,
  required QueryResult<T, Exception> query,
  required Widget Function(T data) builder,
  Widget? loadingWidget,
  Widget Function(BuildContext context, Exception error, VoidCallback onRetry)? errorWidget,
}) {
  if (query.isLoading) {
    return loadingWidget ?? LoadingPlaceholder(context);
  }

  if (query.isError) {
    final error = query.error!;
    if (errorWidget != null) {
      return errorWidget(context, error, () => query.refetch());
    }
    return ErrorPlaceholder(
      context: context,
      errorType: ErrorType.loadingOrParsing,
      onRetry: () => query.refetch(),
    );
  }

  if (query.isSuccess && query.data != null) {
    return builder(query.data as T);
  }

  return LoadingPlaceholder(context);
}
