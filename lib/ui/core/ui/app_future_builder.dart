import 'package:flutter/material.dart';

class AppFutureBuilder<T> extends StatelessWidget {
  final Future<T> future;
  final AsyncWidgetBuilder<T> builder;
  final String? emptyMessage;
  final bool Function(T data)? isEmpty;

  const AppFutureBuilder({
    super.key,
    required this.future,
    required this.builder,
    this.emptyMessage,
    this.isEmpty,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        } else if (!snapshot.hasData ||
            (isEmpty?.call(snapshot.data as T) ?? false)) {
          return Center(child: Text(emptyMessage ?? 'No data available.'));
        }

        return builder(context, snapshot);
      },
    );
  }
}
