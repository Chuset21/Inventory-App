import 'package:flutter/material.dart';
import 'package:inventory_app/presentation/widgets/widgets.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: DefaultAppBar(
        title: Text('Loading...'),
      ),
      body: Center(
        child: CircularProgressIndicator(), // The loading spinner
      ),
    );
  }
}
