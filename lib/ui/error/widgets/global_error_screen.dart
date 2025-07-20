import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_provider_local_save/configs/getit_config.dart';
import 'package:flutter_provider_local_save/ui/error/viewmodel/error_viewmodel.dart';
import 'package:go_router/go_router.dart';
import 'dart:html' as html;

class GlobalErrorScreen extends StatelessWidget {
  final Widget? child;

  GlobalErrorScreen({super.key, this.child});

  final ErrorViewModel _errorViewModel = locator<ErrorViewModel>();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _errorViewModel,
      builder: (context, _) {
        final error = _errorViewModel.error;
        if (error != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Error: $error')));
            _errorViewModel.clear();
          });
        } else {
          if (kReleaseMode) exit(1);
          Widget errorContent = Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Icon in circular background
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(24),
                      child: Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 64,
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Title
                    const Text(
                      'Something went wrong',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Subtitle
                    const Text(
                      'An unexpected error occurred.\nPlease try again later.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),

                    const SizedBox(height: 32),

                    // Reload Button
                    ElevatedButton.icon(
                      onPressed: () {
                        // Optional: Restart logic, or navigate back
                        if (kIsWeb) {
                          // Reload trang trên web
                          html.window.location.reload();
                        }
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Try Again'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );

          if (child is Scaffold || child is Navigator) {
            errorContent = Scaffold(
              backgroundColor: Colors.white,
              body: errorContent,
            );
          }
          ErrorWidget.builder = (errorDetails) => errorContent;
        }
        if (child != null) return child!;
        throw StateError('widget is null');
      },
    );
  }
}
